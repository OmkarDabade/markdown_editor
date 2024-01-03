import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageNetworkMarkdown extends StatelessWidget {
  const ImageNetworkMarkdown({
    Key? key,
    required this.uri,
    this.title,
  }) : super(key: key);

  final String uri;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      uri.toString(),
      loadingBuilder: _loadingBuilder,
      errorBuilder: _errorBuilder,
    );
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Center(
      child: Container(
        width: 300,
        height: 220,
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.triangleExclamation),
            SizedBox(height: 20),
            Text(
              "Failed Load Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Object child,
    ImageChunkEvent? loadingProgress,
  ) {
    return Center(
      child: Container(
        width: 300,
        height: 220,
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          value: loadingProgress?.cumulativeBytesLoaded.toDouble(),
        ),
      ),
    );
  }
}
