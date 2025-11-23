import 'package:animate_do/animate_do.dart';
import 'package:empire/core/utilis/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class InputFieldNew extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const InputFieldNew({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 200),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5, 5),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.white70,
                  offset: Offset(-5, -5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SizedBox(
              height: 50.0,
              child: Center(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Titlesnew extends StatelessWidget {
  final String nametitle;

  const Titlesnew({super.key, required this.nametitle});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 150),
      child: SlideAnimation(
        horizontalOffset: -50.0,
        child: FadeInAnimation(
          child: Text(
            nametitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButtonNew extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const GradientButtonNew({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  State<GradientButtonNew> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButtonNew>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap!();
      },
      onTapCancel: () => _controller.reverse(),
      child: ZoomIn(
        duration: const Duration(milliseconds: 200),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 103, 206, 34),
                  Color.fromARGB(255, 29, 161, 88),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class InStock extends StatelessWidget {
  final ValueNotifier<bool> isInStock;

  const InStock({super.key, required this.isInStock});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isInStock,
      builder: (context, value, child) {
        return Container(
          decoration: kCardDecoration,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('In Stock', style: TextStyle(color: Colors.black87)),
              Switch(
                value: value,
                onChanged: (newValue) => isInStock.value = newValue,
                activeColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}
AppBar appbar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: BounceInDown(
      duration: const Duration(milliseconds: 600),
      child: const Text(
        'Add Product',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
      ),
    ),
    centerTitle: true,
  );
}
