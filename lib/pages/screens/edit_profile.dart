import 'dart:io';

import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  UserModel userModel;
  EditProfile({required this.userModel, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confrimPasswordTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? mediaFile;

  bool isLoading = false;

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  setUserData() {
    setState(() {
      emailTextController.text = widget.userModel.email!;
      nameTextController.text = widget.userModel.name!;
      addressTextController.text = widget.userModel.address!;
      phoneTextController.text = widget.userModel.phone!;
      passwordTextController.text = widget.userModel.password!;
    });
  }

  void _setImageFileListFromFile(XFile? value) {
    mediaFile = value;
  }

  void addImageToFirebase(String id, XFile file) async {
    // get file name
    String fileName = file.path.split('/').last;

    //CreateRefernce to path.
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(id)
        .child(fileName);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    ref.putFile(File(file.path), metadata).then((p0) {
      p0.ref.getDownloadURL().then((value) {
        UserService().updateUserImageUrl(id, value);
      });
    });
  }

  updateUser() {
    final email = emailTextController.text.trim();
    final name = nameTextController.text.trim();
    final address = addressTextController.text.trim();
    final phone = phoneTextController.text.trim();
    final password = passwordTextController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field tidak boleh kosong'),
        ),
      );
    } else {
      UserModel user = UserModel(
        id: widget.userModel.id,
        email: email,
        name: name,
        address: address,
        phone: phone,
        password: password,
        role: widget.userModel.role,
      );

      if (mediaFile != null) {
        addImageToFirebase(user.id!, mediaFile!);
      }

      UserService().updateUser(user).then((value) {
        if (value != null) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil mengubah profil'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengubah profil'),
            ),
          );
        }
      });
    }
  }

  selectImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Foto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  try {
                    await _picker
                        .pickImage(
                      source: ImageSource.camera,
                      imageQuality: 100,
                    )
                        .then((value) {
                      setState(() {
                        _setImageFileListFromFile(value);
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  } catch (e) {
                    setState(() {
                      _pickImageError = e;
                    });
                  }
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
              ),
              ListTile(
                onTap: () async {
                  try {
                    await _picker
                        .pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                    )
                        .then((value) {
                      setState(() {
                        _setImageFileListFromFile(value);
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  } catch (e) {
                    setState(() {
                      _pickImageError = e;
                    });
                  }
                },
                leading: const Icon(Icons.image),
                title: const Text("Galeri"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profil"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        selectImage(context);
                      },
                      child: mediaFile == null
                          ? GFAvatar(
                              backgroundImage: NetworkImage(widget
                                      .userModel.image ??
                                  "https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-and-shapes-3/177800/130-512.png"),
                              shape: GFAvatarShape.circle,
                              size: 120,
                            )
                          : Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.file(
                                File(mediaFile!.path),
                                fit: BoxFit.cover,
                              )),
                    ),
                    const SizedBox(height: 30),
                    //email textfield
                    MyTextField(
                      controller: nameTextController,
                      hintText: 'Nama',
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: addressTextController,
                      hintText: 'Alamat',
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: phoneTextController,
                      hintText: 'Nomor Telepon',
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    //password textfield
                    MyTextField(
                      controller: passwordTextController,
                      hintText: 'Kata Sandi',
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),

                    //sign in button
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : SizedBox(
                            //SizedBox(
                            height: 50,
                            child: GFButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  updateUser();

                                  // signUp();
                                },
                                color: Colors.blue,
                                fullWidthButton: true,
                                text: 'Simpan'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
