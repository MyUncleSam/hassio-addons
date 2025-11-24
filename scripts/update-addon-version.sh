#!/bin/bash

set -e

# Check parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 <docker-image> <addon-folder>"
    echo "Example: $0 internxt/webdav internxt-webdav"
    exit 1
fi

DOCKER_IMAGE=$1
ADDON_FOLDER=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
ADDON_PATH="$REPO_ROOT/$ADDON_FOLDER"

# Validate addon folder exists
if [ ! -d "$ADDON_PATH" ]; then
    echo "Error: Addon folder '$ADDON_PATH' does not exist"
    exit 1
fi

echo "Checking for updates to $DOCKER_IMAGE..."

# Get latest semantic version tag from Docker Hub (excluding 'latest')
LATEST_TAG=$(curl -s "https://hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags?page_size=100" | \
    jq -r '.results[] | select(.name | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")) | .name' | \
    sort -V | tail -1)

if [ -z "$LATEST_TAG" ] || [ "$LATEST_TAG" = "null" ]; then
    echo "Error: Could not find valid semantic version tag for $DOCKER_IMAGE"
    exit 1
fi

echo "Latest Docker Hub tag: $LATEST_TAG"

# Get current tag from build.yaml
BUILD_FILE="$ADDON_PATH/build.yaml"
if [ ! -f "$BUILD_FILE" ]; then
    echo "Error: build.yaml not found at $BUILD_FILE"
    exit 1
fi

CURRENT_TAG=$(grep -m1 "${DOCKER_IMAGE}:" "$BUILD_FILE" | sed -E "s/.*${DOCKER_IMAGE//\//\\/}:([^ ]+).*/\1/")
echo "Current tag in build.yaml: $CURRENT_TAG"

# Compare versions
if [ "$CURRENT_TAG" = "$LATEST_TAG" ]; then
    echo "Already up to date!"
    exit 0
fi

echo "Update needed: $CURRENT_TAG -> $LATEST_TAG"

# Update build.yaml - replace all occurrences of the docker image with new tag
sed -i "s|${DOCKER_IMAGE}:${CURRENT_TAG}|${DOCKER_IMAGE}:${LATEST_TAG}|g" "$BUILD_FILE"
echo "✓ Updated build.yaml"

# Update config.yaml version
CONFIG_FILE="$ADDON_PATH/config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.yaml not found at $CONFIG_FILE"
    exit 1
fi

CURRENT_VERSION=$(grep -m1 '^version:' "$CONFIG_FILE" | sed -E 's/version: "?([0-9]+\.[0-9]+\.[0-9]+)"?/\1/')
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}"

sed -i "s/version: \"${CURRENT_VERSION}\"/version: \"${NEW_VERSION}\"/" "$CONFIG_FILE"
echo "✓ Updated config.yaml: $CURRENT_VERSION -> $NEW_VERSION"

# Update CHANGELOG.md
CHANGELOG_FILE="$ADDON_PATH/CHANGELOG.md"
if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "Error: CHANGELOG.md not found at $CHANGELOG_FILE"
    exit 1
fi

DATE=$(date +%Y-%m-%d)
CHANGELOG_ENTRY="\n## ${NEW_VERSION} - ${DATE}\n\n- Updated base image to ${DOCKER_IMAGE}:${LATEST_TAG}\n"

# Insert after first line (assuming "# Changelog" header)
sed -i "1 a\\${CHANGELOG_ENTRY}" "$CHANGELOG_FILE"
echo "✓ Updated CHANGELOG.md"

# Git operations
cd "$REPO_ROOT"

git add "$ADDON_PATH/build.yaml" "$ADDON_PATH/config.yaml" "$ADDON_PATH/CHANGELOG.md"
git commit -m "chore: update ${ADDON_FOLDER} to base image ${LATEST_TAG}"
git push origin master

echo "✓ Committed and pushed changes"
echo ""
echo "Successfully updated $ADDON_FOLDER to version $NEW_VERSION (base image: $LATEST_TAG)"
