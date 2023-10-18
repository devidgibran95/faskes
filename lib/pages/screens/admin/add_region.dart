import 'package:faskes/models/region_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/region_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AddRegion extends StatefulWidget {
  const AddRegion({super.key});

  @override
  State<AddRegion> createState() => _AddRegionState();
}

class _AddRegionState extends State<AddRegion> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;

  void save() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (_formKey.currentState!.validate()) {
      RegionModel cat = RegionModel(
        name: name,
        desc: description,
      );

      try {
        RegionService().add(cat);

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wilayah Faskes berhasil ditambahkan'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wilayah Faskes gagal ditambahkan'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Wilayah Faskes"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //email textfield
                  MyTextField(
                    controller: _nameController,
                    hintText: 'Nama wilayah',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),

                  const SizedBox(height: 25),

                  //password textfield
                  MyTextField(
                    controller: _descriptionController,
                    hintText: 'Deskripsi',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //sign in button
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.blue,
                  )
                : SizedBox(
                    height: 50,
                    child: GFButton(
                        onPressed: () {
                          save();
                        },
                        color: Colors.blue,
                        fullWidthButton: true,
                        text: 'Simpan'),
                  ),
          ],
        ),
      ),
    );
  }
}
