import 'package:flutter/material.dart';
import '../../../theme.dart';


class PassengerBagageInfoWidget extends StatefulWidget {
  const PassengerBagageInfoWidget({
    required this.resultCallback,
    super.key
  });

  final Function(List<TextEditingController>) resultCallback;

  @override
  State<PassengerBagageInfoWidget> createState() => _PassengerBagageInfoWidgetState();
}

class _PassengerBagageInfoWidgetState extends State<PassengerBagageInfoWidget> {

  final TextEditingController _bagageController = TextEditingController();
  final List<TextEditingController> _textControllers = [];
  final FocusNode _bagageFocus = FocusNode();
  final List<FocusNode> _focusNodes = [];
  bool forceDelete = false;

  void _addNewBagageInput() {
    _textControllers.add(TextEditingController());
    _focusNodes.add(FocusNode());
    setState(() {});
  }

  void _deleteNewBagageInput(int index) async {
    if(_textControllers[index].text.trim() != "") {
      await _deleteBagageInputGuardAlert();
      if (!forceDelete) return;
    }
    _textControllers.removeAt(index);
    _focusNodes.removeAt(index);
    setState(() {
      forceDelete = false;
    });
  }

  Future<void> _deleteBagageInputGuardAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы хотите отменить добавление багажа?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('В поле вес багажа вы ввели значение.'),
                Text('При удалении этого поля значение будет потеряно.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                forceDelete = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Отменить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _textControllers.add(_bagageController);
    _focusNodes.add(_bagageFocus);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ..._bagageInputBlock(),
          Material(
            color: AppColors.transparent,
            child: Ink(
              width: MediaQuery.of(context).size.width - 20,
              decoration: const BoxDecoration(
                  color: Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )
              ),
              child: InkWell(
                  splashColor: AppColors.cardColor5,
                  customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  onTap: () {
                    _addNewBagageInput();
                    setState(() {});
                  },
                  child: Text("Добавить багаж", textAlign: TextAlign.center,)
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bagageInputBlock() {
    final List<Widget> list = [];
    for (int i=0; i < _textControllers.length; ++i) {
      list.add(
        _bagageInputItem(controller: _textControllers[i], focusNode: _focusNodes[i], label: "Вес багажа ${i+1}", index: i)
      );
    }
    return list;
  }

  Widget _bagageInputItem({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required int index
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.disabled,
              keyboardType: TextInputType.number,
              cursorHeight: 25,
              onEditingComplete: (){
                widget.resultCallback(_textControllers);
                focusNode.unfocus();
              },
              onTapOutside: (event) {
                if(focusNode.hasFocus) {
                  focusNode.unfocus();
                }
              },
              cursorColor: Color(0xFF000000),
              style: const TextStyle(fontSize: 24, color: Color(0xFF000000), decoration: TextDecoration.none, height: 1),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
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
                labelText: label,
                labelStyle: TextStyle(fontSize: 22, color: AppColors.backgroundMain2),
                focusColor: AppColors.accent5,
              ),
            ),
          ),
          index > 0 ? Ink(
            width: 50,
            decoration: const BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
            ),
            child: InkWell(
                splashColor: AppColors.cardColor1,
                customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                onTap: () {
                  _deleteNewBagageInput(index);
                  setState(() {});
                },
                child: const Icon(Icons.close)
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
