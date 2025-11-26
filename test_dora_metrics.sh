#!/bin/bash
set -euo pipefail

echo "📥 Fetching latest GitHub releases…"

RELEASES_JSON=$(gh api repos/kandaj/frontend/releases --paginate)

# Sort releases by published date (newest first)
SORTED=$(echo "$RELEASES_JSON" | jq -r 'sort_by(.published_at) | reverse')

# Current release = most recent
CURRENT_RELEASE=$(echo "$SORTED" | jq '.[0]')
PREVIOUS_RELEASE=$(echo "$SORTED" | jq '.[1]')

if [[ "$CURRENT_RELEASE" == "null" ]]; then
  echo "❌ No releases found!"
  exit 1
fi

echo "==============================="
echo "📌 CURRENT RELEASE"
echo "Tag:        $(echo "$CURRENT_RELEASE" | jq -r '.tag_name')"
echo "Name:       $(echo "$CURRENT_RELEASE" | jq -r '.name')"
echo "Published:  $(echo "$CURRENT_RELEASE" | jq -r '.published_at')"
echo "ID:         $(echo "$CURRENT_RELEASE" | jq -r '.id')"
echo "==============================="

if [[ "$PREVIOUS_RELEASE" != "null" ]]; then
  echo "📌 PREVIOUS RELEASE"
  echo "Tag:        $(echo "$PREVIOUS_RELEASE" | jq -r '.tag_name')"
  echo "Name:       $(echo "$PREVIOUS_RELEASE" | jq -r '.name')"
  echo "Published:  $(echo "$PREVIOUS_RELEASE" | jq -r '.published_at')"
  echo "ID:         $(echo "$PREVIOUS_RELEASE" | jq -r '.id')"
else
  echo "⚠️ No previous release found — this might be the first release."
fi

echo "==============================="
