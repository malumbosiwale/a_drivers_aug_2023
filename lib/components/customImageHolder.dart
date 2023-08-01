
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

class customImageHolder extends StatelessWidget {
  const customImageHolder({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      image,
      fit: BoxFit.cover,
      cache: true,
      //cancelToken: cancellationToken,
    );
  }
}
