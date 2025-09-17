import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/feature/product/presentation/views/add_product.dart/widgets.dart';
import 'package:flutter/material.dart';

class Weights extends StatelessWidget {
  final BoxConstraints constraint;
  final TextEditingController weight;
  final TextEditingController length;
  final TextEditingController width;
  final TextEditingController height;

  const Weights({
    super.key,
    required this.constraint,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Titlesnew(nametitle: 'Weight (kg)'),
        const SizedBox(height: kMediumSpacing),
        InputFieldNew(
          controller: weight,
          hintText: 'Enter weight (e.g., 1.5)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => Validators.validateWeight(value ?? ''),
        ),
        const SizedBox(height: kLargeSpacing),
        const Titlesnew(nametitle: 'Dimensions (cm)'),
        const SizedBox(height: kMediumSpacing),
        Row(
          children: [
            Expanded(
              child: InputFieldNew(
                controller: length,
                hintText: 'Length',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? '', 'Length'),
              ),
            ),
            const SizedBox(width: kSmallSpacing),
            Expanded(
              child: InputFieldNew(
                controller: width,
                hintText: 'Width',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? '', 'Width'),
              ),
            ),
            const SizedBox(width: kSmallSpacing),
            Expanded(
              child: InputFieldNew(
                controller: height,
                hintText: 'Height',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) =>
                    Validators.validateDimension(value ?? '', 'Height'),
              ),
            ),
          ],
        ),
        const SizedBox(height: kLargeSpacing),
      ],
    );
  }
}
