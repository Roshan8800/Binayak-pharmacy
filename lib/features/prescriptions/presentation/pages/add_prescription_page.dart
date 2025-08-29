import 'package:flutter/material.dart';

class AddPrescriptionPage extends StatefulWidget {
  const AddPrescriptionPage({super.key});

  @override
  State<AddPrescriptionPage> createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _patientController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _prescriptionDate;
  final List<PrescriptionMedicine> _medicines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prescription'),
        actions: [
          FilledButton(
            onPressed: _savePrescription,
            child: const Text('Save'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prescription Details', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _patientController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name *',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _doctorController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor Name *',
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(_prescriptionDate == null ? 'Select Prescription Date' : 
                        '${_prescriptionDate!.day}/${_prescriptionDate!.month}/${_prescriptionDate!.year}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _selectDate,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Medicines', style: Theme.of(context).textTheme.titleMedium),
                        FilledButton.icon(
                          onPressed: _addMedicine,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Medicine'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_medicines.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.medication_outlined, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('No medicines added yet', style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                    else
                      ..._medicines.asMap().entries.map((entry) {
                        final index = entry.key;
                        final medicine = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.medication),
                            title: Text(medicine.name),
                            subtitle: Text('${medicine.dosage} | ${medicine.frequency} | ${medicine.duration}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeMedicine(index),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Additional Notes', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _prescriptionDate = date);
    }
  }

  void _addMedicine() {
    showDialog(
      context: context,
      builder: (context) => _AddMedicineDialog(
        onAdd: (medicine) {
          setState(() => _medicines.add(medicine));
        },
      ),
    );
  }

  void _removeMedicine(int index) {
    setState(() => _medicines.removeAt(index));
  }

  void _savePrescription() {
    if (_formKey.currentState!.validate() && _medicines.isNotEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved successfully!')),
      );
    } else if (_medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medicine')),
      );
    }
  }
}

class _AddMedicineDialog extends StatefulWidget {
  final Function(PrescriptionMedicine) onAdd;

  const _AddMedicineDialog({required this.onAdd});

  @override
  State<_AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<_AddMedicineDialog> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Medicine'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Medicine Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _dosageController,
            decoration: const InputDecoration(labelText: 'Dosage (e.g., 500mg)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _frequencyController,
            decoration: const InputDecoration(labelText: 'Frequency (e.g., 3 times daily)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duration (e.g., 7 days)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(PrescriptionMedicine(
                name: _nameController.text,
                dosage: _dosageController.text,
                frequency: _frequencyController.text,
                duration: _durationController.text,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class PrescriptionMedicine {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;

  PrescriptionMedicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
  });
}