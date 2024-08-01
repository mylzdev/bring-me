import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PhotoPickerException implements Exception {
  PhotoPickerException({this.message = 'Error with photo picker'});

  final String message;
}

class PhotoPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<Uint8List> takePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.camera);

      if (photo == null) throw PhotoPickerException();

      final bytes = await photo.readAsBytes();
      return bytes;
    } on Exception {
      throw PhotoPickerException();
    }
  }

  Future<Uint8List> pickPhoto() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (photo == null) throw PhotoPickerException();

      final bytes = await photo.readAsBytes();
      return bytes;
    } on Exception {
      throw PhotoPickerException();
    }
  }
}
