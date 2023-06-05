import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_chat_app/widgets/chat/chat_input_widget.dart';
import 'package:project_chat_app/widgets/chat/messages_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          DropdownButton(
            underline:  Container(),
            icon: Icon(
              Icons.more_vert,
              color: Colors.brown,
            ),
            items: const [
              DropdownMenuItem(
                value: "logout",
                  child: Row(
                    children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8,),
                    Text("logout")
                  ]
                  )
              )
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier == "logout"){
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: MessageWidget()),
            ChatInputWidget(),
          ],
        ),
      ),
    );
  }
}
