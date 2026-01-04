import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/utils/notification_utils.dart';
import 'data/models/model_registry.dart';

void main() async {
  // Wrap everything in try-catch to prevent crashes
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set up global error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exception}');
    };

    // System UI - non-critical, don't crash if fails
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    } catch (e) {
      debugPrint('System UI setup failed: $e');
    }

    // Hive initialization - critical but handle gracefully
    bool hiveInitialized = false;
    try {
      debugPrint('Starting Hive init...');
      await Hive.initFlutter();
      debugPrint('Hive.initFlutter() done');
      
      ModelRegistry.registerAdapters();
      debugPrint('Adapters registered');
      
      await ModelRegistry.openBoxes();
      debugPrint('Boxes opened');
      
      hiveInitialized = true;
      debugPrint('Hive fully initialized');
    } catch (e, stack) {
      debugPrint('Hive initialization failed: $e');
      debugPrint('Stack: $stack');
      // Continue without Hive - show error in app
    }

    // Notifications - completely optional
    try {
      await NotificationUtils.initialize();
      debugPrint('Notifications initialized');
    } catch (e) {
      debugPrint('Notifications failed: $e');
    }

    // Launch app
    if (hiveInitialized) {
      runApp(const FlowZenApp());
    } else {
      // Show error screen if Hive failed
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.storage,
                        size: 80,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Database Error',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to initialize local storage. Please clear app data and try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text('Close App'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack: $stack');
  });
}
