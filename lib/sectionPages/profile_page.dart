import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text('Profile Page'),
      centerTitle: true,
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 140,
              height: 140,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber, // Background color of the circle
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white, // Icon color
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Add logic to handle avatar editing
            },
          ),
        ],
      ),
    );
  }
}
