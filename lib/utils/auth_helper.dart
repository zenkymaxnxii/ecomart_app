import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      "uid": AuthHelper.getId(),
    };
    await _db.collection("orders").add(order);
  }

  static orderGift(
      {required String uidGift,
        required String nameGift,
        required int price, required String url}) async {
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

  static updatePoint({required int point, required bool calculation}) async {
    final pointRef = _db.collection("reward_points").doc(AuthHelper.getId());
    Map<String, int> pointMap = {
      "point": point
    };
    if ((await pointRef.get()).exists) {
      await pointRef.update({
        "point": FieldValue.increment(calculation?point:point*(-1)),
      });
    } else {
      await _db.collection("reward_points").doc(AuthHelper.getId()).set(pointMap);
    }
  }

  static updateUser(String key, String value) async {
    return await _db
        .collection("users")
        .doc(AuthHelper.getId())
        .update({key: value});
  }
}
