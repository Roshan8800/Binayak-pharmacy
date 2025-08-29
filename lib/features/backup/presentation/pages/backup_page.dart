import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _autoBackupEnabled = true;
  String _backupFrequency = 'Daily';
  DateTime? _lastBackup = DateTime.now().subtract(const Duration(hours: 6));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showBackupHistory(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backup Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.cloud_done, color: Colors.green),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Backup Status',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Last backup: ${_formatLastBackup()}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Up to date',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text('All data backed up successfully'),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 16),

            // Quick Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            title: 'Backup Now',
                            subtitle: 'Create instant backup',
                            icon: Icons.backup,
                            color: Colors.blue,
                            onTap: () => _createBackup(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            title: 'Restore',
                            subtitle: 'Restore from backup',
                            icon: Icons.restore,
                            color: Colors.orange,
                            onTap: () => _showRestoreOptions(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

            const SizedBox(height: 16),

            // Auto Backup Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Backup Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Enable Auto Backup'),
                      subtitle: const Text('Automatically backup data'),
                      value: _autoBackupEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoBackupEnabled = value;
                        });
                      },
                    ),
                    if (_autoBackupEnabled) ...[
                      const Divider(),
                      ListTile(
                        title: const Text('Backup Frequency'),
                        subtitle: Text(_backupFrequency),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showFrequencyOptions(),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Backup Location'),
                        subtitle: const Text('Cloud Storage'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showLocationOptions(),
                      ),
                    ],
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 16),

            // Data Categories
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Backup Data Categories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DataCategoryTile(
                      title: 'Medicines',
                      subtitle: '1,234 items • 2.5 MB',
                      icon: Icons.medication,
                      isEnabled: true,
                    ),
                    _DataCategoryTile(
                      title: 'Sales Records',
                      subtitle: '5,678 transactions • 8.2 MB',
                      icon: Icons.point_of_sale,
                      isEnabled: true,
                    ),
                    _DataCategoryTile(
                      title: 'Customer Data',
                      subtitle: '890 customers • 1.8 MB',
                      icon: Icons.people,
                      isEnabled: true,
                    ),
                    _DataCategoryTile(
                      title: 'Prescriptions',
                      subtitle: '456 prescriptions • 3.1 MB',
                      icon: Icons.receipt,
                      isEnabled: true,
                    ),
                    _DataCategoryTile(
                      title: 'Reports',
                      subtitle: '123 reports • 5.4 MB',
                      icon: Icons.analytics,
                      isEnabled: false,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 16),

            // Storage Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StorageCard(
                            title: 'Used Space',
                            value: '21.0 MB',
                            icon: Icons.storage,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StorageCard(
                            title: 'Available',
                            value: '4.98 GB',
                            icon: Icons.cloud,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.004,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    const Text('0.4% of 5 GB used'),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  void _createBackup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Creating Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Backing up your data...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      setState(() {
        _lastBackup = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showRestoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Restore Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore from Latest Backup'),
              subtitle: Text('${_formatLastBackup()}'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Choose Backup Date'),
              subtitle: const Text('Select from backup history'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Import Backup File'),
              subtitle: const Text('Restore from local file'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showFrequencyOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Hourly'),
              value: 'Hourly',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Daily'),
              value: 'Daily',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Weekly'),
              value: 'Weekly',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Cloud Storage'),
              subtitle: const Text('Google Drive, Dropbox'),
              trailing: const Icon(Icons.check, color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Local Storage'),
              subtitle: const Text('Device internal storage'),
            ),
            ListTile(
              leading: const Icon(Icons.sd_card),
              title: const Text('External Storage'),
              subtitle: const Text('SD Card, USB Drive'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final date = DateTime.now().subtract(Duration(days: index));
                  return ListTile(
                    leading: const Icon(Icons.backup),
                    title: Text('Backup ${index + 1}'),
                    subtitle: Text('${date.day}/${date.month}/${date.year} - 21.${index} MB'),
                    trailing: IconButton(
                      icon: const Icon(Icons.restore),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastBackup() {
    if (_lastBackup == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(_lastBackup!);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataCategoryTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;

  const _DataCategoryTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
  });

  @override
  State<_DataCategoryTile> createState() => _DataCategoryTileState();
}

class _DataCategoryTileState extends State<_DataCategoryTile> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      secondary: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      value: _enabled,
      onChanged: (value) {
        setState(() {
          _enabled = value ?? false;
        });
      },
    );
  }
}

class _StorageCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StorageCard({
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}