import 'package:flutter/material.dart';
import 'package:pleyona_app/models/person_model.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/ui/screens/person/person_edit_info_screen.dart';

class PersonsChildrenWidget extends StatelessWidget {
  final Person child;
  final Person parent;
  final Function(Person) deleteChildFromParent;
  const PersonsChildrenWidget({
    required this.child,
    required this.parent,
    required this.deleteChildFromParent,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Future<void> openEditPersonScreen() async {
      Navigator.of(context).pushNamed(MainNavigationRouteNames.editPersonInfoScreen,
        arguments: EditPersonScreenArguments(person: child)
      );
    }
    Future<void> _deleteChildGuard() async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Внимание'),
              content: Text('${child.lastname} ${child.firstname} ${child.middlename} будет удален, как ребенок'
                  'в отношении ${parent.lastname} ${parent.firstname} ${parent.middlename}. Данные персоны удалены не будут.'),
              actions: [
                TextButton(
                  onPressed: () {
                    deleteChildFromParent(child);
                  },
                  child: const Text('Удалить',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500
                    ),
                  )
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Отмена',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500
                      ),
                    )
                ),
              ],
            );
          }
      );
    }
    return GestureDetector(
      onTap: openEditPersonScreen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.only(left: 15, right: 5),
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Colors.deepPurple.shade100
        ),
        child: Row(
          children: [
            Expanded(
              child: Text('${child.lastname} ${child.firstname} ${child.middlename}', style: TextStyle(fontSize: 16))
            ),
            GestureDetector(
              onTap: _deleteChildGuard,
              child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.red.shade100
                ),
                child: Text("Удалить", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
