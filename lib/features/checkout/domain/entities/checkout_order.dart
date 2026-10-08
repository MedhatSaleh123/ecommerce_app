import 'package:equatable/equatable.dart';

class CheckoutOrder extends Equatable {
  final String name;
  final String phone;
  final String address;
  final String paymentMethod;

  const CheckoutOrder({
    required this.name,
    required this.phone,
    required this.address,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [name, phone, address, paymentMethod];
}
