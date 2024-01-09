import 'package:flutter/material.dart';
import 'package:simple_notes/components/drawer_tile.dart';

class Drawer_Custom extends StatelessWidget {
  const Drawer_Custom({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(Icons.edit_document, size: 50),
                SizedBox(
                  height: 20,
                ),
                Text('Simple Notes'),
              ],
            ),
          ),
          DrawerTile(title: 'Notes', leading: Icons.home_rounded, onTap: () {}),
          DrawerTile(
              title: 'Settings',
              leading: Icons.settings_outlined,
              onTap: () {}),
        ],
      ),
    );
  }
}
