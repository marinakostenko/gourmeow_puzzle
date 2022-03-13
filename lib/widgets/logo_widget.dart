import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    var imageSize = ratio < 1 ? size.width * 0.08 : size.height * 0.08;
    return Container(
      height: imageSize,
      padding: EdgeInsets.only(left: imageSize * 0.5),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Image.asset('assets/images/logo_gourmeow.png', fit: BoxFit.cover),
          SizedBox(
            width: imageSize * 0.1,
          ),
          Text(
            "GourMeow",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: imageSize,
            ),
          )
        ],
      ),
    );
  }
}
