import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/view_model/phase1_view_models/phase1_search_view_model.dart';
import 'package:provider/provider.dart';

class Phase1SearchApplicant extends StatefulWidget {
  const Phase1SearchApplicant({
    super.key,
    // required this.searchedkey,
  });

  @override
  State<Phase1SearchApplicant> createState() => _Phase1SearchApplicantState();
}

class _Phase1SearchApplicantState extends State<Phase1SearchApplicant> {
  // final String searchedkey;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<Phase1SearchViewModel>(context);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()),
                  ),
                ),
                ReusableButton(
                  buttonText: "Search",
                  width: 100,
                  onPressed: () {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    searchProvider.onSearch(searchController, context);
                  },
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Note: Search by Survey number, Applicant name, Application number, Mobile number, and Village name',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
