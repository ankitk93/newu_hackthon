#!/bin/bash
set -e

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🍎 Building iOS..."
flutter build ios --release --no-codesign

echo ""
echo "✅ iOS build complete!"
echo "   Output: build/ios/iphoneos/Runner.app"
