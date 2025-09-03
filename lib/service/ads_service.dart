import 'package:flutter/material.dart';
import 'package:money_manager_3/ads/interstitial_ads.dart';
import 'package:money_manager_3/service/network_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';

class AdsService {
  AdsService._privateConstructor();
  static final AdsService instance = AdsService._privateConstructor();
  UserState? userState;
  AppState? appState;
  final ads = InterstitialAds();
  final List<String> errors = [];

  void init(UserState userState, AppState appState) {
    this.userState = userState;
    this.appState = appState;
  }

  void prepareAds() {
    var remaingCount = userState?.ads?.remaingCount ?? 0;

    if (remaingCount > 0) {
      userState?.setAdsRemaingCount(remaingCount-1);

      ads.loadAd(() {
        appState!.setIsAdsReady(true);
        _updateRemainingCount(remaingCount);
      },(String error){
        errors.add(error);
        prepareAds();
      }, () {
        _onShowAds();
      });
    } else {
      _updateRemainingCount(remaingCount);
      _updateAdsErrors();
    }
  }

  void showAds(BuildContext context) {
    ads.showAd(context, (String error) {
      errors.add(error);
    });

    _updateAdsErrors();
  }

  void _updateRemainingCount(int count) {
    NetworkService.instance.updateAdsRemainingCount(count);
  }

  void _onShowAds() {
    NetworkService.instance.updateAdsHistory('interstitial');
    _updateRemainingCount(0);
    _updateAdsErrors();
  }

  void _updateAdsErrors() {
    if (errors.isNotEmpty) {
      NetworkService.instance.updateAdsErrors(errors);
      errors.clear();
    }
  }
}