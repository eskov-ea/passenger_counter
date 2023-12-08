import 'package:flutter/material.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_bagage.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/route_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/passenger/passenger_bagage_info.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_fullsize.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:pleyona_app/ui/widgets/trip/trip_card.dart';
import '../../widgets/form_block_title.dart';
import '../person/person_search_screen.dart';



class PassengerAddNewScreen extends StatefulWidget {
  const PassengerAddNewScreen({super.key});

  @override
  State<PassengerAddNewScreen> createState() => _PassengerAddNewScreenState();
}

class _PassengerAddNewScreenState extends State<PassengerAddNewScreen> {

  final ScrollController _scrollController = ScrollController();
  Person? person;
  List<PersonDocument>? personDocuments;
  TripModel? trip;
  final DBProvider _db = DBProvider.db;
  final TextEditingController commentTextController= TextEditingController();
  final FocusNode commentFieldFocus = FocusNode();
  final List<int> personBagage = [];


  Future<void> _openOnPopGuardAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы хотите сохранить черновик?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('У вас есть несохраненные данные.'),
                Text('Чтобы не потерять их, вы можете завершить заполнение формы или сохранить черновик и вернуться к его редактированию позже.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Выйти'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить черновик'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Продолжить редактирование'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setPerson(Person p) async {
    final documents = await _db.getPersonDocuments(personId: p.id);
    setState(() {
      person = p;
      personDocuments = documents;
    });
    Navigator.of(context).pop();
  }

  void setTrip(TripModel t) {
    setState(() {
      trip = t;
    });
    Navigator.of(context).pop();
  }

  void setBagage(List<TextEditingController> bagage) {
    for (int i=0; i < bagage.length; ++i) {
      if(bagage[i].text.trim().isNotEmpty) {
        personBagage.add(int.parse(bagage[i].text));
      }
    }
  }

  Future<void> _onSafe() async {
    if (person != null && personDocuments != null && trip != null) {
      try {
        final passenger = Passenger(
            id: 0,
            tripId: trip!.id,
            personId: person!.id,
            seatId: 101,
            document: personDocuments!,
            status: 1,
            comments: commentTextController.text,
            createdAt: "",
            updatedAt: "");
        final passengerId = await _db.addPassenger(p: passenger);
        for (int i=0; i<personBagage.length; ++i) {
          final bagage = PassengerBagage(
            id: 0,
            passengerId: passengerId,
            weight: personBagage[i],
            createdAt: "",
            updatedAt: ""
          );
          await _db.addPassengerBagage(b: bagage);
        }
        Navigator.pushReplacementNamed(context, MainNavigationRouteNames.homeScreen);
      } catch (err, stack) {
        // TODO: error handle
        print(err);
      }
    } else {

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(scrollController: null, child: Text("Новый пассажир", style: AppStyles.mainTitleTextStyle)),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 90),
                      const Divider(height: 1),
                      const BlockTitle(message: "Персона", bottomPadding: 0),
                      _personBlock(),
                      const SizedBox(height: 10),
                      const BlockTitle(message: "Рейс", bottomPadding: 0),
                      _tripBlock(),
                      const SizedBox(height: 10),
                      const BlockTitle(message: "Дополнительная информация",
                        bottomPadding: 0, alignment: Alignment.center,
                      ),
                      const SizedBox(height: 10),
                      PassengerBagageInfoWidget(resultCallback: setBagage),
                      const SizedBox(height: 10),
                      TextField(
                        controller: commentTextController,
                        focusNode: commentFieldFocus,
                        onTapOutside: (event) {
                          if(commentFieldFocus.hasFocus) {
                            commentFieldFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          label: Text("Добавить комментарий", style: AppStyles.submainTitleTextStyle,),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 15, bottom: 2.0, right: 15.0),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          fillColor: AppColors.textMain,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: AppColors.backgroundMain4
                              )
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                  color: AppColors.backgroundMain2
                              )
                          ),
                        ),
                        style: AppStyles.secondaryTextStyle,
                        maxLines: null,
                        minLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: trip != null && person != null && personDocuments != null
                  ? SaveButton(onTap: _onSafe, label: "Сохранить")
                  : SaveButton(onTap: () {}, label: "Сохранить", color: Color(0xBBFFFFFF),)
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _personBlock() {
    if(person != null && personDocuments != null) {
      return Column(
        children: [
          PersonCardFullSize(person: person!, personDocuments: personDocuments!),
          const SizedBox(height: 5),
          Material(
            color: AppColors.transparent,
            child: Ink(
              width: MediaQuery.of(context).size.width - 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: Color(0x80FFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                      MainNavigationRouteNames.searchPersonScreen,
                      arguments: SearchPersonScreenArguments(callback: setPerson)
                  );
                },
                customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                splashColor: const Color(0xB3FFFFFF),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Изменить персону"),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Material(
        color: AppColors.transparent,
        child: Ink(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0x80FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(image: AssetImage("assets/icons/search-person.png"),
              opacity: 0.5, fit: BoxFit.scaleDown, scale: 8
            )
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.searchPersonScreen,
                  arguments: SearchPersonScreenArguments(callback: setPerson)
              );
            },
            customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            splashColor: const Color(0xB3FFFFFF),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text("Выбрать персону"),
            ),
          ),
        ),
      );
    }
  }

  Widget _tripBlock() {
    if (trip != null) {
      return Column(
        children: [
          TripCard(trip: trip!, callback: (TripModel trip) {  } ),
          Material(
            color: AppColors.transparent,
            child: Ink(
              width: MediaQuery.of(context).size.width - 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0x80FFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                      MainNavigationRouteNames.tripSearchScreen,
                      arguments: TripSearchScreenArguments(onResultCallback: setTrip)
                  );
                },
                customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                splashColor: const Color(0xB3FFFFFF),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Изменить рейс"),
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Material(
        color: AppColors.transparent,
        child: Ink(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          decoration: const BoxDecoration(
              color: Color(0x80FFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(image: AssetImage("assets/icons/search.png"),
                  opacity: 0.5, fit: BoxFit.scaleDown, scale: 8
              )
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                MainNavigationRouteNames.tripSearchScreen,
                arguments: TripSearchScreenArguments(onResultCallback: setTrip)
              );
            },
            customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            splashColor: const Color(0xB3FFFFFF),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text("Выбрать рейс"),
            ),
          ),
        ),
      );
    }
  }
}
