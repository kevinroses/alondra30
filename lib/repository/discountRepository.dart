import 'dart:convert';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/DiscountModel.dart';

class DiscountRepository {
  static final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  // Opción 1: Cargar desde API
  static Future<DiscountResponse> getDiscountsFromAPI() async {
    try {
      final response = await _apiBaseHelper.getAPICall(
        Uri.parse('https://menu.kevinpalaciosdev.com/o.json'), // URL de tu API
      );

      return DiscountResponse.fromJson(response);
    } catch (e) {
      print('Error loading discounts from API: $e');
      // Retornar respuesta vacía en caso de error
      return DiscountResponse(success: false, discounts: []);
    }
  }

  // Opción 2: Cargar desde JSON local (assets)
  static Future<DiscountResponse> getDiscountsFromLocal() async {
    try {
      // Aquí cargarías desde un archivo JSON en assets
      // Por ahora, retornamos los datos por defecto
      return getStaticDiscounts();
    } catch (e) {
      print('Error loading local discounts: $e');
      return DiscountResponse(success: false, discounts: []);
    }
  }

  // Opción 3: Descuentos estáticos (fallback)
  static DiscountResponse getStaticDiscounts() {
    return DiscountResponse(
      success: true,
      discounts: [
        DiscountRule(
          id: 'discount_001',
          name: 'Descuento Básico',
          minAmount: 1000,
          maxAmount: 1999.99,
          percentage: 5.0,
          isActive: true,
          description: '5% de descuento en compras desde \$1,000',
        ),
        DiscountRule(
          id: 'discount_002',
          name: 'Descuento Intermedio',
          minAmount: 2000,
          maxAmount: 4999.99,
          percentage: 7.0,
          isActive: true,
          description: '7% de descuento en compras desde \$2,000',
        ),
        DiscountRule(
          id: 'discount_003',
          name: 'Descuento Alto',
          minAmount: 5000,
          maxAmount: 9999.99,
          percentage: 10.0,
          isActive: true,
          description: '10% de descuento en compras desde \$5,000',
        ),
        DiscountRule(
          id: 'discount_004',
          name: 'Descuento Premium',
          minAmount: 10000,
          maxAmount: 14999.99,
          percentage: 15.0,
          isActive: true,
          description: '15% de descuento en compras desde \$10,000',
        ),
        DiscountRule(
          id: 'discount_005',
          name: 'Descuento Elite',
          minAmount: 15000,
          maxAmount: 19999.99,
          percentage: 20.0,
          isActive: true,
          description: '20% de descuento en compras desde \$15,000',
        ),
        DiscountRule(
          id: 'discount_006',
          name: 'Descuento Máximo',
          minAmount: 20000,
          maxAmount: null, // Sin límite superior
          percentage: 25.0,
          isActive: true,
          description: '25% de descuento en compras desde \$20,000',
        ),
      ],
    );
  }

  // Método principal para obtener descuentos (intenta API, luego local, luego estático)
  static Future<DiscountResponse> getDiscounts() async {
    try {
      // Primero intentar cargar desde API
      final apiResponse = await getDiscountsFromAPI();
      if (apiResponse.success && apiResponse.discounts.isNotEmpty) {
        print('DEBUG: Descuentos cargados desde API');
        return apiResponse;
      }

      // Si API falla, intentar cargar desde local
      final localResponse = await getDiscountsFromLocal();
      if (localResponse.success && localResponse.discounts.isNotEmpty) {
        print('DEBUG: Descuentos cargados desde local');
        return localResponse;
      }

      // Si todo falla, usar descuentos estáticos
      print('DEBUG: Usando descuentos estáticos');
      return getStaticDiscounts();
    } catch (e) {
      print('Error in getDiscounts: $e');
      return getStaticDiscounts();
    }
  }
  
  // Método síncrono para obtener descuentos estáticos (para uso inmediato)
  static DiscountResponse getDiscountsSync() {
    return getStaticDiscounts();
  }
}
