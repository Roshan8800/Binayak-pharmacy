import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/user_interactions/interaction_handler.dart';
import '../../../../core/workflows/medicine_workflow.dart';
import '../../../../core/business_logic/pharmacy_rules.dart';
import '../../../medicines/presentation/bloc/medicine_bloc.dart';
import '../../../medicines/data/models/medicine_model.dart';

class EnhancedMedicinesPage extends StatefulWidget {
  const EnhancedMedicinesPage({super.key});

  @override
  State<EnhancedMedicinesPage> createState() => _EnhancedMedicinesPageState();
}

class _EnhancedMedicinesPageState extends State<EnhancedMedicinesPage> {
  final TextEditingController _searchController = TextEditingController();
  final MedicineWorkflow _workflow = MedicineWorkflow();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<MedicineBloc>().add(LoadMedicines());
    InteractionHandler().handleNavigation('Dashboard', 'Medicines', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SearchBar(
                  controller: _searchController,
                  hintText: 'Search medicines...',
                  leading: const Icon(Icons.search),
                  onChanged: (value) {
                    InteractionHandler().handleFormInput('medicine_search', value, context);
                    _performSearch(value);
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip('All', _selectedFilter == 'All'),
                      _FilterChip('Low Stock', _selectedFilter == 'Low Stock'),
                      _FilterChip('Expiring Soon', _selectedFilter == 'Expiring Soon'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: BlocBuilder<MedicineBloc, MedicineState>(
              builder: (context, state) {
                if (state is MedicineLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MedicineLoaded) {
                  final filteredMedicines = _filterMedicines(state.medicines);
                  
                  if (filteredMedicines.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = filteredMedicines[index];
                      return _EnhancedMedicineCard(
                        medicine: medicine,
                        onTap: () => _handleMedicineTap(medicine),
                        onLongPress: () => _handleMedicineLongPress(medicine),
                        workflow: _workflow,
                      ).animate().fadeIn(delay: (index * 50).ms);
                    },
                  );
                } else if (state is MedicineError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddMedicine(),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
    );
  }

  List<Medicine> _filterMedicines(List<Medicine> medicines) {
    List<Medicine> filtered = medicines;

    switch (_selectedFilter) {
      case 'Low Stock':
        filtered = medicines.where((m) => 
          !PharmacyRules.validateMedicineStock(m.stockQuantity, m.minStockLevel)
        ).toList();
        break;
      case 'Expiring Soon':
        filtered = medicines.where((m) => 
          m.expiryDate != null && PharmacyRules.isExpiringSoon(m.expiryDate!)
        ).toList();
        break;
    }

    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((m) =>
        m.name.toLowerCase().contains(searchQuery) ||
        (m.genericName?.toLowerCase().contains(searchQuery) ?? false)
      ).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No medicines found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddMedicine(),
            icon: const Icon(Icons.add),
            label: const Text('Add First Medicine'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text('Error loading medicines', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<MedicineBloc>().add(LoadMedicines()),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _FilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'All';
          });
          InteractionHandler().handleTap('filter_$label', context);
        },
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      context.read<MedicineBloc>().add(LoadMedicines());
    } else {
      context.read<MedicineBloc>().add(SearchMedicines(query));
    }
  }

  void _handleMedicineTap(Medicine medicine) {
    InteractionHandler().handleTap('medicine_${medicine.id}', context);
    _showMedicineDetails(medicine);
  }

  void _handleMedicineLongPress(Medicine medicine) {
    InteractionHandler().handleLongPress('medicine_${medicine.id}', context);
    _showMedicineActions(medicine);
  }

  void _showMedicineDetails(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(medicine.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ₹${medicine.sellingPrice}'),
            Text('Stock: ${medicine.stockQuantity}'),
            if (medicine.expiryDate != null)
              Text('Expires: ${medicine.expiryDate!.day}/${medicine.expiryDate!.month}/${medicine.expiryDate!.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMedicineActions(Medicine medicine) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Medicine'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('Quick Sale'),
            onTap: () {
              Navigator.pop(context);
              _showQuickSaleDialog(medicine);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Medicine', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(medicine);
            },
          ),
        ],
      ),
    );
  }

  void _showQuickSaleDialog(Medicine medicine) {
    final quantityController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quick Sale - ${medicine.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available Stock: ${medicine.stockQuantity}'),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity to Sell',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              final result = await _workflow.processMedicineSale(medicine.id!, quantity);
              
              Navigator.pop(context);
              
              if (result.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.message), backgroundColor: Colors.green),
                );
                context.read<MedicineBloc>().add(LoadMedicines());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.message), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Process Sale'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              context.read<MedicineBloc>().add(DeleteMedicine(medicine.id!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Medicines'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Medicines'),
              value: 'All',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Low Stock'),
              value: 'Low Stock',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Expiring Soon'),
              value: 'Expiring Soon',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMedicine() {
    InteractionHandler().handleNavigation('Medicines', 'AddMedicine', context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Medicine feature')),
    );
  }
}

class _EnhancedMedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final MedicineWorkflow workflow;

  const _EnhancedMedicineCard({
    required this.medicine,
    required this.onTap,
    required this.onLongPress,
    required this.workflow,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = !PharmacyRules.validateMedicineStock(medicine.stockQuantity, medicine.minStockLevel);
    final isExpiringSoon = medicine.expiryDate != null && PharmacyRules.isExpiringSoon(medicine.expiryDate!);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        if (medicine.genericName != null)
                          Text(
                            medicine.genericName!,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${medicine.sellingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.inventory,
                    label: '${medicine.stockQuantity} units',
                    color: isLowStock ? Colors.red : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  if (medicine.expiryDate != null)
                    _InfoChip(
                      icon: Icons.schedule,
                      label: '${medicine.expiryDate!.difference(DateTime.now()).inDays}d',
                      color: isExpiringSoon ? Colors.red : Colors.green,
                    ),
                ],
              ),
              if (isLowStock || isExpiringSoon) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LOW STOCK',
                          style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (isExpiringSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'EXPIRING SOON',
                          style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _InfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}