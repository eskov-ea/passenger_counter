import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_brief.dart';
import '../../widgets/search_bar_widget.dart';


class SearchPersonScreen extends StatefulWidget {
  const SearchPersonScreen({
    required this.callback,
    Key? key
  }) : super(key: key);

  final Function(Person person) callback;

  @override
  State<SearchPersonScreen> createState() => _SearchPersonScreenState();
}

class _SearchPersonScreenState extends State<SearchPersonScreen> {

  final DBProvider _db = DBProvider.db;
  List<Person>? searchResult;
  bool isSearching = false;

  Future<void> searchPerson(String? value) async {
    setState(() {
      isSearching = true;
    });
    if (value == null || value == "") {
      final res = await _db.getPersons(null);
      setState(() {
        searchResult = res;
      });
    } else if (value.isNotEmpty) {
      final res = await _db.findPerson(lastname: value);
      setState(() {
        searchResult = res;
      });
    }
    setState(() {
      isSearching = false;
    });
  }



  @override
  void initState() {
    searchPerson(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.textMain,

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 70,),
              SearchBarWidget(
                callback: searchPerson,
                label: 'Поиск персоны',
              ),
              Divider(),
              if (searchResult == null)
                Center(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (searchResult != null && searchResult!.isNotEmpty )
                 Expanded(
                  child: ListView.builder(
                    itemCount: searchResult!.length,
                    itemBuilder: (context, index) {
                      return PersonCardBrief(person: searchResult![index], onTap: widget.callback);
                    }
                  ),
                )
              else if (searchResult!.isEmpty)
                Container(
                  height: 300,
                  child: Center(
                    child: Text("По данному запросу пассажиров не найдено",
                      style: AppStyles.submainTitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
      )
    );
  }
}

class SearchPersonScreenArguments{
  final Function(Person person) callback;
  SearchPersonScreenArguments({required this.callback});
}