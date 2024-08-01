import 'dart:math';

import 'package:bring_me/src/core/config/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/text_strings.dart';
import '../popups/popups.dart';

class THelperFunctions {
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static Future<DateTime?> toggleDatePicker(DateTime? initialDate) async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime.utc(2025, 10, 16),
    );
  }

  static Future<TimeOfDay?> toggleClockPicker() async {
    return await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
  }

  static Future<void> launchLink(String url) async {
    try {
      final link = Uri.parse(url);
      if (await canLaunchUrl(link)) {
        await launchUrl(link);
      } else {
        throw 'Could not launch $link';
      }
    } catch (e) {
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  static int createUniqueId() {
    return DateTime.now().microsecondsSinceEpoch.remainder(3);
  }

  static String generateRoomID() {
    final random = Random();
    const length = 5;
    final StringBuffer randomNumberString = StringBuffer();

    for (int i = 0; i < length; i++) {
      randomNumberString.write(random.nextInt(10));
    }

    return randomNumberString.toString();
  }

  static String getHuntLocation(HuntLocation loc) {
    switch (loc) {
      case HuntLocation.indoor:
        return 'Indoor';
      case HuntLocation.outdoor:
        return 'Outdoor';
      default:
        return 'Indoor';
    }
  }

  static int generateRandomInt(int max) {
    return Random().nextInt(max);
  }

  static String convertMinutesToTimeFormat(int totalMinutes) {
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    // Ensuring two-digit format for minutes
    final String formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$hours:$formattedMinutes';
  }
}
