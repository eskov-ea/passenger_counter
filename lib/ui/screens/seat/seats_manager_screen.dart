import 'package:flutter/material.dart';
import 'package:pleyona_app/models/seat_model.dart';
import 'package:pleyona_app/services/database/db_provider.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/popup.dart';
import 'package:pleyona_app/ui/widgets/seats/seat_widget.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class SeatManagerScreen extends StatefulWidget {
  const SeatManagerScreen({super.key});

  @override
  State<SeatManagerScreen> createState() => _SeatManagerScreenState();
}

class _SeatManagerScreenState extends State<SeatManagerScreen> with SingleTickerProviderStateMixin {

  final DBProvider _db = DBProvider.db;
  List<Seat> seats = [];
  List<int> selectedIds = [];
  bool selectionMode = false;
  late AnimationController _animationController;
  late Animation animation;
  late Animation scaleAnimation;


  @override
  void initState() {

    _db.getSeats().then((value) {
      setState(() {
        seats = value;
      });
    });

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 100)
    )..addListener(() {
      setState(() {

      });
    });
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );

    super.initState();
  }

  void _selectSeat(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.removeWhere((sId) => sId == id);
    } else {
      selectedIds.add(id);
    }
    if ( !selectionMode) {
      selectionMode = true;
      _animationController.reverse();
    }
    setState(() {});
  }
  void _onSelectionDone() {
    selectedIds = [];
    selectionMode = false;
    _animationController.forward();
    setState(() {});
  }
  void _onSelectionStart() {
    setState(() {
      selectionMode = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(scrollController: null, hideHomeButton: true, child: Text("Менеджмент кают",
          style: AppStyles.mainTitleTextStyle)),
      body: ThemeBackgroundWidget(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 150, width: double.infinity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: selectionMode ? Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      _onSelectionDone();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      child: Text('Отменить'),
                    ),
                  ),
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 - 23,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      alignment: Alignment.center,
                      child: const Text.rich(
                        TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.circle, color: Color(0xcc33d33a), size: 22)),
                              WidgetSpan(child: SizedBox(width: 10,)),
                              WidgetSpan(child: Text("В работе", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 - 23,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      alignment: Alignment.center,
                      child: const Text.rich(
                        TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.circle, color: Color(0xcce80606), size: 22)),
                              WidgetSpan(child: SizedBox(width: 10,)),
                              WidgetSpan(child: Text("Выключены", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: seats.length,
                    itemBuilder: (context, index) {
                      final selected = selectedIds.contains(seats[index].id);
                      return GestureDetector(
                        onTap: () async {
                          if (selectionMode) {
                            _selectSeat(seats[index].id);
                          } else {
                            // await _openSeatInformation(seats![key]!.seat, passengers, state.availableSeats, state.tripPassengers);
                          }
                        },
                        onLongPress: () {
                          if (selectionMode) return;
                          _selectSeat(seats[index].id);
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: seats[index].status == 0 ? const Color(0xcce80606) : const Color(0xcc33d33a),
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(width: 1, color: const Color(0xC0000000))
                              ),
                              child: Text("${seats[index].cabinNumber}${seats[index].placeNumber}",
                                style: AppStyles.submainTitleTextStyle,
                              ),
                            ),
                            selected ? Container(
                              decoration: const BoxDecoration(
                                color: Color(0x80FFFFFF),
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                              ),
                            ) : const SizedBox.shrink(),
                            selected ? Container(
                              margin: EdgeInsets.only(right: 2, bottom: 2),
                              child: Image.asset("assets/icons/select-icon.png",
                                width: 30, height: 30,
                              ),
                            ) : const SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4
                    )
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 65 * _animationController.value),
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text('Выключить', textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600,
                                    color: selectedIds.isNotEmpty ? const Color(0xFFCE0105) : const Color(0x30000000)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            child: Text(selectionMode ? 'Выбрано ${selectedIds.length}' : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text('Включить', textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600, height: 1,
                                    color: selectedIds.isNotEmpty ? const Color(0xFF000000) : const Color(0x30000000)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }
}
