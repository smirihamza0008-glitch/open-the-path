import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdManager {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // معرفات الإعلانات الاختبارية من جوجل لأندرويد
  final String interstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';
  final String rewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // 1. تحميل الإعلان البيني (يظهر بين المراحل)
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  // عرض الإعلان البيني
  void showInterstitial(VoidCallback onAdClosed) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitial(); // تحميل الإعلان التالي
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onAdClosed();
        },
      );
      _interstitialAd!.show();
    } else {
      onAdClosed();
    }
  }

  // 2. تحميل إعلان المكافأة (مشاهدة مقابل إكمال اللعب)
  void loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  // عرض إعلان المكافأة
  void showRewarded(Function(RewardItem) onRewardEarned, VoidCallback onAdClosed) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewarded();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onAdClosed();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: onRewardEarned);
    } else {
      // إذا لم يتوفر الإعلان لأي سبب، نتيح له الإكمال مجاناً كي لا يغضب اللاعب
      onRewardEarned(RewardItem(1, 'continue'));
      onAdClosed();
    }
  }
}
