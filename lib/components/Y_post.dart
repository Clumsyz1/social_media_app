import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/comment_btn.dart';
import 'package:social_media_app/components/delete_btn.dart';
import 'package:social_media_app/components/edit_btn.dart';
import 'package:social_media_app/components/like_botton.dart';
import 'package:social_media_app/helper/helper_methords.dart';

class YPost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final List<String> likes;
  final String time;

  const YPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postID,
    required this.likes,
  });

  @override
  State<YPost> createState() => _YPostState();
}

class _YPostState extends State<YPost> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(user.email);
  }

  void togglelike() {
    setState(() {
      isliked = !isliked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User post').doc(widget.postID);

    if (isliked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User post")
        .doc(widget.postID)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": user.email,
      "Commenttime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Add Comment",
            style: TextStyle(color: Colors.yellowAccent)),
        content: TextField(
          controller: _commentTextController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Write a comment...",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellowAccent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellowAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Post",
                style: TextStyle(color: Colors.yellowAccent)),
          ),
        ],
      ),
    );
  }

  void deletepost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Delete Post",
            style: TextStyle(color: Colors.yellowAccent)),
        content: const Text("Are you sure you want to delete?",
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final commentdocs = await FirebaseFirestore.instance
                  .collection("User post")
                  .doc(widget.postID)
                  .collection("Comments")
                  .get();
              for (var doc in commentdocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User post")
                    .doc(widget.postID)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }
              FirebaseFirestore.instance
                  .collection("User post")
                  .doc(widget.postID)
                  .delete();
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void showEditPostDialog() {
    final TextEditingController _editController =
        TextEditingController(text: widget.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Edit Post",
            style: TextStyle(color: Colors.yellowAccent)),
        content: TextField(
          controller: _editController,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Edit your post...",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellowAccent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellowAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              updatePost(_editController.text);
              Navigator.pop(context);
            },
            child: const Text("Save",
                style: TextStyle(color: Colors.yellowAccent)),
          ),
        ],
      ),
    );
  }

  void updatePost(String newText) {
    FirebaseFirestore.instance
        .collection("User post")
        .doc(widget.postID)
        .update({"Message": newText});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // โซนแสดงข้อความโพสต์ + ชื่อ + เวลา
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(widget.user,
                        style: TextStyle(color: Colors.grey[500])),
                    const SizedBox(height: 4),
                    Text(widget.time,
                        style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
              // ปุ่มลบ + แก้ไข สำหรับเจ้าของโพสต์
              if (widget.user == user.email)
                Row(
                  children: [
                    DeleteBtn(onTap: deletepost),
                    const SizedBox(width: 15),
                    EditBtn(onTap: showEditPostDialog),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Section Like & Comment
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User post")
                .doc(widget.postID)
                .collection("Comments")
                .snapshots(),
            builder: (context, snapshot) {
              int commentCount =
                  snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      LikeBotton(isliked: isliked, onTap: togglelike),
                      Text(widget.likes.length.toString(),
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      CommentBtn(onTap: showCommentDialog),
                      const SizedBox(height: 5),
                      Text(commentCount.toString(),
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Section แสดงคอมเมนต์
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User post")
                .doc(widget.postID)
                .collection("Comments")
                .orderBy("Commenttime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("No comments yet.",
                      style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentData["CommentedBy"] ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.yellow[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            commentData["CommentText"] ?? "",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatData(commentData["Commenttime"]),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
