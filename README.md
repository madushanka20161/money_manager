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


## SH1 key

* For production
`keytool -list -v -keystore /Users/nimeshadilini/my-release-key.jks -alias my-key-alias`   

* For debug sh1 key
`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore`

* For play store sh1 key

## Remove appliation from app

`adb uninstall com.mksddev.money_mate`