import 'package:ecomart_app/constants.dart';
import 'package:flutter/material.dart';

import '../../components/appbar_widget.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({Key? key}) : super(key: key);

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Center(
        child: Text(
          "Chức năng này đang được phát triên.\nMời bạn quay lại sau!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: kPrimaryColor),
        ),
      ),
    );
  }
}
