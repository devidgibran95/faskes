import 'package:faskes/pages/screens/user/faskes_search_result.dart';
import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SearchSection extends StatefulWidget {
  LocationData locationData;
  SearchSection({required this.locationData, super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorColor: ancent,
            style: p1,
            autocorrect: false,
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, size: 22, color: text),
              hintText: 'Cari faskes terdekat',
              hintStyle: p1,
              fillColor: white,
              contentPadding: EdgeInsets.symmetric(vertical: small),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: small),
        InkWell(
          onTap: () {
            if (_searchController.text.isNotEmpty) {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: FaskesSearchResult(
                  query: _searchController.text,
                  locationData: widget.locationData,
                ),
                withNavBar: false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text('Masukkan kata kunci pencarian'),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: ancent, borderRadius: BorderRadius.circular(12)),
            height: 50,
            width: 50,
            child: Icon(
              Icons.send,
              color: white,
            ),
          ),
        ),
      ],
    );
  }

  // dispose search controller
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
