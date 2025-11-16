import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/dimens.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData? iconData;
  final TextEditingController controller;
  final ValueChanged onChanged;
  final String label;
  final bool? obscureText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  final _focusNode = FocusNode();

  CustomTextFormField({
    super.key,
    this.iconData,
    required this.label,
    this.obscureText,
    required this.controller,
    this.textInputType,
    this.inputFormatters,
    this.errorText,
    required this.onChanged,
  });

  CustomTextFormField.text({
    super.key,
    this.iconData,
    required this.label,
    this.obscureText,
    required this.controller,
    required this.onChanged,
    this.inputFormatters,
    this.errorText,
  }) : textInputType = TextInputType.text;

  CustomTextFormField.number({
    super.key,
    this.iconData,
    required this.label,
    this.obscureText,
    required this.controller,
    this.errorText,
    required this.onChanged,
  })  : textInputType = TextInputType.number,
        inputFormatters = <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (iconData != null)
          Padding(
            padding: const EdgeInsets.only(right: spacingS),
            child: Icon(
              iconData,
              size: iconSize,
            ),
          ),
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              TextFormField(
                focusNode: _focusNode,
                controller: controller,
                obscureText: obscureText ?? false,
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: label,
                  errorText: errorText,
                ),
                onChanged: onChanged,
              ),
              IconButton(
                icon: const Icon(Icons.backspace_outlined),
                onPressed: () {
                  onChanged.call('');
                  _focusNode.requestFocus();
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
