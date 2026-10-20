# Money Mate

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Build

`flutter build apk --release`
* this generate apk at `build/app/outputs/flutter-apk/app-release.apk`

`flutter build appbundle --release`
* this generate app bunddle at `build/app/outputs/bundle/release/app-release.aab`

# For production build
lib/helper/config -> baseUrl [`set correct URL`]


## SH1 key

* For production
`keytool -list -v -keystore /Users/nimeshadilini/my-release-key.jks -alias my-key-alias`   

* For debug sh1 key
`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore`

* For play store sh1 key

## Remove appliation from app

<!-- `adb uninstall com.mksddev.money_mate` -->
`adb uninstall com.mksdtec.money_mate`




# Platform specific implementation
## enable notification 
* this only test in android
* notificationService -> enableNotification
* mainActivity.kt


# Data arranged version
## Category
### no version (0)
```
  final String id;
  final String name;
  final TransactionType type;
  final IconData icon;
  final Color iconColor;
  final CategoryLimitDTO limit;
```
### Version 01
```
  final String id;
  final String name;
  final TransactionType type;
  final IconData icon;
  final Color iconColor;
  final CategoryLimitDTO limit;
  final int index; // new variable (introduce for make order)
```



https://github.com/madushanka2016/money_manager/milestones



## Currrency Rates
* from -> https://exchangerate.host/
 
https://api.exchangerate.host/live
    ? access_key = 9ed06bdf2605be87d7153d54bcee10ec
    

    * password musi123