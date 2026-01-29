import 'package:flutter/foundation.dart';
import 'package:eshop_multivendor/Model/DiscountModel.dart';
import 'package:eshop_multivendor/repository/discountRepository.dart';

class DiscountProvider extends ChangeNotifier {
  DiscountResponse? _discountResponse;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  DiscountResponse? get discountResponse => _discountResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Cargar descuentos desde API
  Future<void> loadDiscounts() async {
    print('DEBUG iOS: loadDiscounts() iniciado');
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('DEBUG iOS: Llamando a DiscountRepository.getDiscountsFromAPI()');
      _discountResponse = await DiscountRepository.getDiscountsFromAPI();
      _error = null;
      
      if (_discountResponse!.success) {
        print('DEBUG iOS: Descuentos cargados desde API: ${_discountResponse!.discounts.length} reglas');
        for (int i = 0; i < _discountResponse!.discounts.length; i++) {
          final d = _discountResponse!.discounts[i];
          print('DEBUG iOS: Descuento $i: ${d.percentage*100}% min:${d.minAmount} max:${d.maxAmount} active:${d.isActive}');
        }
      } else {
        print('DEBUG iOS: API respondió pero sin descuentos válidos');
        _discountResponse = DiscountResponse(success: false, discounts: []);
      }
    } catch (e) {
      print('DEBUG iOS: Error cargando descuentos desde API: $e');
      _error = e.toString();
      _discountResponse = DiscountResponse(success: false, discounts: []);
    }
    
    _isLoading = false;
    print('DEBUG iOS: loadDiscounts() completado, notifiyListeners llamado');
    notifyListeners();
  }
  
  // Obtener descuentos síncronamente (solo desde API)
  DiscountResponse getDiscountsSync() {
    return _discountResponse ?? DiscountResponse(success: false, discounts: []);
  }
  
  // Encontrar mejor descuento para un monto
  DiscountRule? findBestDiscount(double amount) {
    final response = getDiscountsSync();
    return response.findBestDiscount(amount);
  }
  
  // Calcular porcentaje de descuento
  double calculateDiscountPercentage(double amount) {
    final discount = findBestDiscount(amount);
    return discount?.percentage ?? 0.0;
  }
  
  // Resetear estado
  void reset() {
    _discountResponse = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
