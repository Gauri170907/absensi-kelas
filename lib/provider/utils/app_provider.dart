import 'package:flutter/material.dart';

import 'disposable_provider.dart';

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      //...other disposable providers
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}
