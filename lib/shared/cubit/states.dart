class SocialStates {}

class SocialInitState extends SocialStates {}

//get user
class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;
  SocialGetUserErrorState(this.error);
}

//get all users
class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;
  SocialGetAllUsersErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickerSuccessState extends SocialStates {}

class SocialProfileImagePickerErrorState extends SocialStates {}

class SocialCoverImagePickerSuccessState extends SocialStates {}

class SocialCoverImagePickerErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}

class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {
  final String error;
  SocialUserUpdateErrorState(this.error);
}

//create post
class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {
  final String error;
  SocialCreatePostErrorState(this.error);
}

// image post
class SocialPostImagePickerSuccessState extends SocialStates {}

class SocialPostImagePickerErrorState extends SocialStates {}

//remove image post
class SocialRemovePostImageSuccessState extends SocialStates {}

//get posts
class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;
  SocialGetPostsErrorState(this.error);
}

//like post
class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {
  final String error;

  SocialLikePostsErrorState(this.error);
}

// comments
class SocialCommentOnPostsSuccessState extends SocialStates {}

class SocialCommentOnPostsErrorState extends SocialStates {
  final String error;

  SocialCommentOnPostsErrorState(this.error);
}

//get all comments
class SocialGetAllCommentsLoadingState extends SocialStates {}

class SocialGetAllCommentsSuccessState extends SocialStates {}

class SocialGetAllCommentsErrorState extends SocialStates {
  final String error;

  SocialGetAllCommentsErrorState(this.error);
}

//send message
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {
  final String error;

  SocialSendMessageErrorState(this.error);
}

//get all message
class SocialGetMessagesSuccessState extends SocialStates {}


//logout
class UserLoggedOutSuccessState extends SocialStates {}
class UserLoggedOutErrorState extends SocialStates {
  final String error;

  UserLoggedOutErrorState(this.error);
}