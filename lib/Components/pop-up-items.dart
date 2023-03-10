import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  final Function(int) onSelected;

  const PopUpMenu({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Theme.of(context).primaryColor),
      child: PopupMenuButton<int>(
        icon: Icon(
          Icons.menu_rounded,
          color: Color(0xFFE4EBF8),
        ),
        color: Color(0xFFE4EBF8),
        itemBuilder: (context) => [
          PopupMenuItem<int>(
            value: 0,
            child: Text('Account'),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: Text('App version'),
          ),
          PopupMenuDivider(),
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.logout, color: Color(0xFFFD5066)),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFD5066),
                  ),
                )
              ],
            ),
          ),
        ],
        onSelected: onSelected,
      ),
    );
  }
}
