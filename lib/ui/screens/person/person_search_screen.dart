import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_brief.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import '../../widgets/search_bar_widget.dart';

class FilterPersonModel with ChangeNotifier {
  final List<Person> _persons;
  List<Person>? _filteredPersons;

  FilterPersonModel(this._persons);

  List<Person> get persons =>
      _filteredPersons != null ? _filteredPersons! : _persons;

  void update(String? value) {
    if (value == null || value.trim() == "") {
      _filteredPersons = null;
    } else {
      _filterPersons(value);
    }
    notifyListeners();
  }

  void _filterPersons(String query) {
    List<Person> result = [];
    for (var person in _persons) {
      final name =
          "${person.lastname} ${person.firstname} ${person.middlename}";
      final regex = RegExp(query, caseSensitive: false, multiLine: false);
      if (regex.hasMatch(name)) {
        result.add(person);
      }
    }
    _filteredPersons = result;
  }
}

class SearchPersonScreen extends StatefulWidget {
  const SearchPersonScreen({required this.callback, Key? key})
      : super(key: key);

  final Function(Person person) callback;

  @override
  State<SearchPersonScreen> createState() => _SearchPersonScreenState();
}

class _SearchPersonScreenState extends State<SearchPersonScreen> {
  final DBProvider _db = DBProvider.db;
  late final FilterPersonModel dataNotifier;
  bool isInitialized = false;
  final ScrollController _controller = ScrollController();

  Future<void> initializePersons(String? value) async {
    final List<Person> res = await _db.getPersons(null);
    dataNotifier = FilterPersonModel(res);
    setState(() {
      isInitialized = true;
    });
  }

  @override
  void initState() {
    initializePersons(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.textMain,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(child: null, scrollController: null),
        body: ThemeBackgroundWidget(
          child: !isInitialized
              ? const Center(
            child: Center(child: CircularProgressIndicator()),
          )
              : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                SearchBarWidget(
                  callback: dataNotifier.update,
                  label: 'Поиск персоны',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(color: Colors.white70, height: 24)
                ),
                ListenableBuilder(
                    listenable: dataNotifier,
                    builder: (context, _) {
                      if (dataNotifier.persons.isNotEmpty) {
                        return Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: Scrollbar(
                              controller: _controller,
                              thumbVisibility: false,
                              thickness: 5,
                              trackVisibility: false,
                              radius: const Radius.circular(7),
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: dataNotifier.persons.length,
                                  itemBuilder: (context, index) {
                                    return PersonCardBrief(
                                        person: dataNotifier.persons[index],
                                        onTap: widget.callback);
                                  }),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 300,
                          child: Center(
                            child: Text(
                              "По данному запросу пассажиров не найдено",
                              style: AppStyles.submainTitleTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    }
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class SearchPersonScreenArguments {
  final Function(Person person) callback;
  SearchPersonScreenArguments({required this.callback});
}
