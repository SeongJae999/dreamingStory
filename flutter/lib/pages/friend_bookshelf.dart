import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendBookshelfPage extends StatefulWidget {
  @override
  _FriendBookshelfPageState createState() => _FriendBookshelfPageState();
}

class _FriendBookshelfPageState extends State<FriendBookshelfPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구의 책장'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 기능 구현
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('shared_stories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final story = snapshot.data!.docs[index];
              return StoryCard(story: story);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // 내 동화 공유 기능 구현
        },
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  final QueryDocumentSnapshot story;

  const StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(story['authorImage']),
            ),
            title: Text(story['authorName']),
            subtitle: Text(story['createdAt'].toDate().toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(story['summary']),
              ],
            ),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(
                  story['likes']
                          .contains(FirebaseAuth.instance.currentUser?.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  // 좋아요 기능 구현
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // 댓글 기능 구현
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // 공유 기능 구현
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
