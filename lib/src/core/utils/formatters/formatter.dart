import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return intl.DateFormat('MMMM dd, yyyy')
        .format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount) {
    return intl.NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number format: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // Add more custom phone number formatting logic for different formats if needed.
    return phoneNumber;
  }

  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract the country code from the digitsOnly
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Add the remaining digits with proper formatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }

  static String formatMonthYear(int month, int year) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Invalid month: $month must be between 1 - 12');
    }

    DateTime date = DateTime(year, month, 1);

    String monthText = intl.DateFormat('MMMM yyyy').format(date);

    return monthText;
  }

  static String convert24To12HourFormat(String time24) {
    final time = intl.DateFormat.Hm().parse(time24);
    final formattedTime = intl.DateFormat('hh:mm a').format(time);
    return formattedTime;
  }

  // Method to convert list of XFILe to list of String
  static List<String> convertXFilesToStringList(List<XFile> xFiles) {
    return xFiles.map((xFile) => xFile.path).toList();
  }

  // Format string to date or month
  static String formatDayMonthString(String date, bool isMonth) {
    final formattedDate = DateTime.parse(date);
    if (isMonth) {
      return intl.DateFormat('dd').format(formattedDate);
    } else {
      return intl.DateFormat('MMM').format(formattedDate);
    }
  }

  // Format string date to more readable date
  static String formatStringDate(String date) {
    final formattedDate = DateTime.parse(date);
    return intl.DateFormat('MMMM dd, yyyy').format(formattedDate);
  }

  // Convert string to datetime
  static DateTime formatStringToDateTime(String date) {
    return DateTime.parse(date);
  }

  static bool isSameDate(DateTime current ,DateTime other) {
    return current.year == other.year &&
        current.month == other.month &&
        current.day == other.day;
  }
}
