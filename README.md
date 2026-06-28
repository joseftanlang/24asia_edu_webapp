# Flutter PWA Wrapper

From [https://github.com/bettysteger/flutter_pwa_wrapper](https://github.com/bettysteger/flutter_pwa_wrapper) 

## Development

### Run 

Either do a `flutter run` in the console (will open iOS simulator if no device is connected) or **Run > Start Debugging** in VSCode (install [Flutter extension](https://docs.flutter.dev/get-started/editor?tab=vscode)).

### Add a plugin

`flutter pub add firebase_core`

### Generate app icons & splash screen

See [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

`flutter pub run flutter_launcher_icons:main`

See [splash_screen_view](https://pub.dev/packages/splash_screen_view)

`flutter pub run splash_screen_view:create`

### Build ios

`flutter build ipa && open build/ios/archive/Runner.xcarchive`

### Build android

Signed with `"D:\Development\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore keys\keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias FlutterApp`

(i set the signing key password as some certain phrase we know 11aaaa)

`flutter build appbundle --release --no-tree-shake-icons && open build/app/outputs/bundle/release/`