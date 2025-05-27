import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final String roomId= "9SJvewH8xF8GpRyX7NrH";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Group Chat",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ),),
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Consumer<UserAuthProvider>(
        builder: (BuildContext context, userauthProvider, Widget? child) {
          return userauthProvider.room !=null?StreamBuilder<List<types.Message>>(
            stream: FirebaseChatCore.instance.messages(userauthProvider.room!),
            initialData: [],
            builder: (context, snapshot) {
              final messages = snapshot.data??[];
              return Chat(
                showUserAvatars: true,
                showUserNames: true,
                messages: messages,
                onSendPressed: (p0) => FirebaseChatCore.instance.sendMessage(p0, roomId),
                user: types.User(id: FirebaseAuth.instance.currentUser!.uid),
              );
            },
          ):Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(color: Color.fromRGBO(64, 124, 226, 1),),
            ),
          );
        },
      ),
    );
  }

}
