#!/bin/zsh
set -euo pipefail

# Build all SDK flavor variants (signed release APKs)
# Output: output_apks/

echo "=== Bayton SDK Demo - Build All Variants ==="
echo ""

# Prompt for signing credentials
echo -n "Keystore password: "
read -s KEYSTORE_PASSWORD
echo ""
echo -n "Key alias: "
read KEY_ALIAS
echo -n "Key password: "
read -s KEY_PASSWORD
echo ""
echo ""

echo "Building all SDK target variants..."
./gradlew assembleRelease \
    -PkeystorePassword="$KEYSTORE_PASSWORD" \
    -PkeyAlias="$KEY_ALIAS" \
    -PkeyPassword="$KEY_PASSWORD"

# Collect APKs into a single output directory with clear names
OUTPUT_DIR="output_apks"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# sdk:version pairs
SDK_ENTRIES=(
    "21:5.0" "22:5.1" "23:6.0" "24:7.0" "25:7.1"
    "26:8.0" "27:8.1" "28:9" "29:10" "30:11"
    "31:12" "32:12L" "33:13" "34:14" "35:15"
    "36:16"
    # Uncomment when Android 17 SDK (API 37) is installed:
    # "37:17"
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
