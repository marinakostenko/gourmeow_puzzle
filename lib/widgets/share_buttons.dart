import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/helpers/link_helper.dart';

const _shareUrl = 'https://marinakostenko.github.io/';

class TwitterButton extends StatelessWidget {
  final String score;

  const TwitterButton({Key? key, required this.score}) : super(key: key);

  String _twitterShareUrl(BuildContext context) {
    final encodedShareText = Uri.encodeComponent(score);
    return 'https://twitter.com/intent/tweet?url=$_shareUrl&text=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      icon: Image.asset(
        'assets/images/twitter_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF13B9FD),
      onPressed: () => openLink(_twitterShareUrl(context)),
    );
  }
}

class FacebookButton extends StatelessWidget {
  final String score;

  const FacebookButton({Key? key, required this.score}) : super(key: key);

  String _facebookShareUrl(BuildContext context) {
    final encodedShareText = Uri.encodeComponent(score);
    return 'https://www.facebook.com/sharer.php?u=$_shareUrl&quote=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      icon: Image.asset(
        'assets/images/facebook_icon.png',
        width: 6.56,
        height: 13.13,
      ),
      color: const Color(0xFF0468D7),
      onPressed: () => openLink(_facebookShareUrl(context)),
    );
  }
}


class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final VoidCallback onPressed;

  final Widget icon;
  final Color color;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        widget.onPressed();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          alignment: Alignment.center,
          width: 32,
          height: 32,
          color: widget.color,
          child: widget.icon,
        ),
      ),
    );
  }
}
