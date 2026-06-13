import 'package:flutter/material.dart';
import 'package:lrsofficer/utils/reusable_button.dart';
import 'package:lrsofficer/view_model/phase2_shortfall_view_models/phase2_shortfall_search_view_model.dart';
import 'package:provider/provider.dart';

class Phase2ShortfallSearchApplicant extends StatefulWidget {
  const Phase2ShortfallSearchApplicant({
    super.key,
    // required this.searchedkey,
  });

  @override
  State<Phase2ShortfallSearchApplicant> createState() =>
      _Phase2ShortfallSearchApplicantState();
}

class _Phase2ShortfallSearchApplicantState
    extends State<Phase2ShortfallSearchApplicant> {
  // final String searchedkey;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<Phase2ShortfallSearchViewModel>(context);
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
