import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyInterstitialAd {
  InterstitialAd? _interstitialAd;

  void loadAd() {
    try {
      InterstitialAd.load(
      // adUnitId: 'ca-app-pub-4832836209041723/4779541540', // Replace with your real ID
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _setupCallbacks();
          print('🟢🟢🟢 add loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
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
        print('44444444444444 - Ad failed to show: $error');
        loadAd();
      },
    );
  }

  void showAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('55555555555555 - Ad is not ready yet');
    }
  }
}
