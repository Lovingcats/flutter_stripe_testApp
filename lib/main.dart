import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_testapp/secret.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      print("에러가 발생했습니다!");
      print(err);
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
    );
  }
}
