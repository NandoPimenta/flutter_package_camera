import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'image_picker_dialog.dart';

class ImagePickerHandler {
  late ImagePickerDialogWidget imagePicker;
  late final AnimationController _controller;
  // ignore: prefer_typing_uninitialized_variables
  late var compressToUpload;
  late final ImagePickerListener _listener;
  late BuildContext contexto;

  ImagePickerHandler(this._listener, this._controller);
  final picker = ImagePicker();
  Future openCamera() async {
    imagePicker.dismissDialog();

    final photo = (await picker.pickImage(source: ImageSource.camera));

    if (photo != null) {
      if (kIsWeb) {
        _listener.userImage(await photo.readAsBytes());
      } else {
        resizeImage(photo: photo);
      }
    } else {
      return;
    }
  }

  // Equipe Google
  // Future openGallery() async {
  //   imagePicker.dismissDialog();
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     _listener.userImage(image);
  //   }
  // }

// Adriano
  Future openGallery() async {
    try {
      imagePicker.dismissDialog();
      if (kIsWeb) {
        final photo = await picker.pickImage(source: ImageSource.gallery);
        if (photo != null) {
          _listener.userImage(await photo.readAsBytes());
        } else {
          return;
        }
      } else {
        final photo = await picker.pickImage(source: ImageSource.gallery);
        if (photo != null) {
          resizeImage(photo: photo);
        } else {
          return;
        }
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future resizeImage({photo = PickedFile}) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;

    Img.Image image = Img.decodeImage(await photo.readAsBytes())!;
    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    Img.Image thumbnail = Img.copyResize(image, width: 250);

    var rng = Random();
    var name = rng.nextInt(9999);
    // Save the thumbnail as a PNG.
    var compress = File("$path/thumbnail_$name.jpg")
      ..writeAsBytesSync(Img.encodeJpg(thumbnail));

    // print(image);
    // upload(photo); //aqui eu mandava a img grande ;
    //upload(compress);
    compressToUpload = compress;
    return _listener.userImage(compress);
  }

  void init() {
    // api
//    AUTH.getUserLogin().then((response) {
//      user = response;
//      print('Pugling foto view');
//      print(user);
//    });

    imagePicker = ImagePickerDialogWidget(this, _controller);
    imagePicker.initState();
  }

  showDialog(BuildContext context) {
    contexto = context;
    imagePicker.getImage(context);
  }
}
// final da class

 mixin ImagePickerListener {
  userImage(_image);
}
