import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_testapp/secret.dart';
import 'package:http/http.dart' as http;

void main() {
  Stripe.publishableKey = publishableKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter stripe 결제 연습",
      home: StripeExample(),
    );
  }
}

class StripeExample extends StatefulWidget {
  const StripeExample({super.key});

  @override
  State<StripeExample> createState() => _StripeExampleState();
}

class _StripeExampleState extends State<StripeExample> {

  //amount는 돈의 양, currency는 화폐종류 ex) USD, KRW
  dynamic createPaymentIntent(String amount, String currency) async{
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      if(kDebugMode){
        print("1 : 에러가 발생했습니다!");
        print(err);
      }
    }
  }

  //client_secret을 불러오고 화면에 stripe결제 실행
  Future<void> makePayment(BuildContext context) async { 
    try{
      var paymentIntentData = await createPaymentIntent("100", "USD") ?? {};

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData['client_secret'],
        style: ThemeMode.light,
        customFlow: false,
        merchantDisplayName: 'test App'
      )).then((value) => displayPaymentSheet(context));
    } catch (err) {
      if(kDebugMode){
        print("2 : 에러가 발생했습니다!");
        print(err);
      }
    }
  }

  //결제 성공시 snackbar 실행
  void displayPaymentSheet(BuildContext context) async{
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("결제가 성공적으로 진행되셨습니다!")));
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e){
      if (kDebugMode) {
        print('결제 오류 : $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("stripe 결제 예제", style: TextStyle(
            fontSize: 20, color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              paymentButton(context)
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton paymentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        makePayment(context);
      },
      child: const Text("결제 실행"),
    );
  }
}
