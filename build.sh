#!/bin/bash

# Exit on error
set -e

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

echo "Checking Flutter version..."
flutter --version

echo "Building Flutter Web..."
flutter build web --release

echo "Moving build to public folder..."
rm -rf public
mv build/web public

echo "Done!"
