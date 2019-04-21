import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';

class Payments extends StatefulWidget{
  @override
  _Payments createState() => _Payments();
}

class _Payments extends State<Payments> {
  @override
  void initState() {
    super.initState();
    StripeSource.setPublishableKey('pk_test_w90Vz7PgEo4MzccOWrQD0SPS00KofsT6oS');
  }

  @override
  Widget build(BuildContext context){
    return Container();
  }

}
