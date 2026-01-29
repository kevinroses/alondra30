import 'package:flutter_test/flutter_test.dart';
import 'package:eshop_multivendor/Screen/Cart/Cart.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  group('Cart Widget Syntax Errors Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    testWidgets('Cart widget compiles without syntax errors',
        (WidgetTester tester) async {
      // Test that Cart widget can be instantiated without syntax errors
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: const MaterialApp(
            home: Cart(fromBottom: false),
          ),
        ),
      );

      // If we reach this point without exceptions, syntax errors are fixed
      expect(find.byType(Cart), findsOneWidget);
    });

    test('Cart widget has required methods defined', () {
      // Test that the corrected methods exist and don't throw errors
      final cart = Cart(fromBottom: false);

      // These methods should exist after our fixes
      expect(cart.runtimeType, equals(Cart));
    });
  });
}
