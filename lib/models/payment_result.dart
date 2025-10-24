// Phase 3: Payment Gateway Integration - Payment Result Model
// Created for CDAX App payment flow results

import 'package:flutter/foundation.dart';

@immutable
class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.message,
    this.orderId,
    this.paymentId,
    this.signature,
    this.errorCode,
  });

  final bool success;
  final String message;
  final String? orderId;
  final String? paymentId;
  final String? signature;
  final String? errorCode;

  factory PaymentResult.success({
    required String message,
    String? orderId,
    String? paymentId,
    String? signature,
  }) =>
      PaymentResult(
        success: true,
        message: message,
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );

  factory PaymentResult.failure({
    required String message,
    String? orderId,
    String? errorCode,
  }) =>
      PaymentResult(
        success: false,
        message: message,
        orderId: orderId,
        errorCode: errorCode,
      );

  @override
  String toString() {
    return 'PaymentResult{success: $success, message: $message, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResult &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          orderId == other.orderId &&
          paymentId == other.paymentId;

  @override
  int get hashCode => Object.hash(success, message, orderId, paymentId);
}
