import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:testsendbird/utils/theme.dart';

class InputMessage extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function()? onSend;
  final bool enable;

  const InputMessage(
    this.controller, {
    super.key,
    this.focusNode,
    this.onSend,
    this.enable = true,
  });

  @override
  InputMessageState createState() => InputMessageState();
}

class InputMessageState extends State<InputMessage> {
  double _borderRadius = 48.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            fillColor: Get.isDarkMode ? CustomTheme.dark5 : CustomTheme.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Get.isDarkMode ? CustomTheme.dark4 : CustomTheme.dark1),
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Get.isDarkMode ? CustomTheme.dark4 : CustomTheme.dark1),
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 46, 12),
          ),
          minLines: 1,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          focusNode: widget.focusNode,
          enabled: true,
          onChanged: (text) {
            setState(() {
              _borderRadius = widget.controller.text.split('\n').length > 1 ? 24.0 : 48.0;
            });
          },
        ),
        Positioned(
          right: 0,
          bottom: 12,
          child: GestureDetector(
            onTap: widget.onSend,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgPicture.asset(
                  widget.enable ? 'assets/icons/chat_send.svg' : 'assets/icons/chat_send_disabled.svg',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
