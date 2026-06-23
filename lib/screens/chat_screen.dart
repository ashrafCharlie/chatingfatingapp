import 'package:chatingfatingapp/constants.dart';
import 'package:chatingfatingapp/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _firestore = FirebaseFirestore.instance;
User? loggedinUser;
class ChatScreen extends StatefulWidget {
  static const String id = 'charScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
 
  final _auth = FirebaseAuth.instance;

  String testMag = '';


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
            onPressed: ()  {
               _auth.signOut();
            if(!mounted)return;
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
                          'timestamp' : FieldValue.serverTimestamp(),
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
                stream: _firestore.collection('message').orderBy('timestamp',descending: true).snapshots(),
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
                    final currentUser = loggedinUser!.email ;

                    final messageWidget = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      isMe: messageSender == currentUser,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse: true,
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
  MessageBubble({required this.text, required this.sender, required this.isMe});
  final String  text;
  final String  sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
              Text(sender, style: TextStyle(
                fontSize: 10.0
            ),),
          SizedBox(height: 5.0,),
          Material(
            borderRadius:isMe?BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
            ):BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                    text,
                    style: TextStyle(
                        color:isMe? Colors.white: Colors.black54,
                        fontSize: 15.0),
                  ),
             
            
            ),
          ),
        ],
      ),
    );
  }
}
