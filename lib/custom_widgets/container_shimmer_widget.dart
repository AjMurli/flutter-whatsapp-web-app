import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContainerShimmerWidget extends StatefulWidget {
  double widthRatio;
  double heightRatio;
  ContainerShimmerWidget(
      {super.key, required this.widthRatio, required this.heightRatio});

  @override
  State<ContainerShimmerWidget> createState() =>
      _ContainerShimmerWidgetState();
}

class _ContainerShimmerWidgetState
    extends State<ContainerShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.green[300]!,
      highlightColor: Colors.green[200]!,
      child: Container(
        width: widget.widthRatio,
        height: widget.heightRatio,
        decoration: BoxDecoration(
            color: Colors.green[300], borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
