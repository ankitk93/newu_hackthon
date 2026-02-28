#!/bin/bash
set -e

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building Android APK..."
flutter build apk --release

echo "🔨 Building Android App Bundle..."
flutter build appbundle --release

echo ""
echo "✅ Android builds complete!"
echo "   APK:  build/app/outputs/flutter-apk/app-release.apk"
echo "   AAB:  build/app/outputs/bundle/release/app-release.aab"
