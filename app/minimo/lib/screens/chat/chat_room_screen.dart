import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {

  const ChatRoomScreen({

    super.key
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Expanded(
            child: Placeholder(),
          ),

        ],
      ),
    );
  }
}
