import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../app_keys.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? currentToken;

  /// Praktik 8: Meminta izin notifikasi
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  /// Praktik 9: Mendapatkan FCM Token
  Future<String?> getToken({String? vapidKey}) async {
    try {
      final token = await _messaging.getToken(
        vapidKey: kIsWeb ? vapidKey : null,
      );
      currentToken = token;
      debugPrint('====================================');
      debugPrint('FCM Token: $token');
      debugPrint('====================================');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Praktik 10: Inisialisasi notifikasi (Foreground & Background)
  Future<void> init({String? vapidKey}) async {
    await requestPermission();
    await getToken(vapidKey: vapidKey);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FOREGROUND: Saat aplikasi sedang aktif dibuka di layar
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');

      final title = message.notification?.title ?? 'Notifikasi KosFinder';
      final body = message.notification?.body ?? '';

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.indigo,
          duration: const Duration(seconds: 5),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔔 $title',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (body.isNotEmpty) Text(body),
            ],
          ),
        ),
      );
    });
  }
}
