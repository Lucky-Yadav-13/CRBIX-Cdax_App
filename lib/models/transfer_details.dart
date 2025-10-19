// Phase 3: Payment Gateway Integration - Transfer Details Model
// Created for CDAX App bank transfer payment processing

import 'package:flutter/foundation.dart';

@immutable
class TransferDetails {
  const TransferDetails({
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
  });

  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;

  /// Returns IFSC code in uppercase format
  String get formattedIfsc => ifscCode.toUpperCase();

  /// Validates IFSC code format: 4 letters + 0 + 6 alphanumeric
  bool get isValidIfsc {
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    return ifscRegex.hasMatch(formattedIfsc);
  }

  /// Validates account number: 9-18 digits
  bool get isValidAccountNumber {
    if (accountNumber.length < 9 || accountNumber.length > 18) {
      return false;
    }
    return RegExp(r'^\d+$').hasMatch(accountNumber);
  }

  /// Returns masked account number for display
  String get maskedAccountNumber {
    if (accountNumber.length < 4) return accountNumber;
    
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    final maskedPart = 'X' * (accountNumber.length - 4);
    return '$maskedPart$lastFour';
  }

  /// Extracts bank code from IFSC (first 4 characters)
  String get bankCode => formattedIfsc.length >= 4 ? formattedIfsc.substring(0, 4) : '';

  @override
  String toString() {
    return 'TransferDetails{accountNumber: $maskedAccountNumber, ifscCode: $formattedIfsc, accountHolderName: $accountHolderName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferDetails &&
          runtimeType == other.runtimeType &&
          accountNumber == other.accountNumber &&
          formattedIfsc == other.formattedIfsc &&
          accountHolderName == other.accountHolderName;

  @override
  int get hashCode => Object.hash(accountNumber, formattedIfsc, accountHolderName);
}

/// Common Indian bank IFSC prefixes for validation assistance
class BankIfscCodes {
  static const Map<String, String> bankNames = {
    'SBIN': 'State Bank of India',
    'HDFC': 'HDFC Bank',
    'ICIC': 'ICICI Bank',
    'UTIB': 'Axis Bank',
    'KKBK': 'Kotak Mahindra Bank',
    'PUNB': 'Punjab National Bank',
    'BARB': 'Bank of Baroda',
    'CNRB': 'Canara Bank',
    'UBIN': 'Union Bank of India',
    'IDIB': 'Indian Bank',
    'BKID': 'Bank of India',
    'CBIN': 'Central Bank of India',
    'INDB': 'IndusInd Bank',
    'YESB': 'YES Bank',
    'FDRL': 'Federal Bank',
    'SIBL': 'South Indian Bank',
  };

  /// Get bank name from IFSC code
  static String? getBankName(String ifscCode) {
    if (ifscCode.length < 4) return null;
    final bankCode = ifscCode.substring(0, 4).toUpperCase();
    return bankNames[bankCode];
  }

  /// Validate if IFSC belongs to a known bank
  static bool isKnownBank(String ifscCode) {
    return getBankName(ifscCode) != null;
  }
}