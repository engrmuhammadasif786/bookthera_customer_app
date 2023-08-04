
import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/models/ProviderCategory.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/screens/home/dashboard.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer/utils/helper.dart' as hp;
import 'package:provider/provider.dart';

class ProviderProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ProviderCategory> providerCategoryList = [];
  List<ProviderModel> favouriteProvidersList = [];
  List<ProviderModel> providersList = [];
  ChatProvider chatProvider=ChatProvider();
  bool isFirstLoad=false;

  getChatProvider(BuildContext context){
    chatProvider=context.read<ChatProvider>();
  }

  resetProducsList() {
    print('reset products list');
    providersList.clear();
    notifyListeners();
  }

  setLoader(bool status) {
    isLoading = status;
    notifyListeners();
  }

  getProviderList() {
    if (providersList.isEmpty) {
      return providerCategoryList;
    } else {
      return providersList;
    }
  }

  doCallGetProvidersByCategory() {
    if (isFirstLoad) {
      return;
    }
    isFirstLoad=true;
    setLoader(true);
    chatProvider.getOnlineUser();
    callGetProvidersByCategory().then((value) {
      if (value is String) {
        toast(value);
      } else if (value is List<ProviderCategory>) {
        providersList.clear();
        providerCategoryList = value;
        providerCategoryList.forEach((element) {
          element.data.forEach((user) {
            if (chatProvider.isUserOnline(user.owner!)) {
              user.onlineStatus =true;
            }
          });
        });
      }
      setLoader(false);
    });
  }

  doCallGetProvidersByFavourite() {
    setLoader(true);
    chatProvider.getOnlineUser();
    callGetProvidersByFavourite().then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is List<ProviderModel>) {
        favouriteProvidersList = value;
        favouriteProvidersList.forEach((element) {
           if (chatProvider.isUserOnline(element.owner!)) {
              element.onlineStatus = true;
            }
        });
      }
    });
  }

  doCallProviderLikeUnlike(String providerId, {bool isShowLoader = false}) {
    setLoader(isShowLoader);
    callProviderLikeUnlike(providerId).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else {
        if (isShowLoader) {
          favouriteProvidersList
              .removeWhere((element) => element.sId == providerId);
        }
      }
    });
  }

  Future<dynamic> doCallGetProviderById(String providerId) async {
    setLoader(true);
    ProviderModel? providerModel;
    chatProvider.getOnlineUser();
    await callGetProviderById(providerId).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is ProviderModel) {
        providerModel = value;
        if (chatProvider.isUserOnline(providerId)) {
          providerModel!.onlineStatus=true;
        }
      }
    });
    return providerModel;
  }

  doCallGetProviders(
      {String price = '',
      String reviewsCount = '',
      bool? isAudio,
      bool? isVideo,
      bool? isChat,
      bool? isBook,
      bool? promotion,
      bool? onlineOnly}) {
    setLoader(true);
    chatProvider.getOnlineUser();
    callGetProviders(
            price: price,
            reviewsCount: reviewsCount,
            isAudio: isAudio,
            isVideo: isVideo,
            isChat: isChat,
            isBook: isBook,
            promotion: promotion,
            onlineOnly: onlineOnly)
        .then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is List<ProviderModel>) {
        providersList = value;
        providersList.forEach((element) {
          if (chatProvider.isUserOnline(element.owner!)) {
            element.onlineStatus=true;
          }
        });
      }
    });
  }

  doCallGetProvidersSearch(String searchText) {
    setLoader(true);
    chatProvider.getOnlineUser();
    callGetProvidersSearch(searchText).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is List<ProviderModel>) {
        providersList = value;
         providersList.forEach((element) {
          if (chatProvider.isUserOnline(element.owner!)) {
            element.onlineStatus=true;
          }
        });
      }
    });
  }
}
