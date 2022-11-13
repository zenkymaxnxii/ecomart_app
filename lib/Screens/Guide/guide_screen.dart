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
                    "Hướng dẫn\n"'"PHÂN LOẠI RÁC"',
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
                    "Rác hữu cơ",
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
                      "Là tên gọi chung của những loại rác thải dễ dàng phân hủy như thực phẩm đồ ăn thừa, rơm rạ, thân cành lá trong quá trình trồng cây nông nghiệp… Những loại rác này sau khi được thu gom sẽ đem chế tạo thành phân bón và được tái tạo sử dụng để giúp việc trồng cây được tốt hơn.",
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
                    "Rác vô cơ",
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
                      "Là tên gọi chung của những loại rác không thể phân hủy mà cũng không thể tái chế để sử dụng. Rác vô cơ sau khi được thu gom thì sẽ được chuyển đến khu xử lý chôn lấp rác thải. Tuy nhiên dù đã qua quá trình xử lý chôn lấp nhưng vẫn phải cần thời gian rất dài, rác vô cơ mới có thể tiêu hủy được.",
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
                    "Rác tái chế",
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
                      "Là tên gọi chung của những loại rác có thể đem đi tái chế và sử dụng lại, không nhất thiết phải vứt vào thùng rác. Đơn cử như các vỏ lon, kim loại, vỏ hộp giấy cũ…. Sau khi được tái chế chúng có diện mạo mới và con người có thể sử dụng chúng một cách dễ dàng.",
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
