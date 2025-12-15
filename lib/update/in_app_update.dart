import 'dart:developer' as mobigiclog;
import 'package:flutter/material.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

class AppUpdateService with WidgetsBindingObserver {
  final InAppUpdateManager _inAppUpdateManager = InAppUpdateManager();
  bool _isStartingUpdate = false;
  bool _forceUpdatePending = false;
  bool _isDialogVisible = false;
  int versionCode = 0;

  BuildContext? _lastContext;

  /// must be called in main() of your app
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _forceUpdatePending) {
      if (!_isDialogVisible) {
        Future.delayed(const Duration(milliseconds: 500), () {
          final ctx = _lastContext;
          if (ctx != null && ctx.mounted) {
            _showForceUpdateDialog(ctx);
          }
        });
      }
    }
  }

  Future<void> checkForUpdate(BuildContext context) async {
    _lastContext = context;

    try {
      final info = await _inAppUpdateManager.checkForUpdate();

      if (info != null &&
          info.updateAvailability == UpdateAvailability.updateAvailable) {
        versionCode = info.availableVersionCode;
        _forceUpdatePending = true;
        if (!context.mounted) return;
        _showForceUpdateDialog(context);
      } else {
        mobigiclog.log('No update available.');
      }
    } catch (e) {
      mobigiclog.log('Error while checking update: $e');
    }
  }

  void _showForceUpdateDialog(BuildContext context) {
    if (_isDialogVisible || !context.mounted) return;

    _isDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            // No-op, required to prevent back navigation
          },
          child: AlertDialog(
            title: const Text("Update Required"),
            content: const Text(
              "A new version of the app is available. Update is required.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _onPressedUpdateNow(dialogContext);

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isDialogVisible = false;
    });
  }

  Future<void> _onPressedUpdateNow(BuildContext context) async {
    if (_isStartingUpdate) return;
    _isStartingUpdate = true;

    try {
      final info = await _inAppUpdateManager.checkForUpdate();

      if (info != null &&
          info.updateAvailability == UpdateAvailability.updateAvailable) {
        final msg = await _inAppUpdateManager.startAnUpdate(
          type: AppUpdateType.immediate,
        );
        mobigiclog.log("Update start result: $msg");
      } else {
        mobigiclog.log("No update on re-check.");
      }
    } catch (e) {
      mobigiclog.log("Error while starting update: $e");
    } finally {
      _isStartingUpdate = false;
    }
  }
}
