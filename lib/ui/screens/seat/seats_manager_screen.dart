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
  final Map<String, List<Seat>> seatsByCabinNumber = {};
  List<int> selectedIds = [];
  bool selectionMode = false;
  late AnimationController _animationController;
  late Animation animation;
  late Animation scaleAnimation;

  void _sortSeatsBySuite() {
    for (var seat in seats) {
      if (seatsByCabinNumber.containsKey(seat.cabinNumber)) {
        seatsByCabinNumber[seat.cabinNumber]!.add(seat);
      } else {
        seatsByCabinNumber.addAll({seat.cabinNumber: [seat]});
      }
    }
    seatsByCabinNumber.addAll({"202": [
        Seat(id: 9, cabinNumber: "202", placeNumber: "A", deck: "1", side: "1", barcode: "0002021", seatClass: 1, status: 1, comment: "", createdAt: "createdAt", updatedAt: "updatedAt"),
        Seat(id: 10, cabinNumber: "202", placeNumber: "B", deck: "1", side: "1", barcode: "0002022", seatClass: 1, status: 1, comment: "", createdAt: "createdAt", updatedAt: "updatedAt"),
    ]});
    seatsByCabinNumber.addAll({"203": [
        Seat(id: 11, cabinNumber: "203", placeNumber: "A", deck: "1", side: "1", barcode: "0002021", seatClass: 1, status: 1, comment: "", createdAt: "createdAt", updatedAt: "updatedAt"),
        Seat(id: 12, cabinNumber: "203", placeNumber: "B", deck: "1", side: "1", barcode: "0002022", seatClass: 1, status: 1, comment: "", createdAt: "createdAt", updatedAt: "updatedAt"),
    ]});
  }

  Widget _suitesItems() {
    final int margin = 70;
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: seatsByCabinNumber.entries.map(
          (cabin) {
            final koef = cabin.value.length == 4 ? 0 : 5;
            return Container(
              width: (MediaQuery.of(context).size.width - 60 - koef) / 4 * cabin.value.length,
              height: 80,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.blueGrey.shade200
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.bottomRight,
                    child: Text('Каюта ${cabin.key}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: cabin.value.map((suite) => GestureDetector(
                      onTap: () async {
                        if (selectionMode) {
                          _selectSeat(suite.id);
                        } else {
                          // await _openSeatInformation(seats![key]!.seat, passengers, state.availableSeats, state.tripPassengers);
                        }
                      },
                      onLongPress: () {
                        if (selectionMode) return;
                        _selectSeat(suite.id);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 60 - 40 - 2 * koef) / 4,
                            height: 40,
                            decoration: BoxDecoration(
                                color: suite.status == 0 ? Colors.red.shade100 : Colors.green.shade100,
                                borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: Container(
                                padding: EdgeInsets.only(right: 5),
                                alignment: Alignment.bottomRight,
                                child: Text(suite.placeNumber,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                                )
                            ),
                          ),
                          selectedIds.contains(suite.id) ? Container(
                            width: (MediaQuery.of(context).size.width - 60 - 40 - 2 * koef) / 4,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0x80FFFFFF),
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                            ),
                          ) : const SizedBox.shrink(),
                          selectedIds.contains(suite.id) ? Container(
                            margin: EdgeInsets.only(right: 2, bottom: 2),
                            child: Image.asset("assets/icons/select-icon.png",
                              width: 30, height: 30,
                            ),
                          ) : const SizedBox.shrink(),
                        ],
                      ),
                    )).toList(),
                  )
                ],
              ),
            );
          }
        ).toList(),
      ),
    );
  }

  @override
  void initState() {

    _db.getSeats().then((value) {
      setState(() {
        seats = value;
      });
      _sortSeatsBySuite();
      print("_sortSeatsBySuite $seatsByCabinNumber");
    });

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400)
    )..addListener(() {
      setState(() {});
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
      _animationController.forward();
    }
    setState(() {});
  }
  void _onSelectionDone() {
    selectedIds = [];
    selectionMode = false;
    _animationController.reverse();
    setState(() {});
  }
  void _onSelectionStart() {
    selectionMode = true;
    _animationController.forward();
  }

  Future<void> _seatStatusChange(int status) async {
    await _db.changeSeatStatus(status: status, ids: selectedIds);
    seats = await _db.getSeats();
    _onSelectionDone();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 - 18,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE1E1E1),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      alignment: Alignment.center,
                      child: const Text.rich(
                        TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.circle, color: Color(0xcc33b239), size: 22)),
                              WidgetSpan(child: SizedBox(width: 10,)),
                              WidgetSpan(child: Text("В работе", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54))),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 - 18,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE1E1E1),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      alignment: Alignment.center,
                      child: const Text.rich(
                        TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.circle, color: Color(0xccda1919), size: 22)),
                              WidgetSpan(child: SizedBox(width: 10,)),
                              WidgetSpan(child: Text("Выключены", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54))),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: InkWell(
                      onTap: () {
                        selectionMode ? _onSelectionDone() : _onSelectionStart();
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(selectionMode ? 'Отменить' : 'Выбрать',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                        )
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xE6FFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child:
                    _suitesItems()
                  // GridView.builder(
                  //     padding: const EdgeInsets.symmetric(horizontal: 0),
                  //     itemCount: seats.length,
                  //     itemBuilder: (context, index) {
                  //       final selected = selectedIds.contains(seats[index].id);
                  //       return GestureDetector(
                  //         onTap: () async {
                  //           if (selectionMode) {
                  //             _selectSeat(seats[index].id);
                  //           } else {
                  //             // await _openSeatInformation(seats![key]!.seat, passengers, state.availableSeats, state.tripPassengers);
                  //           }
                  //         },
                  //         onLongPress: () {
                  //           if (selectionMode) return;
                  //           _selectSeat(seats[index].id);
                  //         },
                  //         child: Stack(
                  //           alignment: Alignment.bottomRight,
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 Container(
                  //                   alignment: Alignment.center,
                  //                   decoration: BoxDecoration(
                  //                       color: seats[index].status == 0 ? const Color(0xcce80606) : const Color(0xcc33d33a),
                  //                       borderRadius: const BorderRadius.all(Radius.circular(6)),
                  //                       border: Border.all(width: 1, color: const Color(0xC0000000))
                  //                   ),
                  //                   child: Text("${seats[index].cabinNumber}${seats[index].placeNumber}",
                  //                     style: AppStyles.submainTitleTextStyle,
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             selected ? Container(
                  //               decoration: const BoxDecoration(
                  //                 color: Color(0x80FFFFFF),
                  //                 borderRadius: const BorderRadius.all(Radius.circular(6)),
                  //               ),
                  //             ) : const SizedBox.shrink(),
                  //             selected ? Container(
                  //               margin: EdgeInsets.only(right: 2, bottom: 2),
                  //               child: Image.asset("assets/icons/select-icon.png",
                  //                 width: 30, height: 30,
                  //               ),
                  //             ) : const SizedBox.shrink(),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4
                  //     )
                  // ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 65 - 65 * _animationController.value),
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
                              onTap: () async {
                                PopupManager.showLoadingPopup(context);
                                await _seatStatusChange(0);
                                await Future.delayed(const Duration(milliseconds: 300));
                                PopupManager.closePopup(context);
                              },
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
                              onTap: () async {
                                PopupManager.showLoadingPopup(context);
                                await _seatStatusChange(1);
                                await Future.delayed(const Duration(milliseconds: 300));
                                PopupManager.closePopup(context);
                              },
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
