#!/bin/bash
set -e

DEVICE=${1:-"emulator-5554"}

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Running on Android device: $DEVICE..."
flutter run -d "$DEVICE"
