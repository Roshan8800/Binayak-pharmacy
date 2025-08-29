import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/medicine_bloc.dart';
import '../../data/models/medicine_model.dart';
import 'add_medicine_page.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MedicineBloc>().add(LoadMedicines());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search medicines...',
              leading: const Icon(Icons.search),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<MedicineBloc>().add(LoadMedicines());
                } else {
                  context.read<MedicineBloc>().add(SearchMedicines(value));
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MedicineBloc, MedicineState>(
              builder: (context, state) {
                if (state is MedicineLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MedicineLoaded) {
                  if (state.medicines.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No medicines found', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text('Add your first medicine to get started', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = state.medicines[index];
                      return _MedicineCard(medicine: medicine).animate().fadeIn(delay: (index * 100).ms);
                    },
                  );
                } else if (state is MedicineError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicinePage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const _MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final isLowStock = medicine.stockQuantity <= medicine.minStockLevel;
    final isExpiringSoon = medicine.expiryDate != null && 
        medicine.expiryDate!.difference(DateTime.now()).inDays <= 30;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.medication, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (medicine.genericName != null) Text('Generic: ${medicine.genericName}'),
            Text('Stock: ${medicine.stockQuantity} | Price: ₹${medicine.sellingPrice}'),
            if (isLowStock || isExpiringSoon)
              Wrap(
                spacing: 8,
                children: [
                  if (isLowStock)
                    Chip(
                      label: const Text('Low Stock', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.orange[100],
                      labelStyle: TextStyle(color: Colors.orange[800]),
                    ),
                  if (isExpiringSoon)
                    Chip(
                      label: const Text('Expiring Soon', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.red[100],
                      labelStyle: TextStyle(color: Colors.red[800]),
                    ),
                ],
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteDialog(context);
            }
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
            onPressed: () {
              context.read<MedicineBloc>().add(DeleteMedicine(medicine.id!));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}