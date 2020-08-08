import 'package:flutter/material.dart';
import 'package:hard_app/helper/constants.dart';
import 'package:hard_app/services/database.dart';
import 'package:hard_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.data.document.length,
            itemBuilder: (context, index) {
              return MessageTile(snapshot.data.document[index].data["message"]);
            });
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "" ;
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).than((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        color: Color(0x54FFFFFFF),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                                    controller: messageController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: "Message....",
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        border: InputBorder.none))),
                            GestureDetector(
                              onTap: () {
                                sendMessage();
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        const Color(0x36FFFFFF),
                                        const Color(0x0FFFFFFF),
                                      ]),
                                      borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.send)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message,style: simpleTextStyle(),),
    );
  }
}
