import 'package:flutter/material.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          welcome.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 20,
              child: Image.asset("assets/images/garbage_sorting.png", fit: BoxFit.fitHeight)
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 4),
      ],
    );
  }
}