import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onsignOut;

  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onsignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
          //home list
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),

          //profile
          MyListTile(
            icon: Icons.person,
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),

          //logout list
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            onTap: onsignOut,
          ),

          //setting maybe can do
        ],
      ),
    );
  }
}
