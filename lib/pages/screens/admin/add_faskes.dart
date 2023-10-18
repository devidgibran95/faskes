import 'dart:io';

import 'package:faskes/models/category_model.dart';
import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/region_model.dart';
import 'package:faskes/models/type_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/category_service.dart';
import 'package:faskes/services/faskes_service.dart';
import 'package:faskes/services/region_service.dart';
import 'package:faskes/services/type_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

class AddFaskes extends StatefulWidget {
  const AddFaskes({super.key});

  @override
  State<AddFaskes> createState() => _AddFaskesState();
}

class _AddFaskesState extends State<AddFaskes> {
  TextEditingController namaController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? dropdownValue;

  List<CategoryModel>? categories;
  List<RegionModel>? regions;
  List<TypeModel>? types;

  CategoryModel? selectedCategory;
  TypeModel? selectedType;
  RegionModel? selectedRegion;

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? mediaFile;

  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    try {
      CategoryService().getCategories().then((value) {
        setState(() {
          categories = value;
        });

        TypeService().getTypes().then((value) {
          setState(() {
            types = value;
          });

          RegionService().getRegions().then((value) {
            setState(() {
              regions = value;
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
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
        .child('faskes_images')
        .child(id)
        .child(fileName);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    ref.putFile(File(file.path), metadata).then((p0) {
      p0.ref.getDownloadURL().then((value) {
        FaskesService().updateFaskesImageUrl(id, value);
      });
    });
  }

  saveFaskes() async {
    setState(() {
      isLoading = true;
    });

    final name = namaController.text;
    final address = addressController.text;

    if (name.isEmpty ||
        address.isEmpty ||
        descController.text.isEmpty ||
        phoneController.text.isEmpty ||
        latController.text.isEmpty ||
        longController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data harus diisi semua'),
        ),
      );
    } else if (selectedCategory == null ||
        selectedType == null ||
        selectedRegion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Kategori, Jenis, dan Wilayah Faskes tidak boleh kosong'),
        ),
      );
    } else if (mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto Faskes tidak boleh kosong'),
        ),
      );
    } else {
      try {
        final faskes = FaskesModel(
          name: name,
          address: address,
          categoryId: selectedCategory!.id,
          typeId: selectedType!.id,
          regionId: selectedRegion!.id,
          imageUrl: "-",
          desc: descController.text,
          phone: phoneController.text,
          latitude: double.parse(latController.text),
          longitude: double.parse(longController.text),
        );

        await FaskesService().add(faskes).then((value) {
          addImageToFirebase(value, mediaFile!);

          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fasilitas Kesehatan berhasil ditambahkan'),
            ),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fasilitas Kesehatan gagal ditambahkan'),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
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
        title: const Text("Tambah Fasilitas Kesehatan"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              MyTextField(
                  controller: namaController,
                  hintText: "Nama Fasilitas Kesehatan",
                  keyboardType: TextInputType.text,
                  obscureText: false),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 15,
              ),
              categories == null
                  ? const SizedBox.shrink()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: DropdownButton<CategoryModel>(
                          isExpanded: true,
                          icon: const FaIcon(FontAwesomeIcons.angleDown),
                          underline: const SizedBox(),
                          value: selectedCategory,
                          items: categories!
                              .map<DropdownMenuItem<CategoryModel>>((value) {
                            return DropdownMenuItem<CategoryModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                          hint: const Text(
                            "Pilih Kategori Fasilitas Kesehatan",
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              types == null
                  ? const SizedBox.shrink()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: DropdownButton<TypeModel>(
                          isExpanded: true,
                          icon: const FaIcon(FontAwesomeIcons.angleDown),
                          underline: const SizedBox(),
                          value: selectedType,
                          items:
                              types!.map<DropdownMenuItem<TypeModel>>((value) {
                            return DropdownMenuItem<TypeModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                          hint: const Text(
                            "Pilih Jenis Fasilitas Kesehatan",
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              regions == null
                  ? const SizedBox.shrink()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: DropdownButton<RegionModel>(
                          isExpanded: true,
                          icon: const FaIcon(FontAwesomeIcons.angleDown),
                          underline: const SizedBox(),
                          value: selectedRegion,
                          items: regions!
                              .map<DropdownMenuItem<RegionModel>>((value) {
                            return DropdownMenuItem<RegionModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                          hint: const Text(
                            "Pilih Wilayah Fasilitas Kesehatan",
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedRegion = value;
                            });
                          },
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              MyTextField(
                  controller: descController,
                  hintText: "Deskripsi Fasilitas Kesehatan",
                  keyboardType: TextInputType.text,
                  obscureText: false),
              const SizedBox(height: 20),
              MyTextField(
                  controller: phoneController,
                  hintText: "Nomor Telepon Fasilitas Kesehatan",
                  keyboardType: TextInputType.phone,
                  obscureText: false),
              const SizedBox(height: 20),
              MyTextField(
                  controller: addressController,
                  hintText: "Alamat Fasilitas Kesehatan",
                  keyboardType: TextInputType.text,
                  obscureText: false),
              const SizedBox(height: 20),
              MyTextField(
                  controller: latController,
                  hintText: "Latitude Fasilitas Kesehatan",
                  keyboardType: TextInputType.number,
                  obscureText: false),
              const SizedBox(height: 20),
              MyTextField(
                  controller: longController,
                  hintText: "Longitude Fasilitas Kesehatan",
                  keyboardType: TextInputType.number,
                  obscureText: false),
              const SizedBox(height: 20),
              // create container that can be clicked to select image using image picker pacakge
              InkWell(
                onTap: () {
                  selectImage(context);
                },
                child: Container(
                  height: mediaFile != null
                      ? MediaQuery.of(context).size.height * 0.5
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  padding: mediaFile != null
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: mediaFile != null
                      ? Image.file(
                          File(mediaFile!.path),
                          fit: BoxFit.cover,
                        )
                      : const Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Pilih foto Fasilitas Kesehatan",
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : SizedBox(
                      height: 50,
                      child: GFButton(
                          onPressed: () {
                            saveFaskes();
                          },
                          color: Colors.blue,
                          fullWidthButton: true,
                          text: 'Simpan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
