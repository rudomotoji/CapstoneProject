// import 'package:capstone_home_doctor/commons/widget/full_image_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:intl/intl.dart';

// class ChatScreen extends StatefulWidget {
//   final String receiveID;
//   final String receiveName;
//   ChatScreen({this.receiveID, this.receiveName});

//   @override
//   _ChatScreenState createState() =>
//       _ChatScreenState(receiveID: receiveID, receiveName: receiveName);
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final String receiveID;
//   final String receiveName;
//   _ChatScreenState({this.receiveID, this.receiveName});

//   final TextEditingController textEditingController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//   // FocusNode focusNode = FocusNode();
//   bool isDisplaySticker;
//   bool isLoading;

//   SharedPreferences prefs;
//   String chatID;
//   String id;
//   var listMessage;

//   @override
//   void initState() {
//     super.initState();
//     // focusNode.addListener(onFocusChange);

//     isDisplaySticker = false;
//     isLoading = false;

//     setState(() {
//       chatID = "";
//     });

//     readLocal();
//   }

//   readLocal() async {
//     prefs = await SharedPreferences.getInstance();
//     id = prefs.getString('id') ?? "";

//     if (id.hashCode <= receiveID.hashCode) {
//       setState(() {
//         chatID = '$id-$receiveID';
//       });
//     } else {
//       setState(() {
//         chatID = '$receiveID-$id';
//       });
//     }

//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(id)
//         .update({"chattingWith": receiveID});
//   }

//   // onFocusChange() {
//   //   if (focusNode.hasFocus) {
//   //     setState(() {
//   //       isDisplaySticker = false;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: CircleAvatar(
//               backgroundColor: Colors.black,
//             ),
//           ),
//         ],
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         title: Text(
//           receiveName,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: WillPopScope(
//         child: Stack(children: [
//           Column(
//             children: [
//               createBoxMessage(),
//               createInput(),
//             ],
//           ),
//           // createLoading(),
//         ]),
//         onWillPop: onPressBack,
//       ),
//     );
//   }

//   createLoading() {
//     return Positioned(
//       child: isLoading
//           ? CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 Colors.lightBlueAccent,
//               ),
//             )
//           : Container(),
//     );
//   }

//   Future<bool> onPressBack() {
//     if (isDisplaySticker) {
//       setState(() {
//         isDisplaySticker = false;
//       });
//     } else {
//       Navigator.pop(context);
//     }
//     return Future.value(false);
//   }

//   onSendMess(String mess, int type) {
//     if (mess != null) {
//       textEditingController.clear();
//       var docRef = FirebaseFirestore.instance
//           .collection('messages')
//           .doc(chatID)
//           .collection(chatID)
//           .doc(DateTime.now().microsecondsSinceEpoch.toString());

//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         await transaction.set(docRef, {
//           'idFrom': id,
//           'idTo': receiveID,
//           'timeStamp': DateTime.now().microsecondsSinceEpoch.toString(),
//           'content': mess,
//           'type': type,
//         });
//       });

//       scrollController.animateTo(0.0,
//           duration: Duration(microseconds: 300), curve: Curves.easeOut);
//     } else {
//       print('empty mess can not be send');
//     }
//   }

//   createBoxMessage() {
//     return Flexible(
//       child: chatID == ""
//           ? Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Colors.lightBlueAccent,
//                 ),
//               ),
//             )
//           : StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('messages')
//                   .doc(chatID)
//                   .collection(chatID)
//                   .orderBy('timeStamp', descending: true)
//                   .limit(20)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.lightBlueAccent,
//                       ),
//                     ),
//                   );
//                 } else {
//                   listMessage = snapshot.data.docs;
//                   return ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     itemBuilder: (context, index) =>
//                         createItem(index, snapshot.data.docs[index]),
//                     itemCount: snapshot.data.docs.length,
//                     reverse: true,
//                     controller: scrollController,
//                   );
//                 }
//               },
//             ),
//     );
//   }

//   createItem(int index, DocumentSnapshot document) {
//     if (document["idFrom"] == id) {
//       return Row(
//         children: [
//           document["type"] == 0 //text
//               ? Container(
//                   child: Text(
//                     document["content"],
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//                   width: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.lightBlueAccent,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   margin: EdgeInsets.only(
//                       bottom: isLastMessRight(index) ? 20 : 10, right: 10),
//                 )
//               : Container(
//                   //image
//                   child: FlatButton(
//                     child: Material(
//                       child: CachedNetworkImage(
//                         placeholder: (context, url) => Container(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.lightBlueAccent,
//                             ),
//                           ),
//                           width: 200,
//                           height: 200,
//                           padding: EdgeInsets.all(70),
//                           decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(8),
//                             ),
//                           ),
//                         ),
//                         errorWidget: (conntext, url, error) => Material(
//                           child: Image.asset(
//                             "asset/images/img_not_found.jpg",
//                             width: 200,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(8),
//                           ),
//                           clipBehavior: Clip.hardEdge,
//                         ),
//                         imageUrl: document["content"],
//                         width: 200,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       clipBehavior: Clip.hardEdge,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               FullPhoto(url: document["content"]),
//                         ),
//                       );
//                     },
//                   ),
//                   margin: EdgeInsets.only(
//                       bottom: isLastMessRight(index) ? 20 : 10, right: 10),
//                 )
//         ],
//         mainAxisAlignment: MainAxisAlignment.end,
//       );
//     } else {
//       //receive mess
//       return Container(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 isLastMessLeft(index)
//                     ? Material(
//                         child: CachedNetworkImage(
//                           placeholder: (context, url) => Container(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.lightBlueAccent,
//                               ),
//                             ),
//                             width: 35,
//                             height: 35,
//                             padding: EdgeInsets.all(10),
//                           ),
//                           imageUrl:
//                               'https://image.cnbcfm.com/api/v1/image/105992231-1561667465295gettyimages-521697453.jpeg?v=1561667497&w=1600&h=900',
//                           width: 35,
//                           height: 35,
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(18),
//                         ),
//                         clipBehavior: Clip.hardEdge,
//                       )
//                     : Container(width: 35),
//                 document["type"] == 0 //text
//                     ? Container(
//                         child: Text(
//                           document["content"],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//                         width: 200,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         margin: EdgeInsets.only(left: 10))
//                     : Container(
//                         //image
//                         child: FlatButton(
//                           child: Material(
//                             child: CachedNetworkImage(
//                               placeholder: (context, url) => Container(
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.lightBlueAccent,
//                                   ),
//                                 ),
//                                 width: 200,
//                                 height: 200,
//                                 padding: EdgeInsets.all(70),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                               errorWidget: (conntext, url, error) => Material(
//                                 child: Image.asset(
//                                   "asset/images/img_not_found.jpg",
//                                   width: 200,
//                                   height: 200,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(8),
//                                 ),
//                                 clipBehavior: Clip.hardEdge,
//                               ),
//                               imageUrl: document["content"],
//                               width: 200,
//                               height: 200,
//                               fit: BoxFit.cover,
//                             ),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(8),
//                             ),
//                             clipBehavior: Clip.hardEdge,
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     FullPhoto(url: document["content"]),
//                               ),
//                             );
//                           },
//                         ),
//                         margin: EdgeInsets.only(left: 10),
//                       )
//               ],
//             ),
//             isLastMessLeft(index)
//                 ? Container(
//                     child: Text(
//                       DateFormat('dd mmmm yyyy - kk:mm').format(
//                         DateTime.fromMillisecondsSinceEpoch(
//                           int.parse(document['timeStamp']),
//                         ),
//                       ),
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     margin: EdgeInsets.only(left: 50, top: 50, bottom: 5),
//                   )
//                 : Container(),
//           ],
//           crossAxisAlignment: CrossAxisAlignment.start,
//         ),
//         margin: EdgeInsets.only(bottom: 10),
//       );
//     }
//   }

//   isLastMessRight(int index) {
//     if ((index > 0 &&
//             listMessage != null &&
//             listMessage[index - 1]["idFrom"] != id) ||
//         index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   isLastMessLeft(int index) {
//     if ((index > 0 &&
//             listMessage != null &&
//             listMessage[index - 1]["idFrom"] == id) ||
//         index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   createInput() {
//     return Container(
//       child: Row(
//         children: [
//           Material(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 1),
//               child: IconButton(
//                 icon: Icon(Icons.image),
//                 color: Colors.lightBlueAccent,
//                 onPressed: () => print("Click"),
//               ),
//             ),
//           ),
//           Flexible(
//             child: Container(
//               child: TextField(
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                 ),
//                 controller: textEditingController,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'write here',
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Material(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 8),
//               child: IconButton(
//                 icon: Icon(Icons.send),
//                 color: Colors.lightBlueAccent,
//                 onPressed: () => onSendMess(textEditingController.text, 0),
//               ),
//             ),
//             color: Colors.white,
//           ),
//         ],
//       ),
//       width: double.infinity,
//       height: 50,
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Colors.grey,
//             width: 0.5,
//           ),
//         ),
//         color: Colors.white,
//       ),
//     );
//   }
// }
