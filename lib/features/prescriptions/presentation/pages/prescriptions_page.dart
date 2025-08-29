import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_prescription_page.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.receipt)),
            Tab(text: 'Pending', icon: Icon(Icons.pending)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
            Tab(text: 'AI Analysis', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => _scanPrescription(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AllPrescriptionsTab(),
          _PendingPrescriptionsTab(),
          _CompletedPrescriptionsTab(),
          _AIAnalysisTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPrescriptionPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Prescription'),
      ),
    );
  }

  void _scanPrescription() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Scan with Camera'),
              subtitle: const Text('AI-powered prescription scanning'),
              onTap: () {
                Navigator.pop(context);
                _showAIScanDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select prescription image'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('QR Code Scanner'),
              subtitle: const Text('Scan prescription QR code'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAIScanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Prescription Scanner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 48),
                    SizedBox(height: 8),
                    Text('AI Scanning in Progress...'),
                    SizedBox(height: 16),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('AI is analyzing the prescription and extracting medicine details...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _AllPrescriptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 25,
      itemBuilder: (context, index) {
        return _PrescriptionCard(
          prescriptionId: 'RX${1000 + index}',
          patientName: 'Patient ${index + 1}',
          doctorName: 'Dr. ${['Smith', 'Johnson', 'Williams', 'Brown', 'Davis'][index % 5]}',
          date: DateTime.now().subtract(Duration(days: index)),
          status: ['Pending', 'Completed', 'In Progress'][index % 3],
          medicineCount: 2 + (index % 4),
          isAIAnalyzed: index % 3 == 0,
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _PendingPrescriptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _PrescriptionCard(
          prescriptionId: 'RX${2000 + index}',
          patientName: 'Patient ${index + 1}',
          doctorName: 'Dr. Smith',
          date: DateTime.now().subtract(Duration(hours: index * 2)),
          status: 'Pending',
          medicineCount: 3 + (index % 3),
          isAIAnalyzed: true,
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _CompletedPrescriptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return _PrescriptionCard(
          prescriptionId: 'RX${3000 + index}',
          patientName: 'Patient ${index + 1}',
          doctorName: 'Dr. Johnson',
          date: DateTime.now().subtract(Duration(days: index + 1)),
          status: 'Completed',
          medicineCount: 2 + (index % 5),
          isAIAnalyzed: true,
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _AIAnalysisTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'AI Prescription Analytics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _AnalyticsCard(
                          title: 'Scanned Today',
                          value: '23',
                          icon: Icons.camera_alt,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AnalyticsCard(
                          title: 'AI Accuracy',
                          value: '98.5%',
                          icon: Icons.verified,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Common Medicines Prescribed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...['Paracetamol', 'Amoxicillin', 'Crocin', 'Aspirin', 'Ibuprofen'].asMap().entries.map((entry) {
                    final index = entry.key;
                    final medicine = entry.value;
                    final count = 45 - (index * 8);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(medicine)),
                          Text('$count prescriptions'),
                          const SizedBox(width: 8),
                          Container(
                            width: 100,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: count / 45,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final String prescriptionId;
  final String patientName;
  final String doctorName;
  final DateTime date;
  final String status;
  final int medicineCount;
  final bool isAIAnalyzed;

  const _PrescriptionCard({
    required this.prescriptionId,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.status,
    required this.medicineCount,
    required this.isAIAnalyzed,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Completed' 
        ? Colors.green 
        : status == 'Pending' 
            ? Colors.orange 
            : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.receipt, color: statusColor),
        ),
        title: Row(
          children: [
            Text(prescriptionId, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            if (isAIAnalyzed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: $patientName'),
            Text('Doctor: $doctorName'),
            Text('Medicines: $medicineCount | ${_formatDate(date)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(status),
              backgroundColor: statusColor.withOpacity(0.1),
              labelStyle: TextStyle(color: statusColor, fontSize: 10),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showPrescriptionOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays} days ago';
  }

  void _showPrescriptionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('View Details'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Prescription'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Print'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}