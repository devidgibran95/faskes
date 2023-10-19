import 'package:faskes/models/faskes_model.dart';
import 'package:faskes/models/rating_model.dart';
import 'package:faskes/pages/component/text_field.dart';
import 'package:faskes/services/rating_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AddRating extends StatefulWidget {
  FaskesModel faskes;
  AddRating({required this.faskes, super.key});

  @override
  State<AddRating> createState() => _AddRatingState();
}

class _AddRatingState extends State<AddRating> {
  double ratingValue = 0;

  TextEditingController komentarController = TextEditingController();

  bool isLoading = false;

  saveRating() {
    final komentar = komentarController.text.trim();

    if (komentar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar tidak boleh kosong'),
        ),
      );
    } else if (ratingValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating tidak boleh kosong'),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });

      RatingModel rating = RatingModel(
        faskesId: widget.faskes.id,
        comment: komentar,
        rating: ratingValue,
        userId: FirebaseAuth.instance.currentUser!.uid,
        createdAt: DateTime.now(),
      );

      try {
        RatingService().addRating(rating);

        setState(() {
          isLoading = false;
        });

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil menambahkan rating'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan rating'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Rating'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            GFRating(
              onChanged: (value) {
                setState(() {
                  ratingValue = value;
                });
              },
              value: ratingValue,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: komentarController,
              hintText: 'Komentar',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            //sign in button
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.blue,
                  )
                : SizedBox(
                    height: 50,
                    child: GFButton(
                        onPressed: () {
                          saveRating();
                        },
                        color: Colors.blue,
                        fullWidthButton: true,
                        text: 'Kirim Ulasan'),
                  ),
          ]),
        ),
      ),
    );
  }
}
