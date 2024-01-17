import 'package:flutter/material.dart';

enum PopupType { error, warning, success, general }
const Map<String, Color> popupColors = {
  'PopupType.success': Color(0xCF12FF15),
  'PopupType.warning': Color(0xFFFFE333),
  'PopupType.error': Color(0xFFFF0606),
  'PopupType.general': Color(0xFFFFFFFF)
};

const Map<String, String> popupIcon = {
  'PopupType.success': 'popup-success-icon.png',
  'PopupType.warning': 'popup-warning-icon.png',
  'PopupType.error': 'popup-error-icon.png',
  'PopupType.general': 'popup-general-icon.png'
};

Future<void> showPopup(BuildContext context, {
  required bool dismissible,
  required PopupType type,
  required String message,
  Widget? title,
  String? route
}) {
  return showDialog(
    barrierDismissible: dismissible,
    barrierColor: const Color(0xCC001836),
    context: context,
    builder: (context) =>
      Dialog(
        shadowColor: const Color(0x00000000),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6)
          ),
          child: Container(
            height: 150,
            padding: const EdgeInsets.only(left: 5, right: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                border: Border(top: BorderSide(color: popupColors[type.toString()]!, width: 10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 60,
                  child: Image.asset("assets/icons/${popupIcon[type.toString()]}" ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text(message)
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () {
                    if (route != null) {
                      Navigator.of(context).pushNamed(route);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFFFFF)
                    ),
                    child: const Icon(Icons.close),
                  ),
                )
              ],
            ),
          ),
        ),
      )
  );
}


