import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/domain/entities/category_entities.dart';
import 'package:empire/presentation/bloc/category_bloc/get_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntities doc;
  final bool Function(CategoryState) isSelectedSelector;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.doc,
    required this.isSelectedSelector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryBloc, CategoryState, bool>(
      selector: isSelectedSelector,
      builder: (context, isSelected) {
        return GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.yellow[700] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: doc.imageUrl,
                  height: 90,
                  width: 90,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child:  const SizedBox(
                      height: 90,
                      width: 90,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                doc.category,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Raleway',
                  fontSize: 15,
                  color: isSelected ? Colors.black87 : Colors.black45,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
