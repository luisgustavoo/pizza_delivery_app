import 'package:flutter/material.dart';

abstract class LoaderMixin {
  bool loaderOpen = false;

  void showHideLoaderHelper(BuildContext context, {bool conditional}) {
    if (conditional) {
      showLoader(context);
    } else {
      hideLoader(context);
    }
  }

   Future<void> showLoader(BuildContext context) async {
    assert(context != null);

    if (!loaderOpen) {
      loaderOpen = true;
      return Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return Container(
                width: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                ),
              );
            });
      });
    }
  }

  void hideLoader(BuildContext context) {
    if (context != null && loaderOpen) {
      loaderOpen = false;
      Navigator.of(context).pop();
    }
  }
}
