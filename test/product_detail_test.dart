import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eshop_multivendor/Screen/Product_Detail/productDetail.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:provider/provider.dart';

void main() {
  group('ProductDetail Screen Widget Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    testWidgets('ProductDetail screen renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: ProductDetail(),
          ),
        ),
      );

      // Verify that the ProductDetail screen renders
      expect(find.byType(ProductDetail), findsOneWidget);
    });

    testWidgets('ProductDetail screen renders with product model',
        (WidgetTester tester) async {
      // Create a mock product model
      final product = Product(
        id: '1',
        name: 'Test Product',
        // Add other required fields as needed
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: ProductDetail(model: product),
          ),
        ),
      );

      // Verify that the ProductDetail screen renders with product
      expect(find.byType(ProductDetail), findsOneWidget);
    });

    testWidgets('ProductDetail screen handles fromCart parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: ProductDetail(fromCart: true),
          ),
        ),
      );

      // Verify that the ProductDetail screen renders with fromCart = true
      expect(find.byType(ProductDetail), findsOneWidget);
    });

    testWidgets('ProductDetail screen handles all optional parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: MaterialApp(
            home: ProductDetail(
              index: 0,
              secPos: 1,
              list: true,
              fromCart: false,
              selectedVarientIndex: 0,
            ),
          ),
        ),
      );

      // Verify that the ProductDetail screen renders with all parameters
      expect(find.byType(ProductDetail), findsOneWidget);
    });
  });
}
