import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing and using Binayak Pharmacy management system, you accept and agree to be bound by the terms and provision of this agreement.',
              0,
            ),
            
            _buildSection(
              context,
              '2. Data Privacy',
              'We are committed to protecting your privacy. All customer and medicine data is stored securely and used only for pharmacy management purposes.',
              1,
            ),
            
            _buildSection(
              context,
              '3. User Responsibilities',
              'Users are responsible for maintaining confidentiality of login credentials, ensuring accurate data entry, and following pharmacy regulations.',
              2,
            ),
            
            _buildSection(
              context,
              '4. System Availability',
              'While we strive for 99.9% uptime, we cannot guarantee uninterrupted service. Scheduled maintenance will be announced in advance.',
              3,
            ),
            
            _buildSection(
              context,
              '5. Contact Information',
              'For questions about these Terms & Conditions, please contact:\n\nBinayak Pharmacy\nOwner: Suman Sahu\nDeveloper: Roshan',
              4,
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Important Notice',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This software is designed to assist in pharmacy management but does not replace professional pharmaceutical knowledge and judgment.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 600.ms);
  }
}