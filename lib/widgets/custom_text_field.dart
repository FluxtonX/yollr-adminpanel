import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final Color? avatarColor;
  final IconData? avatarIcon;
  final bool showAvatar;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText,
    this.validator,
    this.avatarColor,
    this.avatarIcon,
    this.showAvatar = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep internal focus state to rebuild UI if needed
    // In this simplified version, we just use TextFormField's focusNode

    return FormField<String>(
      initialValue: widget.controller?.text,
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.avatarIcon !=
                    null) // Simplification: show icon if valid, ignoring showAvatar flag for now or handling it
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.avatarColor ?? const Color(0xFFE91E63),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.avatarIcon,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1.5),
                      ),
                    ),
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: widget.controller,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                      maxLines: widget.obscureText == true
                          ? 1
                          : widget.maxLines,
                      maxLength: widget.maxLength,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onFieldSubmitted: widget.onSubmitted,
                      obscureText: widget.obscureText ?? false,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 12,
                        ),
                        prefixIcon:
                            widget.prefixIcon != null && !widget.showAvatar
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  right: 8,
                                ),
                                child: widget.prefixIcon,
                              )
                            : null,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        suffixIcon: widget.suffixIcon,
                        counterText: '',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Error message
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Text(
                  state.errorText ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppTheme.errorColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
