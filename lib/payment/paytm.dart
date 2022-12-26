// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
//
// class PaytmConfig {
//   final String _mid = "AIoJSB06647351746673";
//   final String _mKey = "bKMfNxPPf_QdZppa";
//   final String _website = "DEFAULT";
//   final String _url = 'https://flutter-paytm-backend.herokuapp.com/generateTxnToken';
//
//   String get mid => _mid;
//   String get mKey => _mKey;
//   String get website => _website;
//   String get url => _url;
//
//   String getMap(double amount, String callbackUrl, String orderId) {
//     return json.encode({
//       "mid": mid,
//       "key_secret": mKey,
//       "website": website,
//       "orderId": orderId,
//       "amount": amount.toString(),
//       "callbackUrl": callbackUrl,
//       "custId": "CUSTOMER0001",
//     });
//   }
//
//   Future<void> generateTxnToken(double amount, String orderId) async {
//     final callBackUrl = 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
//     final body = getMap(amount, callBackUrl, orderId);
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//       debugPrint('respones ${response.statusCode}');
//       String txnToken =response.body;
//
//       debugPrint('vfvf => $txnToken');
//
//       await initiateTransaction(orderId, amount, txnToken, callBackUrl);
//     } catch (e) {
//       debugPrint('$e');
//     }
//   }
//
//   Future<void> initiateTransaction(String orderId, double amount,
//       String txnToken, String callBackUrl) async {
//     String result = '';
//     try {
//       var response = AllInOneSdk.startTransaction(
//         mid,
//         orderId,
//         amount.toString(),
//         "txnToken",
//         callBackUrl,
//         false,
//         false,
//       );
//
//       debugPrint('TXN Token $txnToken');
//       response.then((value) {
//         // Transaction successfull
//         debugPrint('$value');
//       }).catchError((onError) {
//         if (onError is PlatformException) {
//           result = "${onError.message!} \n  ${onError.details}";
//          // result = onError.message! + " \n  " + onError.details.toString();
//           debugPrint(result);
//         } else {
//           result = onError.toString();
//           debugPrint(result);
//         }
//       });
//     } catch (err) {
//       // Transaction failed
//       result = err.toString();
//       debugPrint(result);
//     }
//   }
// }