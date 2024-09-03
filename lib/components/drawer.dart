import 'package:flutter/material.dart';
import 'package:thewall/components/my_List_tile.dart';

class MyDrawer extends StatelessWidget {
  void Function()? onProfileTap;
  void Function()? onLogout;

  MyDrawer({super.key, required this.onProfileTap, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Column(
              children: [
                DrawerHeader(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                )),
                // Home List Tile
                MyListTile(
                  icon: Icons.home,
                  text: "H O M E ",
                  onTap: () => Navigator.pop(context),
                ),
                // Profile List Tile
                MyListTile(
                    icon: Icons.person,
                    text: "P R O F I L E",
                    onTap: onProfileTap),
              ],
            ),
            // Logout List Tile
            MyListTile(icon: Icons.logout, text: "L O G O U T", onTap: onLogout)
          ],
        ),
      ),
    );
  }
}
