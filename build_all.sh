#!/bin/zsh
set -euo pipefail

# Build all SDK flavor variants (signed release APKs)
# Output: output_apks/

echo "=== Bayton SDK Demo - Build All Variants ==="
echo ""

# Load .env if present, then prompt for any missing values
if [ -f .env ]; then
    echo "Loading signing config from .env..."
    set -a
    source .env
    set +a
fi

if [ -z "${KEYSTORE_PATH:-}" ]; then
    echo -n "Keystore path: "
    read KEYSTORE_PATH
    export KEYSTORE_PATH
fi

if [ -z "${KEYSTORE_PASSWORD:-}" ]; then
    echo -n "Keystore password: "
    read -s KEYSTORE_PASSWORD
    echo ""
    export KEYSTORE_PASSWORD
fi

if [ -z "${KEY_ALIAS:-}" ]; then
    echo -n "Key alias: "
    read KEY_ALIAS
    export KEY_ALIAS
fi

if [ -z "${KEY_PASSWORD:-}" ]; then
    echo -n "Key password: "
    read -s KEY_PASSWORD
    echo ""
    export KEY_PASSWORD
fi

echo ""

echo "Building all SDK target variants..."
./gradlew assembleRelease

# Clear credentials from environment
unset KEYSTORE_PASSWORD KEY_PASSWORD

# Collect APKs into a single output directory with clear names
OUTPUT_DIR="output_apks"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# sdk:version pairs
SDK_ENTRIES=(
    "21:5.0" "22:5.1" "23:6.0" "24:7.0" "25:7.1"
    "26:8.0" "27:8.1" "28:9" "29:10" "30:11"
    "31:12" "32:12L" "33:13" "34:14" "35:15"
    "36:16" "37:17"
)

for entry in "${SDK_ENTRIES[@]}"; do
    sdk="${entry%%:*}"
    version="${entry#*:}"
    src="app/build/outputs/apk/sdk${sdk}/release/app-sdk${sdk}-release.apk"
    if [ -f "$src" ]; then
        cp "$src" "$OUTPUT_DIR/bayton-sdk-demo-target${sdk}-android${version}.apk"
        echo "  -> bayton-sdk-demo-target${sdk}-android${version}.apk"
    else
        echo "  !! Missing: sdk${sdk} (looked for $src)"
    fi
done

echo ""
echo "Done! Signed APKs are in $OUTPUT_DIR/"
