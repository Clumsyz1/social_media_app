import 'package:flutter/material.dart';



class DeleteBtn extends StatelessWidget {
 final void Function()? onTap;

  const DeleteBtn({super.key ,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.cancel,color:Colors.grey,),
    );
  }
}