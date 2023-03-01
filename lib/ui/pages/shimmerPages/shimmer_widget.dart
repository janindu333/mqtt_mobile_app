import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerWidget.rectangular({
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
      height: height,
      color: Colors.red,
    );
  }
}
