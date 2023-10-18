import 'package:faskes/models/category_model.dart';
import 'package:faskes/pages/screens/user/faskes_category_list.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CategoryCardWidget extends StatelessWidget {
  CategoryModel category;

  CategoryCardWidget({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: FaskesCategoryList(category: category),
          withNavBar: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(20)),
        height: 75,
        width: 200,
        margin: const EdgeInsets.only(right: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ancent,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 69,
                width: 69,
                child: Icon(Icons.category, color: white),
              ),
              SizedBox(width: xsmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(category.name!, style: heading4),
                    Expanded(
                      child: Text(
                        category.desc!,
                        style: p3,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
