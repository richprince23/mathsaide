import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/constants/constants.dart';
import 'package:resize/resize.dart';

class InputControl extends StatefulWidget {
  final TextEditingController? controller;

  final String? hintText;

  final bool? isPassword;
  final TextInputType? type;
  final bool? showLabel;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  final FormFieldValidator<String>? validator;

  final bool? readOnly;

  final void Function()? onTap;
  final void Function(String)? onChanged;

  final Icon? leading;
  final bool? isSearch;
  final double radius;
  final bool isCollapsed;
  final bool? showFilter;

  const InputControl({
    Key? inputkey,
    this.type,
    this.hintText,
    this.isPassword = false,
    this.readOnly,
    this.controller,
    this.validator,
    this.onTap,
    this.showLabel = true,
    this.focusNode,
    this.radius = 10,
    this.leading,
    this.isSearch = false,
    this.onChanged,
    this.isCollapsed = false,
    this.showFilter = false,
    this.suffixIcon,
  }) : super(key: inputkey);

  @override
  State<InputControl> createState() => _InputControlState();
}

class _InputControlState extends State<InputControl> {
  bool showPass = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    widget.focusNode?.dispose();
    super.dispose();
  }

  late TextInputFormatter formatter;
  int textLength = 0;
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel == true)
          SizedBox(
            height: 5.w,
          ),
        if (widget.showLabel == true)
          Text(
            widget.hintText!.toString(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                color: txtCol,
                fontSize: 16.sp,
                decoration: TextDecoration.none),
            overflow: TextOverflow.ellipsis,
          ),
        if (widget.showLabel == true)
          SizedBox(
            height: 1.w,
          ),
        TextFormField(
          readOnly: widget.readOnly ?? false,
          inputFormatters: [
            if (widget.type == TextInputType.phone)
              FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (value) => {
            setState(() {
              textLength = value.length;
            }),
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (widget.onChanged != null) widget.onChanged!(value);
            }
                // widget.onChanged(value),
                )
          },
          textInputAction: (widget.isSearch == true)
              ? TextInputAction.search
              : widget.type == TextInputType.multiline
                  ? TextInputAction.newline
                  : TextInputAction.next,
          onTap: widget.onTap,
          maxLines: widget.type == TextInputType.multiline ? 5 : 1,
          minLines: 1,
          validator: widget.validator,
          keyboardType: widget.type ?? TextInputType.text,
          obscureText: showPass,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            color: txtCol,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
          decoration: const InputDecoration().copyWith(
            isCollapsed: widget.isCollapsed,
            hintText: widget.hintText!.toString(),
            contentPadding: widget.isCollapsed == false
                ? EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.w,
                  )
                : EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            prefixIcon: widget.leading,
            suffixIcon: widget.isPassword == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    icon: Icon(
                        showPass ? Icons.visibility : Icons.visibility_off),
                  )
                : widget.suffixIcon,
          ),
        ),
        SizedBox(
          height: 8.w,
        ),
      ],
    );
  }
}
