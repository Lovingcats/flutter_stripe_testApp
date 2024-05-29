import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_testapp/secret.dart';
import 'package:http/http.dart';

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
