abstract class AuthStates {}

class InitialState extends AuthStates {}

class BottomNavChangedState extends AuthStates {}
class loadingBlogStates extends AuthStates{}
class SuccesBlogStates extends AuthStates{}
class ErrorBlogStates extends AuthStates{}
class ThemeChangedState extends AuthStates {}
class ChangeLanguageContainerStatusState extends AuthStates {}
class PrimaryColorIndexState extends AuthStates {}
class ChangeThemeContainerStatusState extends AuthStates {}

class ChangeAuthLanguageState extends AuthStates {}
class ChangeAuthLanguageSuccessState extends AuthStates {}
class pickDateState extends AuthStates {}
class changeGenderState extends AuthStates {}
class drobDownCountryState extends AuthStates {}
class changeCountryState extends AuthStates {}
class changeJobState extends AuthStates {}

class OnBoardingPageViewChangedState extends AuthStates {}

//<editor-fold desc="SplashStates">
class SplashscreenLoading extends AuthStates {}
//</editor-fold>

class getFirstModeState extends AuthStates {}


class SignUpInitialState extends AuthStates{}
class SignUpSuccessState extends AuthStates{}
class SignUpErrorState extends AuthStates{}

class LogInInitialState extends AuthStates{}

class LogInSuccessState extends AuthStates{}

class LogInErrorState extends AuthStates{}
class ChangeDescriptionContainerStatusState extends AuthStates {}

class UploadProfileImageLoadingState extends AuthStates{}

class UploadProfileImageSuccessState extends AuthStates{}

class UploadProfileImageErrorState extends AuthStates
{
  final String error;
  UploadProfileImageErrorState(this.error);
}



class PickProfileImageFromCameraLoadingState extends AuthStates{}

class PickProfileImageFromCameraSuccessState extends AuthStates{}

class PickProfileImageFromCameraErrorState extends AuthStates
{
  final String error;
  PickProfileImageFromCameraErrorState(this.error);
}
class PickProfileImageFromGalleryLoadingState extends AuthStates{}

class PickProfileImageFromGallerySuccessState extends AuthStates{}

class PickProfileImageFromGalleryErrorState extends AuthStates
{
  final String error;
  PickProfileImageFromGalleryErrorState(this.error);
}

class resetInitialState extends AuthStates{}
class resetSuccessState extends AuthStates{}
class resetErrorState extends AuthStates{}

class getProfileInitialState extends AuthStates{}
class getProfileSuccessState extends AuthStates{}
class getProfileErrorState extends AuthStates{}

class outInitialState extends AuthStates{}
class outSuccessState extends AuthStates{}
class outErrorState extends AuthStates{}
class ChangeDateState extends AuthStates{}

class ChangePasswordVisibilityState extends AuthStates{}
class UpdateNotificationStatus extends AuthStates{}
class SaveNotificationStatus extends AuthStates{}
class GetNotificationSuccessState extends AuthStates{}
class GetNotificationErrorState extends AuthStates{}

class GetUserLoadingState extends AuthStates{}
class GetUserSuccessState extends AuthStates{}
class GetUserErrorState extends AuthStates
{
  final String error;

  GetUserErrorState(this.error);
}
class ProfileImagePickedSuccessState extends AuthStates {}

class ProfileImagePickedErrorState extends AuthStates {}

// States for Cover Pick

class CoverPickedSuccessState extends AuthStates {}

class CoverPickedErrorState extends AuthStates {}

// States for Upload Profile Photo

class UploadProfileSuccessState extends AuthStates {}

class UploadProfileErrorState extends AuthStates {}

// States for Upload Cover

class UploadCoverSuccessState extends AuthStates {}

class UploadCoverErrorState extends AuthStates {}

// States for User Update Changes

class UserUpdateLoadingState extends AuthStates {}

class UserUpdateSuccessState extends AuthStates {}

class UserUpdateErrorState extends AuthStates {}

// States for Creat Post

class CreatPostLoadingState extends AuthStates{}

class CreatPostSuccessState extends AuthStates{}

class CreatPostErrorState extends AuthStates{}

//states for IdentificationScreen

class ChangeActiveStepState extends AuthStates{}

class IncrementActiveStepState extends AuthStates{}

class DecrementActiveStepState extends AuthStates{}

class PickImageForMatchCardLoadingState extends AuthStates{}

class PickImageForMatchCardSuccessState extends AuthStates{}

class PickImageForMatchCardErrorState extends AuthStates{}

class RemoveFrontImageState extends AuthStates{}

class RemoveBackImageState extends AuthStates{}

class RemoveMatchImageState extends AuthStates{}

class UploadCardImagesLoadingState extends AuthStates{}

class UploadCardImagesSuccessState extends AuthStates{}

class UploadCardImagesErrorState extends AuthStates{}
class UpdatefingerStatus extends AuthStates{}
class SavefingerStatus extends AuthStates{}
class BiomatricStatus extends AuthStates{}