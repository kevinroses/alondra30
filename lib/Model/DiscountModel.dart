class DiscountRule {
  final String id;
  final String name;
  final double minAmount;
  final double? maxAmount;
  final double percentage;
  final bool isActive;
  final String description;

  DiscountRule({
    required this.id,
    required this.name,
    required this.minAmount,
    this.maxAmount,
    required this.percentage,
    required this.isActive,
    required this.description,
  });

  factory DiscountRule.fromJson(Map<String, dynamic> json) {
    return DiscountRule(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      minAmount: (json['min_amount'] ?? 0).toDouble(),
      maxAmount: json['max_amount']?.toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble() / 100.0, // Convertir de porcentaje a decimal
      isActive: json['is_active'] ?? false,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'percentage': percentage * 100.0, // Convertir de decimal a porcentaje
      'is_active': isActive,
      'description': description,
    };
  }

  // Verificar si un monto aplica para este descuento
  bool appliesToAmount(double amount) {
    if (!isActive) return false;
    if (amount < minAmount) return false;
    if (maxAmount != null && amount > maxAmount!) return false;
    return true;
  }
}

class DiscountResponse {
  final bool success;
  final List<DiscountRule> discounts;

  DiscountResponse({
    required this.success,
    required this.discounts,
  });

  factory DiscountResponse.fromJson(Map<String, dynamic> json) {
    return DiscountResponse(
      success: json['success'] ?? false,
      discounts: (json['discounts'] as List?)
          ?.map((item) => DiscountRule.fromJson(item))
          .toList() ?? [],
    );
  }

  // Encontrar el mejor descuento para un monto específico
  DiscountRule? findBestDiscount(double amount) {
    final applicableDiscounts = discounts
        .where((discount) => discount.appliesToAmount(amount))
        .toList();

    if (applicableDiscounts.isNotEmpty) {
      // Devolver el descuento con mayor porcentaje entre los aplicables
      return applicableDiscounts.reduce((a, b) =>
          a.percentage > b.percentage ? a : b);
    }
    
    // Si no hay descuentos aplicables, devolver el descuento más alto disponible
    final activeDiscounts = discounts.where((d) => d.isActive).toList();
    if (activeDiscounts.isNotEmpty) {
      return activeDiscounts.reduce((a, b) =>
          a.percentage > b.percentage ? a : b);
    }
    
    return null;
  }
}
