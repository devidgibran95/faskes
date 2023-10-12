import 'package:faskes/pages/component/fasilitasterdekat.dart';
import 'package:faskes/pages/component/heading.dart';
import 'package:faskes/pages/component/labelsection.dart';
import 'package:faskes/pages/component/search.dart';
import 'package:faskes/pages/component/top.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: medium, top: 50, right: medium),
          child: Column(
            children: [
              const HeadingSection(),
              SizedBox(height: medium),
              const SearchSection(),
              SizedBox(height: medium),
              LabelSection(
                text: 'Fasilitas terdekat',
                style: heading1,
              ),
              SizedBox(height: medium),
              const FaskesTerdekat(),
              SizedBox(height: medium),
              LabelSection(
                text: 'Category',
                style: heading1,
              ),
              SizedBox(height: medium),
              const Top(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 94,
        child: BottomNavigationBar(
          selectedItemColor: ancent,
          unselectedItemColor: icon,
          backgroundColor: white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
