import 'package:diafit/pages/Order/Transaction/payment_form.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  final Map transaction;
  const Payment({super.key, required this.transaction});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaymentForm(
              transaction: widget.transaction,
            )
          ],
        ),
      ),
    );
  }
}
