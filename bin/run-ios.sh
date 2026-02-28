#!/bin/bash
set -e

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Running on iOS device..."
flutter run -d ios
