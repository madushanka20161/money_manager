import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/popup-helper.dart';

class MyInterstitialAd {
  InterstitialAd? _interstitialAd;
  String errorMessage = '';

  void loadAd() {
    try {
      InterstitialAd.load(
      adUnitId: 'ca-app-pub-4832836209041723/4779541540', // Replace with your real ID
      // adUnitId: 'ca-app-pub-4832836209041723/4720729580', // test addd 2
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712', // testing
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _setupCallbacks();
          print('🟢🟢🟢 add loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          errorMessage = '🔴🔴🔴 - InterstitialAd failed to load: ${error.toString()}';
          print('🔴🔴🔴 - InterstitialAd failed to load: $error');
        },
      ),
    );
    } catch (e) {
      print('🔴🔴🔴🔴🔴🔴 - error 01 : $e');
    }
  }

  void _setupCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        print('333333333333 - Ad dismissed.');
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        errorMessage = 'Ad failed to show: $error';
        print('44444444444444 - Ad failed to show: $error');
        loadAd();
      },
    );
  }

  void showAd(BuildContext context) {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      PopupHelper.showPopup(context, [Text('Ad is not ready yet [$errorMessage]', style: AppConfig.fontStyle,)]);
      print('55555555555555 - Ad is not ready yet');
    }
  }

  // void _showPopup(String message) {
  //   PopupHelper.showPopup(context, content)
  // }
}
