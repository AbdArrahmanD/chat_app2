import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class UserImagePicker extends StatefulWidget {
  File? pickedImage;
  UserImagePicker(
    this.pickedImage, {
    Key? key,
  }) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  ImagePicker picker = ImagePicker();
  void chooseImage(ImageSource src) async {
    final pickedImageFile = await picker.pickImage(source: src);
    if (pickedImageFile != null) {
      setState(() {
        widget.pickedImage = File(pickedImageFile.path);
      });
    } else {
      print('No Image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blueGrey,
          backgroundImage: widget.pickedImage != null
              ? FileImage(widget.pickedImage!)
              : null,
          radius: 50,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => chooseImage(ImageSource.camera),
              icon: Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Add Image\nFrom Camera',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
              onPressed: () => chooseImage(ImageSource.gallery),
              icon: Icon(
                Icons.image_outlined,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Add Image\nFrom Gallery',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
