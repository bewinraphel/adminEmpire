import 'package:empire/feature/product/domain/enities/product_entities.dart';

class GetDefaultVariantsUseCase {
  List<Variant> call(String category) {
    switch (category.toLowerCase()) {
      case 'dress':
        return [
          const Variant(name: 'S'),
          const Variant(name: 'M'),
          const Variant(name: 'L'),
          const Variant(name: 'XL'),
        ];
      case 'drinks':
        return [
          const Variant(name: '250ml'),
          const Variant(name: '500ml'),
          const Variant(name: '1L'),
        ];
      case 'electronics':
        return [
          const Variant(name: 'Black'),
          const Variant(name: 'Silver'),
          const Variant(name: 'White'),
        ];
      case 'accessories':
        return [
          const Variant(name: 'Small'),
          const Variant(name: 'Large'),
        ];
      default:
        return [];
    }
  }
}