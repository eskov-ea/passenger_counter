import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/models/route_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
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
      appBar: const CustomAppBar(child: Text("Новый пассажир", style: AppStyles.mainTitleTextStyle), scrollController: null),
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 90),
                const Divider(height: 1),
                const BlockTitle(message: "Персона", bottomPadding: 0),
                _personBlock(),
                const SizedBox(height: 20),
                const BlockTitle(message: "Рейс", bottomPadding: 0),
                _tripBlock(),
                const SizedBox(height: 40),
                const BlockTitle(message: "Дополнительная информация",
                    bottomPadding: 0, alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _personBlock() {
    if(person != null && personDocuments != null) {
      return PersonCardFullSize(person: person!, personDocuments: personDocuments!);
    } else {
      return Material(
        color: AppColors.transparent,
        child: Ink(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0x80FFFFFF),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: const DecorationImage(image: AssetImage("assets/icons/search-person.png"),
              opacity: 0.5, fit: BoxFit.scaleDown, scale: 8
            )
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.searchPersonScreen,
                  arguments: SearchPersonScreenArguments(callback: () {  })
              );
            },
            customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            splashColor: Color(0xB3FFFFFF),
            child: Align(
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
      return TripCard(trip: trip!);
    } else {
      return Material(
        color: AppColors.transparent,
        child: Ink(
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          decoration: BoxDecoration(
              color: Color(0x80FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              image: const DecorationImage(image: AssetImage("assets/icons/search.png"),
                  opacity: 0.5, fit: BoxFit.scaleDown, scale: 8
              )
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.tripSearchScreen
              );
            },
            customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            splashColor: Color(0xB3FFFFFF),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text("Выбрать рейс"),
            ),
          ),
        ),
      );
    }
  }
}
