// Phase 3: Payment Gateway Integration - NetBanking Details Model
// Created for CDAX App netbanking payment processing

import 'package:flutter/foundation.dart';

@immutable
class NetbankingDetails {
  const NetbankingDetails({
    required this.bankCode,
    required this.bankName,
  });

  final String bankCode;
  final String bankName;

  @override
  String toString() {
    return 'NetbankingDetails{bankCode: $bankCode, bankName: $bankName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetbankingDetails &&
          runtimeType == other.runtimeType &&
          bankCode == other.bankCode &&
          bankName == other.bankName;

  @override
  int get hashCode => Object.hash(bankCode, bankName);
}

/// Supported banks for netbanking
class SupportedBanks {
  static const List<NetbankingDetails> banks = [
    NetbankingDetails(bankCode: 'SBI', bankName: 'State Bank of India'),
    NetbankingDetails(bankCode: 'HDFC', bankName: 'HDFC Bank'),
    NetbankingDetails(bankCode: 'ICICI', bankName: 'ICICI Bank'),
    NetbankingDetails(bankCode: 'AXIS', bankName: 'Axis Bank'),
    NetbankingDetails(bankCode: 'KOTAK', bankName: 'Kotak Mahindra Bank'),
    NetbankingDetails(bankCode: 'PNB', bankName: 'Punjab National Bank'),
    NetbankingDetails(bankCode: 'BOB', bankName: 'Bank of Baroda'),
    NetbankingDetails(bankCode: 'CANARA', bankName: 'Canara Bank'),
    NetbankingDetails(bankCode: 'UNION', bankName: 'Union Bank of India'),
    NetbankingDetails(bankCode: 'INDIAN', bankName: 'Indian Bank'),
    NetbankingDetails(bankCode: 'BOI', bankName: 'Bank of India'),
    NetbankingDetails(bankCode: 'CENTRAL', bankName: 'Central Bank of India'),
    NetbankingDetails(bankCode: 'INDUSIND', bankName: 'IndusInd Bank'),
    NetbankingDetails(bankCode: 'YES', bankName: 'YES Bank'),
    NetbankingDetails(bankCode: 'FEDERAL', bankName: 'Federal Bank'),
    NetbankingDetails(bankCode: 'SOUTH', bankName: 'South Indian Bank'),
  ];

  /// Get bank details by code
  static NetbankingDetails? getBankByCode(String code) {
    try {
      return banks.firstWhere((bank) => bank.bankCode == code);
    } catch (e) {
      return null;
    }
  }

  /// Get bank details by name
  static NetbankingDetails? getBankByName(String name) {
    try {
      return banks.firstWhere((bank) => bank.bankName == name);
    } catch (e) {
      return null;
    }
  }
}
