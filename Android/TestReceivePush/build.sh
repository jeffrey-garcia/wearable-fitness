#!/bin/sh

clear && ./gradlew assembleDebug && adb install -r app/build/outputs/apk/app-debug.apk && adb shell monkey -p com.jeffrey.mobile.testreceivepush -c android.intent.category.LAUNCHER 1
