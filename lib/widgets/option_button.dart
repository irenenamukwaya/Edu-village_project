import 'package:flutter/material.dart';
import 'package:eduvillage/utils/constants.dart';

/// Option button for answer choices
class OptionButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onPressed;
  final double fontSize;

  const OptionButton({
    Key? key,
    required this.label,
    required this.isSelected,
    this.isCorrect = false,
    this.isAnswered = false,
    required this.onPressed,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.correctAnswerAnimation,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(OptionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnswered && widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.isAnswered && widget.isSelected) {
      return widget.isCorrect
          ? AppConstants.successColor.withOpacity(0.7)
          : AppConstants.errorColor.withOpacity(0.7);
    }

    if (widget.isSelected && !widget.isAnswered) {
      return AppConstants.primaryColor.withOpacity(0.3);
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isAnswered ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: widget.isSelected
                    ? AppConstants.primaryColor
                    : Colors.grey[300]!,
                width: widget.isSelected ? 3 : 1,
              ),
              boxShadow: [
                if (widget.isSelected && !widget.isAnswered)
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Row(
              children: [
                if (widget.isAnswered && widget.isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: (widget.isAnswered && widget.isSelected)
                          ? Colors.white
                          : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
