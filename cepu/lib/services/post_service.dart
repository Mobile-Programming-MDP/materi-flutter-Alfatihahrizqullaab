import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cepu/models/post.dart'; // Sesuaikan dengan nama aplikasimu

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _postsCollection = _database.collection(
    'posts',
  );

  static Future<void> addPost(Post post) async {
    Map<String, dynamic> newPost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'user_id': post.user_id,
      'user_fullname': post.user_fullname,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _postsCollection.add(newPost);
  }

  static Future<void> updatePost(Post post) async {
    Map<String, dynamic> updatedPost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'user_id': post.user_id,
      'user_fullname': post.user_fullname,
      'created_at': post.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _postsCollection.doc(post.id).update(updatedPost);
  }

  static Future<void> deletePost(Post post) async {
    await _postsCollection.doc(post.id).delete();
  }

  static Future<QuerySnapshot> retrievePosts() {
    return _postsCollection.get();
  }

  static Stream<List<Post>> getPostList() {
    return _postsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          image: data['image'],
          description: data['description'],
          category: data['category'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          user_id: data['user_id'],
          user_fullname: data['user_fullname'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }
}