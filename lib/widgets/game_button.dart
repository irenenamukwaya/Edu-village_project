import 'package:flutter/material.dart';
import 'package:eduvillage/utils/constants.dart';

/// Reusable game button widget
class GameButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double fontSize;
  final IconData? icon;
  final bool isEnabled;

  const GameButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppConstants.primaryColor,
    this.textColor,
    this.width,
    this.height = 60,
    this.fontSize = 20,
    this.icon,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.buttonPressAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (!widget.isEnabled) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.isEnabled ? _onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isEnabled
                ? widget.backgroundColor
                : Colors.grey[400],
            disabledBackgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: widget.backgroundColor.withOpacity(0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.textColor ?? Colors.white,
                  size: widget.fontSize + 4,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize,
                    color: widget.textColor ?? Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
