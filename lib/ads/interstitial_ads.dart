import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAds {
  InterstitialAd? _interstitialAd;

  void loadAd(Function onSuccess, Function onError, Function onAdsShow) {
    try {
      InterstitialAd.load(
      adUnitId: 'ca-app-pub-4832836209041723/4779541540', // Replace with your real ID
      // adUnitId: 'ca-app-pub-4832836209041723/4720729580', // test addd 2
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712', // testing
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _setupCallbacks(onAdsShow, onError);
          onSuccess();
          // print('🟢🟢🟢 add loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          // print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴 - InterstitialAd failed to load: $error');
          onError('Ads load error 01 - ${error.toString()}');
        },
      ),
    );
    } catch (error) {
      // print('🔴🔴🔴🔴🔴🔴 - error 01 : ${error.toString()}');
      onError('Ads load error 01 - ${error.toString()}');
    }
  }

  void _setupCallbacks(Function onAdsShow, Function onError) {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // print('333333333333 - Ad dismissed.');
        onAdsShow();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        // print('44444444444444 - Ad failed to show: $error');
        onError('Ads show error - ${error.toString()}');
      },
    );
  }

  void showAd(BuildContext context, Function onError) {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      onError('Ads error - ads is not ready yet');
      // print('55555555555555 - Ad is not ready yet');
    }
  }
}
