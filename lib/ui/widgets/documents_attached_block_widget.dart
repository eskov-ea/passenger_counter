import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'added_document_icon_widget.dart';



class AttachedDocumentsContainer extends StatefulWidget {
  const AttachedDocumentsContainer({super.key});

  @override
  State<AttachedDocumentsContainer> createState() => _AttachedDocumentsContainerState();
}

class _AttachedDocumentsContainerState extends State<AttachedDocumentsContainer> {

  void _openAddingDocOptionDialog() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12)
                ),
                color: AppColors.textMain
            ),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text("Добавьте страницы паспорта пассажира с основной информацией и пропиской",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.textFaded),
                      ),
                    )
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain4),
                      overlayColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain5),
                      shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      )),
                    ),
                    child: Text("Открыть камеру",
                      style: TextStyle(fontSize: 24, color: AppColors.textMain),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain4),
                      overlayColor: MaterialStateProperty.all<Color>(AppColors.backgroundMain5),
                      shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      )),
                    ),
                    child: Text("Выбрать из галереи",
                      style: TextStyle(fontSize: 24, color: AppColors.textMain),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75 - 20,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 1, color: AppColors.backgroundMain2),
              color: AppColors.textMain,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    AddedDocumentIconWidget(),
                    AddedDocumentIconWidget(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.05
          ),
          Ink(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 1, color: AppColors.backgroundMain2),
              color: AppColors.textMain,
            ),
            child: InkWell(
              onTap: _openAddingDocOptionDialog,
              splashColor: AppColors.backgroundMain5,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Icon(
                Icons.add,
                color: AppColors.backgroundMain2,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
