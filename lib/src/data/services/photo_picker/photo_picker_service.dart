import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PhotoPickerException implements Exception {
  const PhotoPickerException([this.message = 'Error with photo picker']);

  final String message;
}

class PhotoPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<Uint8List> takePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.camera);

      if (photo == null) throw const PhotoPickerException();

      final bytes = await photo.readAsBytes();
      return bytes;
    } on PhotoPickerException catch (e) {
      throw PhotoPickerException(e.message).message;
    } catch (_) {
      rethrow;
    }
  }

  Future<XFile?> pickImage() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (photo == null) throw const PhotoPickerException();

      return photo;
    } on PhotoPickerException catch (e) {
      throw PhotoPickerException(e.message).message;
    } catch (_) {
      rethrow;
    }
  }

  Future<Uint8List> pickPhoto() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (photo == null) throw const PhotoPickerException();

      final bytes = await photo.readAsBytes();
      return bytes;
    } on PhotoPickerException catch (e) {
      throw PhotoPickerException(e.message).message;
    } catch (_) {
      rethrow;
    }
  }
}
