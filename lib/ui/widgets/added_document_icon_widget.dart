import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';

class AddedDocumentIconWidget extends StatelessWidget {
  const AddedDocumentIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 70,
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Image.asset("assets/icons/doc_icon.png", width: 50, height: 60,),
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/doc_icon.png")
                )
              ),
            ),
            Positioned(
              top: -1,
              right: -2,
              child: Ink(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    color: AppColors.errorMain,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: (){print("DELETE DOC");},
                  splashColor: Color(0x80FF0000),
                  child: Icon(Icons.close_outlined, color: AppColors.textMain, size: 18,),
                ),
              ),
            ),
            Ink(
              // margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Color(0x40030303),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: InkWell(
                onTap: (){},
                splashColor: AppColors.secondary4,
                child: Icon(Icons.zoom_in,
                  size: 35,
                  fill: 1,
                  color: AppColors.textMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
