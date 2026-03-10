#!/bin/bash
set -e

REQUIRED_DART_MIN="3.0.0"
REQUIRED_DART_MAX="4.0.0"

version_to_int() {
    echo "$1" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }'
}

echo "==> Checking if Flutter is installed..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed."
    
    echo "   Please install Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version 2>&1 | head -1 | awk '{print $2}')
DART_VERSION=$(flutter --version 2>&1 | grep -o 'Dart [0-9]*\.[0-9]*\.[0-9]*' | awk '{print $2}')

echo "   Flutter version : $FLUTTER_VERSION"
echo "   Dart version    : $DART_VERSION"
echo "   Required Dart   : >= $REQUIRED_DART_MIN and < $REQUIRED_DART_MAX"

DART_INT=$(version_to_int "$DART_VERSION")
MIN_INT=$(version_to_int "$REQUIRED_DART_MIN")
MAX_INT=$(version_to_int "$REQUIRED_DART_MAX")

if [ "$DART_INT" -lt "$MIN_INT" ] || [ "$DART_INT" -ge "$MAX_INT" ]; then
    echo ""
    echo "❌ Incompatible Dart SDK version."
    echo "   Installed : Dart $DART_VERSION (Flutter $FLUTTER_VERSION)"
    echo "   Required  : Dart >= $REQUIRED_DART_MIN and < $REQUIRED_DART_MAX"
    echo ""
    echo "   Please install a compatible Flutter version."
    echo "   You can switch versions using:"
    echo "     flutter downgrade"
    echo "     or use FVM: https://fvm.app"
    exit 1
fi

echo "✅ Flutter and Dart versions are compatible."
echo ""

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
