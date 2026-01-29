import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop_multivendor/Screen/Payment/Payment.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

void main() {
  group('Payment Screen Widget Tests', () {
    late CartProvider cartProvider;
    late Function mockUpdate;

    setUp(() {
      cartProvider = CartProvider();
      mockUpdate = () {}; // Mock function for update parameter
    });

    testWidgets('Payment screen renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: Payment(mockUpdate, 'Test payment message'),
          ),
        ),
      );

      // Verify that the Payment screen renders
      expect(find.byType(Payment), findsOneWidget);
    });

    testWidgets('Payment screen shows payment methods',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: Payment(mockUpdate, 'Test payment message'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if payment-related text is displayed
      expect(find.textContaining('Payment'), findsWidgets);
    });

    testWidgets('Payment screen handles null message correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: Payment(mockUpdate, null),
          ),
        ),
      );

      // Verify that the Payment screen renders even with null message
      expect(find.byType(Payment), findsOneWidget);
    });
  });
}
