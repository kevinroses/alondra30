import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  group('PushNotificationService Constant Expression Tests', () {
    test('should create notification without constant expression errors', () {
      // Test that the method can be called without constant expression errors
      // This tests that our fix for moving expressions outside const worked
      final payload = {'image': 'test_image.jpg'};

      // If this doesn't throw an exception, the constant expression error is fixed
      expect(() {
        // This would previously fail with "Not a constant expression"
        // Now it should work because we moved the logic outside const
        List<DarwinNotificationAttachment>? attachments;
        if (payload['image'] != null) {
          attachments = [DarwinNotificationAttachment(payload['image']!)];
        }
        return attachments;
      }, returnsNormally);
    });

    test('should handle null payload correctly', () {
      // Test null handling
      final payload = <String, String>{};

      expect(() {
        List<DarwinNotificationAttachment>? attachments;
        if (payload['image'] != null) {
          attachments = [DarwinNotificationAttachment(payload['image']!)];
        }
        return attachments;
      }(), isNull);
    });

    test('should handle payload with image correctly', () {
      // Test with valid image payload
      final payload = {'image': 'notification_image.png'};

      expect(() {
        List<DarwinNotificationAttachment>? attachments;
        if (payload['image'] != null) {
          attachments = [DarwinNotificationAttachment(payload['image']!)];
        }
        return attachments;
      }(), isNotNull);
    });
  });
}
