import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';

class GiftDetail extends StatefulWidget {
  GiftDetail({Key? key, required this.gift, required this.point})
      : super(key: key);
  QueryDocumentSnapshot<Object?> gift;
  int point;

  @override
  State<GiftDetail> createState() => _GiftDetailState();
}

class _GiftDetailState extends State<GiftDetail> {
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
                height: 260,
                color: kPrimaryColor,
              ),
              Positioned(
                top: 80,
                right: 50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.gift['url'],
                        ),
                        fit: BoxFit.fill),
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
                  height: 82,
                ),
                Container(
                  height: 24,
                  width: 72,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.gift['price']}",
                          style: const TextStyle(
                              color: kPrimaryColor, fontSize: 18),
                        ),
                        const Icon(
                          Icons.stars,
                          size: 18,
                          color: Colors.deepOrangeAccent,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.gift['name'],
                    style: const TextStyle(
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
              margin: const EdgeInsets.only(top: 246, bottom: 50),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Giới thiệu sản phẩm",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        "${widget.gift['description']}",
                        style: const TextStyle(
                          height: 1.4,
                          color: Color(0xff464646),
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: const Text(
                    "Đổi ngay !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {
                    if (widget.point >= (widget.gift['price'] as int)) {
                      UserHelper.orderGift(
                          uidGift: widget.gift.id,
                          nameGift: widget.gift['name'],
                          price: widget.gift['price'] as int,
                          url: widget.gift['url']);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text("Đổi quà thành công!"),
                      ));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text("Bạn không đủ điểm để đổi!"),
                      ));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
