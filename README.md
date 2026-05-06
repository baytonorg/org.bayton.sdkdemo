# BAYTON SDK Demo

A simple Android app that shows you what **target SDK version** it was built for, and what **Android version** your device is running. That's it — one screen, two pieces of info.

## What's the point?

Starting with Android 14, Google blocks the installation of apps that target very old versions of Android. This is a security measure — older target SDKs let apps bypass newer privacy and security protections.

This project builds **several copies of the same app**, each targeting a different Android version (from Android 5.0 all the way up to Android 17). You can then try installing them on a device to see which ones are allowed and which ones get blocked.

For a full explanation of how this works and why it matters, check out:

📖 [**Android minimum targetSdk matrix**](https://bayton.org/android/android-minimum-targetsdk-matrix)

📖 [**Android 14 blocks sideloaded apps targeting old SDKs**](https://bayton.org/android/advisories/android-14-app-install/)

## Pre-built APKs

If you just want to download and test the APKs without building anything, grab them from:

🔗 [**Android minimum targetSdk matrix**](https://bayton.org/android/android-minimum-targetsdk-matrix)

## Building it yourself

Never built an Android app before? No worries — here's what you need.

### What you'll need

1. **A computer** — Mac, Windows, or Linux all work
2. **Android Studio** — download it free from [developer.android.com/studio](https://developer.android.com/studio). This gives you everything needed to build Android apps
3. **A signing key** — this is like a digital signature that proves the app came from you. Android requires all apps to be signed, even for testing

### Step by step

#### 1. Clone this project

Open a terminal (or command prompt on Windows) and run:

```bash
git clone https://github.com/baytonorg/org.bayton.sdkdemo.git
cd org.bayton.sdkdemo
```

#### 2. Set up your signing key

You need a **keystore file** — think of it as a locked box containing your signing identity.

If you don't have one, create one with this command (comes with Android Studio):

```bash
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key
```

It will ask you for a password and some identity info. Remember the password — you'll need it in the next step.

#### 3. Configure your credentials

Copy the example environment file and fill in your details:

```bash
cp .env.example .env
```

Open `.env` in any text editor and fill in:

```
KEYSTORE_PATH=/full/path/to/my-release-key.jks
KEYSTORE_PASSWORD=the-password-you-chose
KEY_ALIAS=my-key
KEY_PASSWORD=the-password-you-chose
```

> ⚠️ **Don't commit your `.env` file** — it contains your passwords. The `.gitignore` is already set up to prevent this.

#### 4. Build all variants

Run the build script:

```bash
./build_all.sh
```

This will build several APKs — one for each target SDK level from API 21 (Android 5.0) to API 37 (Android 17). The finished APKs end up in the `output_apks/` folder.

#### 5. Install on a device

Connect an Android device via USB (with [USB debugging enabled](https://developer.android.com/studio/debug/dev-options#enable)), then:

```bash
adb install output_apks/bayton-sdk-demo-target37-android17.apk
```

Replace the filename with whichever variant you want to test.

### What to expect

- **On Android 14+**: Apps targeting very old SDKs will be **blocked** with a `INSTALL_FAILED_DEPRECATED_SDK_VERSION` error
- **On older Android versions**: All variants should install fine
- **Upgrading**: You can install a higher-target variant over a lower one without uninstalling first (each variant has a unique version code)

## Project structure

```
├── app/
│   ├── build.gradle.kts       # Build config with product flavors per SDK
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/.../MainActivity.kt   # The one and only screen
│       └── res/
│           ├── layout/activity_main.xml
│           ├── drawable/              # Logo and icon assets
│           └── values/strings.xml
├── build_all.sh               # Builds all APK variants in one go
├── .env.example               # Template for signing credentials
└── README.md
```

## Licence

This project is licensed under the [GNU General Public License v3.0](LICENCE). You're free to use, modify, and redistribute it — with attribution, and any modifications must also be open-sourced under the same licence.
