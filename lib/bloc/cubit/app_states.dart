abstract class AppStates {}

class InitialState extends AppStates {}

class BottomNavChangedState extends AppStates {}

class ChangeOptionState extends AppStates{}
class ThemeChangedState extends AppStates {}
class ChangeLanguageContainerStatusState extends AppStates {}
class PrimaryColorIndexState extends AppStates {}
class ChangeThemeContainerStatusState extends AppStates {}
class changeItemState extends AppStates{}

class ChangeAppLanguageState extends AppStates {}
class ChangeAppLanguageSuccessState extends AppStates {}
class pickDateState extends AppStates {}
class changeGenderState extends AppStates {}
class drobDownCountryState extends AppStates {}
class changeCountryState extends AppStates {}
class changeJobState extends AppStates {}

class OnBoardingPageViewChangedState extends AppStates {}

//<editor-fold desc="SplashStates">
class SplashscreenLoading extends AppStates {}
//</editor-fold>

class getFirstModeState extends AppStates {}


class loadingSliderStates extends AppStates{}
class SuccesSliderStates extends AppStates{}
class ErrorSliderStates extends AppStates{}
class PickImageOfCompanyLoadingState extends AppStates {}
class PickImageOfCompanyErrorState extends AppStates {}
class PickImageOfCompanySuccessState extends AppStates {}
class loadingBlogStates extends AppStates{}
class SuccesBlogStates extends AppStates{}
class ErrorBlogStates extends AppStates{}
class loadingServiceStates extends AppStates{}
class SuccesServiceStates extends AppStates{}
class ErrorServiceStates extends AppStates{}
class ChangeRateState extends AppStates{}
class UploadToFirebaseSuccessState extends AppStates {}
class UploadToFirebaseLoadingState extends AppStates {}
class UploadToFirebaseErrorState extends AppStates {}
class SuccessProcessState extends AppStates{}
class ErrorProcessState extends AppStates{}
class LoadingProcessState extends AppStates{}

class loadingLikesStates extends AppStates{}
class SuccesLikesStates extends AppStates{}
class ErrorLikesStates extends AppStates{}
class SuccesUnLikesStates extends AppStates{}
class ErrorUnLikesStates extends AppStates{}
class changeLikeColorState extends AppStates{}
class getSearchState extends AppStates{}
class PickImageForMatchCardLoadingState extends AppStates{}
class RemoveMatchImageState extends AppStates{}

class PickImageForMatchCardSuccessState extends AppStates{}

class PickImageForMatchCardErrorState extends AppStates{}
class loadingaddFavProductsStates extends AppStates{}
class SuccesaddFavProductsStates extends AppStates{}
class ErroraddFavProductsStates extends AppStates{}
class favColorStates extends AppStates{}

class ChangeBottomSheetState extends AppStates{}
class GetchangePayemntSuccessState extends AppStates{}

class getProfileInitialState extends AppStates{}
class getProfileSuccessState extends AppStates{}
class getProfileErrorState extends AppStates{}

class loadingCommentsStates extends AppStates{}
class SuccesaddCommentsStates extends AppStates{}
class ErroraddCommentsStates extends AppStates{}

class resetInitialState extends AppStates{}
class resetSuccessState extends AppStates{}
class resetErrorState extends AppStates{}
class ChangePasswordVisibilityState extends AppStates{}
class UpdateNotificationStatus extends AppStates{}
class SaveNotificationStatus extends AppStates{}
class GetSliderIndexState extends AppStates{}
class loadingImageStates extends AppStates{}
class SuccesImageStates extends AppStates{}
class ErrorImageStates extends AppStates{}
class changeGridState extends AppStates{}
class SuccesCartStates extends AppStates{}
class loadingCartStates extends AppStates{}
class ErrorCartStates extends AppStates{}
class SuccesDeleteCartStates extends AppStates{}
class ErrorDeleteCartStates extends AppStates{}
class loadingUpdateCartStates extends AppStates{}
class loadingDeleteCartStates extends AppStates{}
class GetNotificationSuccessState extends AppStates{}
class GetNotificationErrorState extends AppStates{}
class loadingCategoryStates extends AppStates{}
class SuccesCategoryStates extends AppStates{}
class SuccesGetDataStates extends AppStates{}
class getQuantityState extends AppStates{}

class ErrorCategoryStates extends AppStates{}
class GetUserLoadingState extends AppStates{}
class GetUserSuccessState extends AppStates{}
class GetUserErrorState extends AppStates
{
  final String error;

  GetUserErrorState(this.error);
}
class ProfileImagePickedSuccessState extends AppStates {}

class ProfileImagePickedErrorState extends AppStates {}

// States for Cover Pick

class CoverPickedSuccessState extends AppStates {}

class CoverPickedErrorState extends AppStates {}

// States for Upload Profile Photo

class UploadProfileSuccessState extends AppStates {}

class UploadProfileErrorState extends AppStates {}

// States for Upload Cover

class UploadCoverSuccessState extends AppStates {}

class UploadCoverErrorState extends AppStates {}

// States for User Update Changes

class UserUpdateLoadingState extends AppStates {}

class UserUpdateSuccessState extends AppStates {}

class UserUpdateErrorState extends AppStates {}

// States for Creat Post

class CreatPostLoadingState extends AppStates{}

class CreatPostSuccessState extends AppStates{}

class CreatPostErrorState extends AppStates{}

/*
//states for IdentificationScreen

class ChangeActiveStepState extends AppStates{}

class IncrementActiveStepState extends AppStates{}

class DecrementActiveStepState extends AppStates{}

class PickImageForMatchCardLoadingState extends AppStates{}

class PickImageForMatchCardSuccessState extends AppStates{}

class PickImageForMatchCardErrorState extends AppStates{}

class RemoveFrontImageState extends AppStates{}

class RemoveBackImageState extends AppStates{}

class RemoveMatchImageState extends AppStates{}


class UploadCardImagesLoadingState extends AppStates{}

class UploadCardImagesSuccessState extends AppStates{}

class UploadCardImagesErrorState extends AppStates{}
*/


