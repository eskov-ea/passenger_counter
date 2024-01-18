import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_bloc.dart';
import 'package:pleyona_app/bloc/current_trip_bloc/current_trip_event.dart';
import 'package:pleyona_app/models/passenger/passenger.dart';
import 'package:pleyona_app/models/passenger/passenger_bagage.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/models/trip_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/seat/search_seat.dart';
import 'package:pleyona_app/ui/screens/trip/trip_search_screen.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/passenger/passenger_bagage_info.dart';
import 'package:pleyona_app/ui/widgets/person/person_card_fullsize.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/seats/seat_card.dart';
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
  PersonDocument? currentPersonDocument;
  int? activePersonDocument;
  Trip? trip;
  Seat? seat;
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

  void setTrip(Trip t) {
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

  void setSeat(Seat s) {
    setState(() {
      seat = s;
    });
    Navigator.of(context).pop();
  }

  Future<void> _checkIfPersonAlreadyRegistered() async {
    final passenger = await _db.checkIfPersonRegisteredOnTrip(personId: person!.id, tripId: trip!.id);
    if (passenger != null) {
      person = null;
      seat = null;
      await showPopup(context, dismissible: true, type: PopupType.warning, message: 'Пассажир уже зарегистрирован на этот рейс');
      setState(() {});
    }
  }

  Future<void> _onSafe() async {
    if (person != null && personDocuments != null && trip != null && seat != null) {
      await _checkIfPersonAlreadyRegistered();
      if (personDocuments!.length > 1) {
        await _openChoosePersonDocument();
      } else {
        currentPersonDocument = personDocuments!.first;
      }
      try {
        String document = "";
        personDocuments!.forEach((doc) {
          document += doc.toString();
        });
        final passenger = Passenger(
            id: 0,
            tripId: trip!.id,
            personId: person!.id,
            seatId: seat!.id,
            personDocumentId: currentPersonDocument!.id!,
            status: 1,
            comments: commentTextController.text,
            createdAt: "",
            updatedAt: ""
        );
        BlocProvider.of<CurrentTripBloc>(context).add(AddNewTripPassengerEvent(passenger: passenger, baggage: personBagage));
        Navigator.pushReplacementNamed(context, MainNavigationRouteNames.homeScreen);
      } catch (err, stack) {
        showPopup(context, dismissible: true, type: PopupType.error, message: "Произошла ошибка при обработке запроса. Попробуйте ещё раз.");
      }
    } else {
      showPopup(context, dismissible: true, type: PopupType.warning, message: "Необходимо выбрать Персону, Рейс и Место для того, чтобы зарегистрировать пассажира.");
    }
  }

  Future<void> _openChoosePersonDocument() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Выберите документ"),
              content: Column(
                children: [
                  Text("Выберите документ для регистрации пассажира на рейс из ранее зарегистрированных."),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: ListView.builder(
                        itemCount: personDocuments!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activePersonDocument = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              height: 60,
                              decoration: const BoxDecoration(
                                  color: Color(0xBBFFFFFF),
                                  borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: Text("${personDocuments![index].name} ${personDocuments![index].description}"),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Выбрать документ',
                    style: TextStyle(color: activePersonDocument == null ? const Color(0x666f1dbb) : const Color(0xff6f1dbb),
                        fontSize: 18, fontWeight: FontWeight.w500
                    ),
                  ),
                  onPressed: () {
                    if (activePersonDocument == null) return;
                    currentPersonDocument = personDocuments![activePersonDocument!];
                    activePersonDocument = null;
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                TextButton(
                  child: const Text('Назад'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      activePersonDocument = null;
                    });
                  },
                ),
              ],
            );
          }
        );
      }
    );
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
                      const BlockTitle(message: "Выбор места", bottomPadding: 0),
                      _seatBlock(),
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
          TripCard(trip: trip!, callback: (Trip trip) {  } ),
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

  Widget _seatBlock() {
    if (trip == null || person == null) {
      return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 100,
        child: Text('Выберите рейс и персону'),
      );
    }
    if (seat != null) {
      return Column(
        children: [
          SeatCard(seat: seat!),
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
                      MainNavigationRouteNames.seatSearchScreen,
                      arguments: SeatSearchScreenArguments(onResultCallback: setSeat, tripId: trip!.id, person: person)
                  );
                },
                customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                splashColor: const Color(0xB3FFFFFF),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Изменить место"),
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
              image: DecorationImage(image: AssetImage("assets/icons/seat.png"),
                  opacity: 0.5, fit: BoxFit.scaleDown, scale: 8
              )
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.seatSearchScreen,
                  arguments: SeatSearchScreenArguments(onResultCallback: setSeat, tripId: trip!.id, person: person)
              );
            },
            customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            splashColor: const Color(0xB3FFFFFF),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text("Выбрать место"),
            ),
          ),
        ),
      );
    }
  }
}
