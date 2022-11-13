import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as connect;

class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static getId() {
    return _auth.currentUser?.uid;
  }

  static signInWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static signupWithEmail(
      {required String email, required String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User? user = res.user;
    return user;
  }

  static logOut() {
    return _auth.signOut();
  }
}

class UserHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    Map<String, dynamic> userData = {
      "name": "Guest",
      "email": user.email,
      "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime?.millisecondsSinceEpoch,
      "role": "user",
      "address": "",
      "phone_number": "",
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime?.millisecondsSinceEpoch,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
      await updatePoint(point: 0, calculation: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("role", false);
    }
  }

  static booking(
      {required String amount,
      required String description,
      required String note,
      required String name,
      required String address,
      required String phoneNumber}) async {
    String datetime = DateTime.now().toString();
    Map<String, dynamic> order = {
      "amount": amount,
      "description": description,
      "note": note,
      "name": name,
      "address": address,
      "phone_number": phoneNumber,
      "date_time": datetime,
      "status": 0,
      "pick_up_date": "",
      "uid": AuthHelper.getId(),
    };
    await _db.collection("orders").add(order);
    await notificationToAdmin(
        address: address,
        description: description,
        name: name,
        status: 0,
        phoneNumber: phoneNumber);
  }

  static handleBooked(
      {required String orderId,
      required int status,
      String? date,
      String? time}) async {
    final orderRef = _db.collection("orders").doc(orderId);
    if ((await orderRef.get()).exists) {
      await orderRef.update({
        "status": status,
        "pick_up_date": date != null ? "$date : $time" : "Đã giao",
      });
    }

    await notificationToUser(
        status: status,
        address: (await orderRef.get())['address'],
        description: (await orderRef.get())['description'],
        datePickUp: date != null ? "$date : $time" : "Đã giao",
        uid: (await orderRef.get())['uid']);
  }

  static readNotice(
      {required String noticeId, required String collection}) async {
    final orderRef = _db.collection(collection).doc(noticeId);
    if ((await orderRef.get()).exists) {
      await orderRef.update({
        "readed": true,
      });
    }
  }

  static orderGift(
      {required String uidGift,
      required String nameGift,
      required int price,
      required String url}) async {
    String datetime = DateTime.now().toString();
    Map<String, dynamic> orderGift = {
      "uid_gift": uidGift,
      "name_gift": nameGift,
      "url": url,
      "price": price,
      "date_time": datetime,
      "status": false,
      "uid_user": AuthHelper.getId(),
    };
    await _db.collection("order_gift").add(orderGift);
    await updatePoint(point: price, calculation: false);
  }

  static addGift(
      {required int amount,
      required String nameGift,
      required int price,
      required String description,
      required String url}) async {
    Map<String, dynamic> gift = {
      "name": nameGift,
      "price": price,
      "url": url,
      "description": description,
      "amount": amount,
    };
    await _db.collection("gifts").add(gift);
  }

  static updatePoint({required int point, required bool calculation}) async {
    final pointRef = _db.collection("reward_points").doc(AuthHelper.getId());
    Map<String, int> pointMap = {"point": point};
    if ((await pointRef.get()).exists) {
      await pointRef.update({
        "point": FieldValue.increment(calculation ? point : point * (-1)),
      });
    } else {
      await _db
          .collection("reward_points")
          .doc(AuthHelper.getId())
          .set(pointMap);
    }
  }

  static notificationToUser(
      {required int status,
      required String address,
      required String description,
      required String datePickUp,
      required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String token = snap['token'];
    String datetime = DateTime.now().toString();
    Map<String, dynamic> notice = {
      "status": status,
      "address": address,
      "description": description,
      "date_time": datetime,
      "pick_up_date": datePickUp,
      "readed": false,
      "uid_user": uid,
    };
    String bodyText =
        "Đơn hàng $description của bạn đã ${status == 1 ? "có người đến lấy.Thời gian dự kiến $datePickUp." : "được giao"}";
    await _db.collection("notice_user").add(notice);
    UserHelper.sendPushMessage(token, bodyText, "Thông báo");
  }

  static notificationToAdmin(
      {required String name,
      required String phoneNumber,
      required String address,
      required int status,
      required String description}) async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("users").where("role", isEqualTo: "admin").get();
    final listToken = snap.docs;
    String datetime = DateTime.now().toString();
    Map<String, dynamic> notice = {
      "status": status,
      "name": name,
      "phone_number": phoneNumber,
      "address": address,
      "description": description,
      "date_time": datetime,
      "readed": false,
      "uid_user": AuthHelper.getId(),
    };
    await _db.collection("notice_admin").add(notice);
    String bodyText =
        "Có đơn hàng mới $description của $name, địa chỉ $address, sđt $phoneNumber.";
    for(var i = 0 ; i<listToken.length; i++){
      UserHelper.sendPushMessage(listToken[i]["token"], bodyText, "Thông báo");
    }
  }

  static updateUser(String key, String value) async {
    return await _db
        .collection("users")
        .doc(AuthHelper.getId())
        .update({key: value});
  }

  static getRole() async {
    final docRef = _db.collection("users").doc(AuthHelper.getId());
    await docRef.get().then(
      (DocumentSnapshot doc) {
        var data = doc.data() as Map<String, dynamic>;
        return data['role'] == "admin" ? true : false;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return false;
  }

  static upLoadImage({required String name, required String filePath}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child(name);
    File file = File(filePath);
    String url = "";
    try {
      await mountainsRef.putFile(file);
      url = await mountainsRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

  static void sendPushMessage(String token, String body, String title) async {
    try {
      await connect.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAEv73EvY:APA91bF9FBX1a23fyUvHxWIol5PVwRaDk07TkiLb68qAIuk9c6tZ6PBzjyRn-PGLkClQjaCBkN8JDBGfRifbYPv_5pRo3W0yaSzl0omgSf9mwbbnJ8eM7WTthkRv59FF-ReQhFQGIzZ0'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          'notification': <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": "dbfood"
          },
          "to": token,
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
