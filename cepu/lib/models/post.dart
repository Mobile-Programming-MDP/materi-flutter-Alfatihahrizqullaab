  import 'package:cloud_firestore/cloud_firestore.dart';

  class Post{
    String? id;
    String? image;
    String? description;
    String? category;
    String? latitude;
    String? longitude;
    Timestamp? createdAt;
    Timestamp? updatedAt;
    String? user_id;
    String? user_fullname;


    Post({
      this.id,
      this.image,
      this.description,
      this.category,
      this.latitude,
      this.longitude,
      this.user_id,
      this.user_fullname,
      this.createdAt,
      this.updatedAt
    });

    factory Post.fromDocument(DocumentSnapshot doc){
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
        createdAt: data['created_at'] as Timestamp,
        updatedAt: data['updated_at'] as Timestamp,
      ); 
    }

    Map<String, dynamic> toDocument(){
      return{
        'image': image,
        'description': description,
        'category': category,
        'latitude': latitude,
        'longitude': longitude,
        'user_id': user_id,
        'user_fullname': user_fullname,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  }
}