import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'add_post.dart';
import 'comment_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  var userId = FirebaseAuth.instance.currentUser!.uid;

  Widget _buildListItem(SocialPost post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        post.userName.characters.first,
                        style: const TextStyle(),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      post.userName,
                      style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "${post.date.toDate().day}, ",style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "${DateFormat.MMMM().format(post.date.toDate())}, ",style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "${post.date.toDate().year}",style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Text(post.postText,style: const TextStyle(fontSize: 20),),
              SizedBox(
                height: post.photo != "" ? 250 : 05,
                width: double.infinity,
                child:
                    post.photo != "" ? CachedNetworkImage(imageUrl: post.photo,fit: BoxFit.contain,) : Container(),
              ),
               Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () async {
                if(post.likeList.contains(userId)){
                 List likes = post.likeList;
                 likes.remove(userId); 
                 await FirebaseFirestore.instance.collection("Social Posts").doc(post.postId).update({"likeList":likes});
                }else{
                  List likes = post.likeList;
                  likes.add(userId);
                  await FirebaseFirestore.instance.collection("Social Posts").doc(post.postId).update({"likeList":likes});
                }
              },
              icon: post.likeList.contains(userId)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
            ),
            Text((post.likeList.length).toString()),
          ],
        ),
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (c)=> CommentScreen(postId: post.postId,)));
          },
          child: const Row(
            children: [
              Icon(Icons.comment),
              Text("Comment")
            ],
          ),
        )
        ]),    
    ]))));
  }

  Widget _buildList(List<DocumentSnapshot> docs, String userId) {
  if (docs.isEmpty) {
    return const Center(child: Text("No Community Post Yet!"));
  } else {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        Map<dynamic, dynamic> data = doc.data() as Map<dynamic, dynamic>;
        bool isLiked = data["likes"] == true;
        final post = SocialPost.fromSnapshot(doc,isLiked);
        return _buildListItem(post);
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
    return  Stack(
          children: [
      // Background with fixed gradient
      Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment(0, -1),
      end: Alignment(0, 1),
      colors: <Color>[
        Color(0xff033f50),
        Color(0xc9155465),
        Color(0xd0135163),
        Color(0x6c35778a),
        Color(0x6d357789),
        Color(0x45204853),
        Color(0x45428699),
        Color(0x005aa0b4),
      ],
      stops: <double>[0, 0.143, 0.286, 0.429, 0.571, 0.714, 0.857, 1],
      ),
      ),
      ),
            SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                  const Row(
                    children: [
                      Text(
                        "Community",
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPost()));
                      },
                      child: const Row(
                        children: [
                          Text(
                            "Share Your Story",
                            style: TextStyle(),
                          ),
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                  ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                    .collection("Social Posts")
                    .snapshots(),
                              builder: ((context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  print(snapshot.data);
                  return SizedBox(
                      height:
                          MediaQuery.of(context).size.height / 1.231212121212121,
                      child: _buildList(snapshot.data!.docs, userId));
                              }))
                            ]  ),
                )
      )]
                  )
    ;
  }
}

class SocialPost {
  final String userName;
  final Timestamp date;
  final String photo;
  final String postText;
  final int likes;
  final List likeList;
  final String postId;
  final bool liked;
  SocialPost(
      {required this.userName,
      required this.date,
      required this.liked,
      required this.postText,
      required this.photo,
      required this.likes,
      required this.likeList,
      required this.postId});
  factory SocialPost.fromSnapshot(DocumentSnapshot snapshot, bool isLiked) {
  final map = snapshot.data() as Map<String, dynamic>;
  final postId = snapshot.id;
  return SocialPost(
    userName: map["name"],
    date: map["date"],
    liked: isLiked,
    likes: map["likes"],
    postText: map["postText"],
    photo: map["photoLink"],
    postId: postId,
    likeList: map["likeList"]
  );
}
}