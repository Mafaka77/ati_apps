import 'package:flutter/material.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({
    super.key,
    this.title = 'Network Error',
    this.message =
        'We couldn’t connect to the internet.\nPlease check your connection and try again.',
    required this.onRetry,
    this.onOpenSettings,
    this.icon,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings; // optional: open device/network settings
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative blob
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            isDark
                                ? [
                                  Colors.blueGrey.shade800,
                                  Colors.indigo.shade700,
                                ]
                                : [
                                  Colors.indigo.shade200,
                                  Colors.blue.shade200,
                                ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon ?? Icons.wifi_off_rounded,
                        size: 64,
                        color:
                            isDark
                                ? Colors.white
                                : Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Retry button (primary)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: theme.colorScheme.secondary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Check Wi-Fi or Mobile Data',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (onOpenSettings != null)
                    TextButton.icon(
                      onPressed: onOpenSettings,
                      icon: const Icon(Icons.settings_rounded),
                      label: const Text('Open Network Settings'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Pull-to-retry hint
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'Tip: Pull down to refresh on lists.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
