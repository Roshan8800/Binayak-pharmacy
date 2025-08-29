import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  State<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isProcessing = false;
  String _currentCommand = '';
  late AnimationController _pulseController;
  late AnimationController _waveController;

  final List<VoiceCommand> _recentCommands = [
    VoiceCommand('Add 50 Paracetamol to inventory', DateTime.now().subtract(const Duration(minutes: 2)), true),
    VoiceCommand('Show sales report for today', DateTime.now().subtract(const Duration(minutes: 5)), true),
    VoiceCommand('Find customer John Doe', DateTime.now().subtract(const Duration(minutes: 8)), true),
    VoiceCommand('Check expiring medicines', DateTime.now().subtract(const Duration(minutes: 12)), true),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_voice),
            onPressed: () => _showVoiceSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showVoiceCommands(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Voice Status Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isListening 
                    ? [Colors.blue[400]!, Colors.blue[600]!]
                    : [Colors.grey[300]!, Colors.grey[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isListening ? Icons.mic : Icons.mic_off,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isListening ? 'Listening...' : 'Voice Assistant Ready',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_isListening)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                if (_currentCommand.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentCommand,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),

          // Voice Visualizer
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: _isListening
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return AnimatedBuilder(
                          animation: _waveController,
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 20 + (30 * (0.5 + 0.5 * 
                                (1 + math.sin(_waveController.value * 2 * math.pi + index * 0.5)))),
                              width: 4,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        );
                      }),
                    )
                  : Icon(
                      Icons.graphic_eq,
                      size: 60,
                      color: Colors.grey[400],
                    ),
            ),
          ),

          // Quick Voice Commands
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Commands',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickCommandChip('Show today sales', Icons.trending_up),
                    _QuickCommandChip('Check inventory', Icons.inventory),
                    _QuickCommandChip('Add medicine', Icons.add),
                    _QuickCommandChip('Find customer', Icons.search),
                    _QuickCommandChip('Low stock alert', Icons.warning),
                    _QuickCommandChip('Generate report', Icons.analytics),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

          // Recent Commands
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Commands',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _recentCommands.length,
                      itemBuilder: (context, index) {
                        final command = _recentCommands[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: command.isSuccessful 
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              child: Icon(
                                command.isSuccessful ? Icons.check : Icons.error,
                                color: command.isSuccessful ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(command.text),
                            subtitle: Text(_formatTime(command.timestamp)),
                            trailing: IconButton(
                              icon: const Icon(Icons.replay),
                              onPressed: () => _executeCommand(command.text),
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 100).ms);
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
        onPressed: _toggleListening,
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? 1.0 + (_pulseController.value * 0.1) : 1.0,
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                size: 32,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _startListening();
      } else {
        _stopListening();
      }
    });
  }

  void _startListening() {
    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 2), () {
      if (_isListening) {
        setState(() {
          _currentCommand = 'Show me today\'s sales report';
          _isProcessing = true;
        });
        
        Future.delayed(const Duration(seconds: 1), () {
          _executeCommand(_currentCommand);
        });
      }
    });
  }

  void _stopListening() {
    setState(() {
      _currentCommand = '';
      _isProcessing = false;
    });
  }

  void _executeCommand(String command) {
    setState(() {
      _isListening = false;
      _isProcessing = false;
      _currentCommand = '';
    });

    // Add to recent commands
    _recentCommands.insert(0, VoiceCommand(command, DateTime.now(), true));
    if (_recentCommands.length > 10) {
      _recentCommands.removeLast();
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executed: $command'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('English (US)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Voice Feedback'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Recognition Speed'),
              subtitle: const Text('Fast'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceCommands() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Commands'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Inventory Commands:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• "Add [quantity] [medicine] to inventory"'),
              const Text('• "Check stock for [medicine]"'),
              const Text('• "Show low stock items"'),
              const SizedBox(height: 12),
              const Text('Sales Commands:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• "Show today\'s sales"'),
              const Text('• "Create new sale"'),
              const Text('• "Show sales report"'),
              const SizedBox(height: 12),
              const Text('Customer Commands:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('• "Find customer [name]"'),
              const Text('• "Add new customer"'),
              const Text('• "Show customer history"'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

class _QuickCommandChip extends StatelessWidget {
  final String command;
  final IconData icon;

  const _QuickCommandChip(this.command, this.icon);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(command),
      onPressed: () {
        // Execute quick command
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Executing: $command')),
        );
      },
    );
  }
}

class VoiceCommand {
  final String text;
  final DateTime timestamp;
  final bool isSuccessful;

  VoiceCommand(this.text, this.timestamp, this.isSuccessful);
}

