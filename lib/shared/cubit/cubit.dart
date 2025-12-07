import 'dart:io';
import 'package:app_social/shared/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../models/comment_model.dart';
import '../../models/message_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/login/login_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import '../component/constants.dart';
import '../network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    if (uId == null || uId.isEmpty) {
      //print('Error: uId is null or empty');
      emit(SocialGetUserErrorState("User ID is missing"));
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          if (!value.exists) {
            // print("Error: User document does not exist");
            emit(SocialGetUserErrorState("User data is missing in Firestore"));
            return;
          }
          userModel = UserModel.fromJson(value.data()!);
          emit(SocialGetUserSuccessState());
        })
        .catchError((error) {
          print("Firestore Error: $error");
          emit(SocialGetUserErrorState(error.toString()));
        });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
    if(index ==1)
     getAllUsers();
  }

  List<String> titles = ['Home', 'Chats', 'New Post', 'Users', 'Settings'];

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImagePickerErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialCoverImagePickerErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState()); // دي ال هلعب عليها
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
          value.ref
              .getDownloadURL()
              .then((value) {
                print(value);
                updateUser(name: name, phone: phone, bio: bio, image: value);
                //   شلتها عشان لو سبتها هيعمل ايمت منغير م يعمل ابديت emit(SocialUploadProfileImageSuccessState());
              })
              .catchError((error) {
                emit(SocialUploadProfileImageErrorState());
              });
        })
        .catchError((error) {
          emit(SocialUploadProfileImageErrorState());
        });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState()); // دي ال هلعب عليها
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
          value.ref
              .getDownloadURL()
              .then((value) {
                print(value);
                updateUser(name: name, phone: phone, bio: bio, cover: value);
                // مش هعمل emit عشان مغيرش فيمه اول emit و عشان هيعمل emit جوا ال update user
              })
              .catchError((error) {
                emit(SocialUploadCoverImageErrorState());
              });
        })
        .catchError((error) {
          emit(SocialUploadCoverImageErrorState());
        });
  }

  // void updateUserImages(
  //     {required String name, required String phone, required String bio}) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (profileImage != null)
  //     uploadProfileImage();
  //   else if (coverImage != null)
  //     uploadCoverImage();
  //   else if(profileImage != null && coverImage != null)
  //     uploadCoverImage();
  //   else {
  //   updateUser(name: name, phone: phone, bio: bio);
  //   }
  // }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  })
  {
    UserModel updateModel = UserModel(
      name: name,
      phone: phone,
      email: userModel?.email,
      image: image ?? userModel?.image,
      cover: cover ?? userModel?.cover,
      isEmailVerified: false,
      bio: bio,
      uId: userModel?.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(updateModel.toMap())
        .then((value) {
          getUserData();
        })
        .catchError((error) {
          emit(SocialUserUpdateErrorState(error.toString()));
        });
  }


  ////////////////////// Create Post //////////////////////////
  PostModel? postModel;
  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  })
  {
    emit(SocialCreatePostLoadingState());
    postModel = PostModel(
      name: userModel!.name,
      uId: uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
        })
        .catchError((error) {
          emit(SocialCreatePostErrorState(error.toString()));
        });
  }


  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(postImage);
      emit(SocialPostImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialPostImagePickerErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void uploadPostImage({required String dateTime, required String text}) {
    if (postImage == null) {
      emit(SocialCreatePostErrorState("No image selected!"));
      return;
    }
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref
          .getDownloadURL()
          .then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value);
        print(value);
      })
          .catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = []; // to store comment counts  likes[0] → Number of likes for posts[0]
  List<int> commentsCount = []; // to store comment counts

  void getPosts() async {
    emit(SocialGetPostsLoadingState());

    posts.clear();
    postsId.clear();
    likes.clear();
    commentsCount.clear(); // Clear old data

    try {
      QuerySnapshot postSnapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      if (postSnapshot.docs.isEmpty) {
        emit(SocialGetPostsSuccessState());
        return;
      }

      List<Future<void>> futures =
          []; //This list stores multiple Future<void> objects, each performing an asynchronous task

      for (var element in postSnapshot.docs) {
        String postId = element.id;
        Future<void> future = Future.wait([
          element.reference
              .collection('likes')
              .get()
              .then((value) {
                likes.add(value.docs.length);
              })
              .catchError((error) {
                print("❌ Error fetching likes for post $postId: $error");
                likes.add(0);
              }),

          element.reference
              .collection('comments')
              .get()
              .then((value) {
                commentsCount.add(value.docs.length); //  Count comments
              })
              .catchError((error) {
                print("❌ Error fetching comments for post $postId: $error");
                commentsCount.add(0);
              }),
        ]).then((_) {
          //This means that the function inside .then() does not need the return value
          // _ means "I don’t care about the result".
          PostModel post = PostModel.fromJson(
            element.data() as Map<String, dynamic>,
          );
          post.postId = postId;
          posts.add(post);
          postsId.add(postId);
        });

        futures.add(future);
      }

      await Future.wait(
        futures,
      ); //This waits for all the asynchronous tasks (likes & comments fetching) before proceeding.

      print("✅ Posts Loaded Successfully: ${posts.length} Posts");
      emit(SocialGetPostsSuccessState());
    } catch (error) {
      print("❌ Error fetching posts: $error");
      emit(SocialGetPostsErrorState(error.toString()));
    }
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true})
        .then((value) {
          emit(SocialLikePostsSuccessState());
        })
        .catchError((error) {
          emit(SocialLikePostsErrorState(error.toString()));
        });
  }

  CommentModel? commentModel;
  void commentOnPost(String postId, String commentText) {
    commentModel = CommentModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.image,
      comment: commentText,
      dateTime: DateTime.now().toString(),
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toMap()) // ✅ Store commentModel as JSON
        .then((value) {
        getComments(postId);
      emit(SocialCommentOnPostsSuccessState());
        })
        .catchError((error) {
          emit(SocialCommentOnPostsErrorState(error.toString()));
        });
  }

  List<CommentModel> comments = [];
  Map<String, List<CommentModel>> postComments = {};

  void getComments(String postId) async {
    emit(SocialGetAllCommentsLoadingState());

    try {
      QuerySnapshot commentSnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('comments')
              .orderBy(
                'dateTime',
                descending: true,
              ) // Get latest comments first
              .get();

      // Convert Firebase documents to CommentModel list
      List<CommentModel> fetchedComments =
          commentSnapshot.docs
              .map(
                (doc) =>
                    CommentModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      postComments[postId] = fetchedComments; // ✅ Store comments per post

      emit(SocialGetAllCommentsSuccessState());
    } catch (error) {
      emit(SocialGetAllCommentsErrorState(error.toString()));
    }
  }

  List<UserModel> users = [];
  void getAllUsers() {
    users.clear();
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print('element : ${element.data()}');
        print('userModel ${userModel?.uId}');
        print('element ${element.data()['uId']}');
        if(element.data()['uId'] != userModel!.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetAllUsersSuccessState());
    })
        .catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  //////////////////////// messages ////////////////////////////
  MessageModel? messageModel;
  void sendMessage({
    required String? receiverId,
    required String dateTime,
    required String text,
  }) {
    //sender
    messageModel = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel!.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
        })
        .catchError((error) {
          emit(SocialSendMessageErrorState(error.toString()));
        });

    //receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel!.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
        })
        .catchError((error) {
          emit(SocialSendMessageErrorState(error.toString()));
        });
  }

  List<MessageModel> messages = [];
  void getMessages({
     String? receiverId
}){

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event){

          messages = [];
          event.docs.forEach((element){
            print("element ${element.data()}");
            messages.add(MessageModel.fromJson(element.data()));
          });

          emit(SocialGetMessagesSuccessState());
    });

}

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await CacheHelper.removeData(key: 'uId');

      uId = ''; //  Reset global user ID
      print("🔹 User logged out, uId cleared.");

      emit(UserLoggedOutSuccessState());

      //  Navigate to login screen after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      emit(UserLoggedOutErrorState(e.toString()));
    }
  }
}
