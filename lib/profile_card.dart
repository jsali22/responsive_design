import 'package:flutter/material.dart';

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
          constraints: const BoxConstraints(maxWidth: 800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Wide screen: use a Row layout
                return Row(  // wide layout
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildContent(),
                   ),
                  ],
                );
              } else {
                // Narrow screen: use a Column layout
                return Column( // narrow layout
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 20),
                  _buildContent(),
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

// function that returns a widget
Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.circle,
    ),
    child: Icon(Icons.person, size: 50, color: Colors.white),
  );
}

// Content widget for the profile
Widget _buildContent() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start, // left justifies
    children: [
      Text(
        'Pointdexter Dankworth',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // why is fontWeight.bold not working? It says undefined name.
        ),
      Text('Major: Computer Science'),
      Text('Favorite Class: CS220'),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {},
        child: Text('Log In'),
      ),
    ],
  );
}