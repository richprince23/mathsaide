import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathsaide/constants/constants.dart';

import 'package:resize/resize.dart';

class SelectControl extends StatefulWidget {
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final List<DropdownMenuItem<String>> items;
  final void Function(String? value)? onChanged;
  final bool showLabel;
  final Widget? leading;
  final String? initialValue;

  const SelectControl({
    Key? inputkey,
    this.hintText,
    this.validator,
    required this.items,
    this.showLabel = true,
    this.leading,
    this.onChanged,
    this.initialValue,
  }) : super(key: inputkey);

  @override
  State<SelectControl> createState() => _SelectControlState();
}

class _SelectControlState extends State<SelectControl> {
  late TextInputFormatter formatter;
  int textLength = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel == true)
          SizedBox(
            height: 5.w,
          ),
        if (widget.showLabel == true)
          Text(
            widget.hintText?.toString() ?? "",
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
        DropdownButtonFormField(
          value: widget.initialValue ?? "",
          items: widget.items,
          onChanged: widget.onChanged,
          validator: widget.validator,
          dropdownColor: bgColDark,
          menuMaxHeight: 300,
          decoration: InputDecoration(
            prefixIcon: widget.leading,
            hintText: widget.hintText!,
            hintStyle: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            // contentPadding:
            //     EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
      ],
    );
  }
}
