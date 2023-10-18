import 'package:faskes/models/category_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;

  void _saveCategory() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (_formKey.currentState!.validate()) {
      CategoryModel cat = CategoryModel(
        name: name,
        desc: description,
      );

      try {
        CategoryService().add(cat);

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategori Faskes berhasil ditambahkan'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kategori Faskes gagal ditambahkan'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kategori Faskes"),
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
                    hintText: 'Nama kategori',
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
