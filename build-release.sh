#!/bin/bash
echo "Building web..."
npm run build

echo "Syncing Capacitor..."
npx cap sync android

echo "Building AAB..."
cd android && ./gradlew bundleRelease

echo "✅ AAB listo en: android/app/build/outputs/bundle/release/trucov1.aab"