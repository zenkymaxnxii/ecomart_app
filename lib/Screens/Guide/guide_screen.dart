import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  GuideScreenState createState() {
    return GuideScreenState();
  }
}

class GuideScreenState extends State<GuideScreen> {
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.topLeft,
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 220,
                color: kPrimaryColor,
              ),
              Positioned(
                top: 50,
                right: 30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: NetworkImage(
                          'https://changevn.org/wp-content/uploads/2021/10/2.png',
                        ),
                        fit: BoxFit.scaleDown),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const BackButton(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "H?????ng d???n\n"'"PH??N LO???I R??C"',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "Product_Sans_Bold"),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16.0,
                  ),
                ],
                color: Color(0xfffafafa)),
            margin: const EdgeInsets.only(top: 206, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: const <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "R??c h???u c??",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "L?? t??n g???i chung c???a nh???ng lo???i r??c th???i d??? d??ng ph??n h???y nh?? th???c ph???m ????? ??n th???a, r??m r???, th??n c??nh l?? trong qu?? tr??nh tr???ng c??y n??ng nghi???p??? Nh???ng lo???i r??c n??y sau khi ???????c thu gom s??? ??em ch??? t???o th??nh ph??n b??n v?? ???????c t??i t???o s??? d???ng ????? gi??p vi???c tr???ng c??y ???????c t???t h??n.",
                      style: TextStyle(
                        height: 1.4,
                        color: Color(0xff464646),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "R??c v?? c??",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "L?? t??n g???i chung c???a nh???ng lo???i r??c kh??ng th??? ph??n h???y m?? c??ng kh??ng th??? t??i ch??? ????? s??? d???ng. R??c v?? c?? sau khi ???????c thu gom th?? s??? ???????c chuy???n ?????n khu x??? l?? ch??n l???p r??c th???i. Tuy nhi??n d?? ???? qua qu?? tr??nh x??? l?? ch??n l???p nh??ng v???n ph???i c???n th???i gian r???t d??i, r??c v?? c?? m???i c?? th??? ti??u h???y ???????c.",
                      style: TextStyle(
                        height: 1.4,
                        color: Color(0xff464646),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "R??c t??i ch???",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "L?? t??n g???i chung c???a nh???ng lo???i r??c c?? th??? ??em ??i t??i ch??? v?? s??? d???ng l???i, kh??ng nh???t thi???t ph???i v???t v??o th??ng r??c. ????n c??? nh?? c??c v??? lon, kim lo???i, v??? h???p gi???y c?????. Sau khi ???????c t??i ch??? ch??ng c?? di???n m???o m???i v?? con ng?????i c?? th??? s??? d???ng ch??ng m???t c??ch d??? d??ng.",
                      style: TextStyle(
                        height: 1.4,
                        color: Color(0xff464646),
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
