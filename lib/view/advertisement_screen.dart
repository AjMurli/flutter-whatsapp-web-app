import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  @override
  Widget build(BuildContext context) {
    BannerAd bannerAd = new BannerAd(size: AdSize.banner, adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad){
            debugPrint("Ad Loaded");
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error){
            debugPrint("Ad Failed");
            ad.dispose();
          },
          onAdOpened: (Ad ad){
            debugPrint("Ad Loaded");
          }
        ), request: AdRequest()
    );
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        child: AdWidget(
          ad: bannerAd..load(),
          key: UniqueKey(),
        ),
      ),
    );
  }
}
