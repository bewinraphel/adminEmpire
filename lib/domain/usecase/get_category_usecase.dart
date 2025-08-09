import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/domain/repositories/category_repository.dart';

class CategoryUsecase {
  final CategoryRepository categoryRepository;
  CategoryUsecase(this.categoryRepository);
  Stream<List<CategoryEntities>> call() {
    return categoryRepository.getCategory();
  }
}
