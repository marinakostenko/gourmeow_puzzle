import 'package:flutter/widgets.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url, {VoidCallback? onError}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else if (onError != null) {
    onError();
  }
}