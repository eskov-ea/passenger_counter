import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableWrapperWidget extends StatelessWidget {
  final Widget child;
  final String idKey;
  final String groupTag;
  final Function(BuildContext) callback;

  const SlidableWrapperWidget({
    required this.child,
    required this.groupTag,
    required this.callback,
    required this.idKey,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(idKey),
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: callback,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: const Color(0xFFFFFFFF),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6)
            ),
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: child
    );
  }
}
