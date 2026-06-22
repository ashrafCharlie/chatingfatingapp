import 'package:chatingfatingapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _firestore = FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String id = 'charScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
 
  final _auth = FirebaseAuth.instance;
  User? loggedinUser;
  String testMag = '';

  void massegesStrem() async {
    await for (var snapshot in _firestore.collection('message').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();

              Navigator.pop(context);
              // Implement logout functionality
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: StreamMessages(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      onChanged: (value) {
                        //Do something with the user input.
                        testMag = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //Implement send functionality.
                      if (loggedinUser == null) {
                        print("User not logged in ");
                        return;
                      }
                      if (testMag.trim().isEmpty) {
                        print("msg is empty");
                        return;
                      }

                      try {
                        _firestore.collection('message').add({
                          'text': testMag,
                          'sender': loggedinUser!.email,
                        });
                      } catch (e) {
                        print(e);
                      }
                      testMag = '';
                      msgController.clear();
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class StreamMessages extends StatelessWidget {
  const StreamMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
                stream: _firestore.collection('message').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final messageList = message.data() as Map<String, dynamic>;
                    final messageText = messageList['text'];
                    final messageSender = messageList['sender'];
                    final messageWidget = MessageBubble(text: messageText, sender: messageSender);
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 12.0,
                    ),
                    children: messageWidgets,
                  );
                },
              ) ;
  }
}








class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender});
  final String  text;
  final String  sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
              Text(sender, style: TextStyle(
                fontSize: 10.0
            ),),
          SizedBox(height: 5.0,),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: const Color.fromARGB(255, 50, 145, 204),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                    text,
                    style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7), fontSize: 15.0),
                  ),
             
            
            ),
          ),
        ],
      ),
    );
  }
}
