import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Settings
              Text(
                'Account',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to edit profile
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to change password
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Notifications
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Enable Notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    if (_notificationsEnabled) ...[
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.email_outlined),
                        title: const Text('Email Notifications'),
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: const Icon(Icons.phone_android_outlined),
                        title: const Text('Push Notifications'),
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Preferences
              Text(
                'Preferences',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedLanguage,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        _showLanguageDialog();
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: const Text('Currency'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCurrency,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        _showCurrencyDialog();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // About
              Text(
                'About',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('App Version'),
                      trailing: const Text('1.0.0'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Show terms
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Show privacy policy
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('Spanish'),
            _buildLanguageOption('French'),
            _buildLanguageOption('German'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: _selectedLanguage == language
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption('USD'),
            _buildCurrencyOption('EUR'),
            _buildCurrencyOption('GBP'),
            _buildCurrencyOption('INR'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String currency) {
    return ListTile(
      title: Text(currency),
      trailing: _selectedCurrency == currency
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() {
          _selectedCurrency = currency;
        });
        Navigator.pop(context);
      },
    );
  }
}

