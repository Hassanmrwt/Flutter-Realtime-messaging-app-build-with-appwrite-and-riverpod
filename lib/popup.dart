import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pmtc/models.dart';

myPopup(
    {required VoidCallback onConfirm,
    required Message message,
    required BuildContext context}) {
  return PanaraConfirmDialog.showAnimatedGrow(
    context,
    title: "This Message will be deleted permanantly",
    message: message.message,
    confirmButtonText: "Confirm",
    cancelButtonText: "Cancel",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: onConfirm,
    panaraDialogType: PanaraDialogType.success,
  );
}
