import 'package:faskes/models/type_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/type_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AddType extends StatefulWidget {
  const AddType({super.key});

  @override
  State<AddType> createState() => _AddTypeState();
}

class _AddTypeState extends State<AddType> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;

  void _saveCategory() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (_formKey.currentState!.validate()) {
      TypeModel cat = TypeModel(
        name: name,
        desc: description,
      );

      try {
        TypeService().add(cat);

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jenis Faskes berhasil ditambahkan'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jenis Faskes gagal ditambahkan'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jenis Faskes"),
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
                    hintText: 'Nama Jenis',
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
                          _saveCategory();
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
