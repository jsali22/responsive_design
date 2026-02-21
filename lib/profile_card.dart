import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Responsive design'),
    ),
      body: Center(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 800), // prevents the card from growing too wide on large screens
          child: LayoutBuilder( // LayoutBuilder gives the available width and height of the parent widget
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Wide screen: use a Row layout
                return Row(  
                  children: [
                    _buildAvatar(), // avatar on the left
                    const SizedBox(width: 20),
                    Expanded( // ensures text/button take up remaining space
                      child: _buildContent(context), // content on the right
                   ),
                  ],
                );
              } else { // <= 600
                // Narrow screen: use a Column layout
                return Column( 
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(), // avatar on top
                  const SizedBox(height: 20),
                  _buildContent(context), // content below
                ],
              );
            }
            },
          ),
        ),
        ),
    );
  }
}

// function that returns a widget (easy to reuse and keeps build method clean)
Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.person, size: 50, color: Colors.white),
  );
}

// Content widget for the profile (contains namre, major, favorite class, and login button)
Widget _buildContent(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start, // left justifies
    children: [
      Text(
        'Pointdexter Dankworth',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
        ),
      Text('Major: Computer Science'),
      Text('Favorite Class: CS450'),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          // Navigate to login screen
          Navigator.of(context).push( // pushing a new screen onto the stack (LoginScreen is created and becomes the active screen. ProfileCard is underneath)
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text('Log In'),
      ),
    ],
  );
}