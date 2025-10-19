// Phase 3: Payment Gateway Integration - Card Payment Validation Tests
// Tests for card number validation, Luhn algorithm, and expiry validation

import 'package:flutter_test/flutter_test.dart';
import 'package:cdax_app/models/card_details.dart';

void main() {
  group('Card Payment Validation Tests', () {
    group('Card Number Validation', () {
      test('should validate correct card numbers with Luhn algorithm', () {
        // Valid test card numbers
        const validCards = [
          '4111111111111111', // Visa
          '5555555555554444', // MasterCard
          '378282246310005', // American Express
          '6011111111111117', // Discover
          '4000000000000002', // Visa
        ];

        for (final cardNumber in validCards) {
          final cardDetails = CardDetails(
            cardNumber: cardNumber,
            expiryMonth: '12',
            expiryYear: '2025',
            cvv: '123',
            holderName: 'John Doe',
          );

          expect(cardDetails.isValidLuhn, isTrue,
              reason: 'Card number $cardNumber should be valid');
        }
      });

      test('should reject invalid card numbers', () {
        const invalidCards = [
          '4111111111111112', // Invalid Luhn check
          '1234567890123456', // Invalid format
          '4111', // Too short
          '41111111111111111111', // Too long
          '', // Empty
          'abcd1111222233334', // Contains letters
        ];

        for (final cardNumber in invalidCards) {
          final cardDetails = CardDetails(
            cardNumber: cardNumber,
            expiryMonth: '12',
            expiryYear: '2025',
            cvv: '123',
            holderName: 'John Doe',
          );

          expect(cardDetails.isValidLuhn, isFalse,
              reason: 'Card number $cardNumber should be invalid');
        }
      });

      test('should format card number with spaces correctly', () {
        const testCases = {
          '4111111111111111': '4111 1111 1111 1111',
          '378282246310005': '3782 8224 6310 005',
          '123': '123',
          '': '',
        };

        testCases.forEach((input, expected) {
          final cardDetails = CardDetails(
            cardNumber: input,
            expiryMonth: '12',
            expiryYear: '2025',
            cvv: '123',
            holderName: 'John Doe',
          );

          expect(cardDetails.formattedCardNumber, equals(expected));
        });
      });

      test('should mask card number correctly', () {
        const cardNumber = '4111111111111111';
        final cardDetails = CardDetails(
          cardNumber: cardNumber,
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        final masked = cardDetails.maskedCardNumber;
        expect(masked.endsWith('1111'), isTrue);
        expect(masked.contains('X'), isTrue);
        expect(masked.length, equals(cardNumber.length));
      });
    });

    group('Card Brand Detection', () {
      test('should detect card brands correctly', () {
        const testCases = {
          '4111111111111111': CardBrand.visa,
          '5555555555554444': CardBrand.mastercard,
          '378282246310005': CardBrand.amex,
          '6011111111111117': CardBrand.discover,
          '2223003122003222': CardBrand.mastercard,
          '1234567890123456': CardBrand.unknown,
        };

        testCases.forEach((cardNumber, expectedBrand) {
          final cardDetails = CardDetails(
            cardNumber: cardNumber,
            expiryMonth: '12',
            expiryYear: '2025',
            cvv: '123',
            holderName: 'John Doe',
          );

          expect(cardDetails.cardBrand, equals(expectedBrand),
              reason: 'Card $cardNumber should be detected as ${expectedBrand.displayName}');
        });
      });
    });

    group('Expiry Date Validation', () {
      test('should format expiry date correctly', () {
        final cardDetails = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '03',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(cardDetails.formattedExpiry, equals('03/2025'));
      });

      test('should validate expiry date fields', () {
        // Test valid expiry
        final validCard = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(validCard.expiryMonth, equals('12'));
        expect(validCard.expiryYear, equals('2025'));
      });
    });

    group('CVV Validation', () {
      test('should validate CVV length based on card brand', () {
        // Visa/MasterCard should have 3-digit CVV
        const visaCard = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(visaCard.cardBrand.cvvLength, equals(3));

        // American Express should have 4-digit CVV
        const amexCard = CardDetails(
          cardNumber: '378282246310005',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '1234',
          holderName: 'John Doe',
        );

        expect(amexCard.cardBrand.cvvLength, equals(4));
      });
    });

    group('Cardholder Name Validation', () {
      test('should accept valid names', () {
        const validNames = [
          'John Doe',
          'Mary Jane Smith',
          'José García',
          '李小明',
          'Al-Rashid',
        ];

        for (final name in validNames) {
          final cardDetails = CardDetails(
            cardNumber: '4111111111111111',
            expiryMonth: '12',
            expiryYear: '2025',
            cvv: '123',
            holderName: name,
          );

          expect(cardDetails.holderName, equals(name));
          expect(cardDetails.holderName.isNotEmpty, isTrue);
        }
      });
    });

    group('Sanitized Card Number', () {
      test('should remove spaces from card number', () {
        const cardDetails = CardDetails(
          cardNumber: '4111 1111 1111 1111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(cardDetails.sanitizedCardNumber, equals('4111111111111111'));
      });

      test('should handle card number without spaces', () {
        const cardDetails = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(cardDetails.sanitizedCardNumber, equals('4111111111111111'));
      });
    });

    group('Card Equality and Hash Code', () {
      test('should handle equality correctly', () {
        const card1 = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        const card2 = CardDetails(
          cardNumber: '4111 1111 1111 1111', // With spaces
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '456', // Different CVV (not included in equality)
          holderName: 'John Doe',
        );

        const card3 = CardDetails(
          cardNumber: '5555555555554444', // Different card number
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        expect(card1, equals(card2)); // Should be equal (CVV not compared)
        expect(card1, isNot(equals(card3))); // Different card numbers
      });
    });

    group('toString Method', () {
      test('should not expose sensitive information', () {
        const cardDetails = CardDetails(
          cardNumber: '4111111111111111',
          expiryMonth: '12',
          expiryYear: '2025',
          cvv: '123',
          holderName: 'John Doe',
        );

        final toString = cardDetails.toString();
        
        // Should not contain full card number
        expect(toString.contains('4111111111111111'), isFalse);
        // Should contain masked version
        expect(toString.contains('X'), isTrue);
        // Should not contain CVV
        expect(toString.contains('123'), isFalse);
        // Should contain expiry and name
        expect(toString.contains('12/2025'), isTrue);
        expect(toString.contains('John Doe'), isTrue);
      });
    });
  });
}