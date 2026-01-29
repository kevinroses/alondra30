import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop_multivendor/Screen/homePage/homepageNew.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomePage Screen Widget Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    testWidgets('HomePage screen renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      // Verify that the HomePage screen renders
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage screen shows main content',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if basic UI elements are present
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('HomePage handles provider changes correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      // Verify the widget builds successfully with provider
      expect(find.byType(HomePage), findsOneWidget);

      // Test that the widget can handle provider updates
      cartProvider.setCartlist([]);
      await tester.pump();

      // Widget should still be present after provider update
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
