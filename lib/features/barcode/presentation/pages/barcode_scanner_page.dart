import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanning = false;
  String _scannedCode = '';
  final List<ScannedItem> _scannedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showScanHistory(),
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Scanner View
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: _isScanning
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Scanning...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ).animate(onPlay: (controller) => controller.repeat())
                                .shimmer(duration: 1500.ms, color: Colors.green),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 80,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tap to start scanning',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isScanning ? Icons.stop : Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isScanning ? 'Stop' : 'Start',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scan Result
          if (_scannedCode.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'Scanned Successfully',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Code: $_scannedCode'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addToInventory(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add to Inventory'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _searchMedicine(),
                          icon: const Icon(Icons.search),
                          label: const Text('Search'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 16),

          // Quick Actions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: 'Inventory Check',
                        subtitle: 'Scan to verify stock',
                        icon: Icons.inventory,
                        color: Colors.blue,
                        onTap: () => _startInventoryCheck(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'Quick Sale',
                        subtitle: 'Scan for instant sale',
                        icon: Icons.point_of_sale,
                        color: Colors.green,
                        onTap: () => _startQuickSale(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Recent Scans
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Scans',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _scannedItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No recent scans',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _scannedItems.length,
                            itemBuilder: (context, index) {
                              final item = _scannedItems[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.withOpacity(0.2),
                                    child: const Icon(Icons.qr_code, color: Colors.blue),
                                  ),
                                  title: Text(item.code),
                                  subtitle: Text(item.productName ?? 'Unknown Product'),
                                  trailing: Text(_formatTime(item.timestamp)),
                                ),
                              ).animate().fadeIn(delay: (index * 50).ms);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _toggleScanning,
        backgroundColor: _isScanning ? Colors.red : Colors.blue,
        child: Icon(
          _isScanning ? Icons.stop : Icons.qr_code_scanner,
          size: 32,
        ),
      ),
    );
  }

  void _toggleScanning() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        _startScanning();
      } else {
        _stopScanning();
      }
    });
  }

  void _startScanning() {
    // Simulate barcode scanning
    Future.delayed(const Duration(seconds: 3), () {
      if (_isScanning) {
        final code = '${DateTime.now().millisecondsSinceEpoch}';
        setState(() {
          _scannedCode = code;
          _isScanning = false;
          _scannedItems.insert(0, ScannedItem(
            code: code,
            timestamp: DateTime.now(),
            productName: 'Paracetamol 500mg',
          ));
        });
      }
    });
  }

  void _stopScanning() {
    setState(() {
      _scannedCode = '';
    });
  }

  void _addToInventory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to inventory'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      _scannedCode = '';
    });
  }

  void _searchMedicine() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Searching for medicine...')),
    );
  }

  void _startInventoryCheck() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting inventory check mode')),
    );
  }

  void _startQuickSale() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting quick sale mode')),
    );
  }

  void _showScanHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.qr_code),
                    title: Text('Scan ${index + 1}'),
                    subtitle: Text('${DateTime.now().subtract(Duration(hours: index)).hour}:00'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
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

class ScannedItem {
  final String code;
  final DateTime timestamp;
  final String? productName;

  ScannedItem({
    required this.code,
    required this.timestamp,
    this.productName,
  });
}