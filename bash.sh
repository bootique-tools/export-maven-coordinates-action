#!/usr/bin/env bash

if [ ! -f "pom.xml" ]; then
  echo "pom.xml does not exist"
  exit 0
fi

function get_pom_version_own {
  awk -F '<[^>]*>' '/<parent>/,/<\/parent>/{next} /<dependencies>/,/<\/dependencies>/{next} /<plugins>/,/<\/plugins>/{next} /<version>/ {$1=$1; gsub(/ /,"") $0; print}' pom.xml
}

function get_pom_version_parent {
  awk -F '<[^>]*>' '/<dependencies>/,/<\/dependencies>/{next} /<plugins>/,/<\/plugins>/{next} /<version>/ {$1=$1; gsub(/ /,"") $0; print}' pom.xml
}

function get_pom_groupId_own {
  awk -F '<[^>]*>' '/<parent>/,/<\/parent>/{next} /<dependencies>/,/<\/dependencies>/{next} /<plugins>/,/<\/plugins>/{next} /<groupId>/ {$1=$1; gsub(/ /,"") $0; print}' pom.xml
}

function get_pom_groupId_parent {
  awk -F '<[^>]*>' '/<dependencies>/,/<\/dependencies>/{next} /<plugins>/,/<\/plugins>/{next} /<groupId>/ {$1=$1; gsub(/ /,"") $0; print}' pom.xml
}

function get_pom_artifactId {
  awk -F '<[^>]*>' '/<parent>/,/<\/parent>/{next} /<dependencies>/,/<\/dependencies>/{next} /<plugins>/,/<\/plugins>/{next} /<artifactId>/ {$1=$1; gsub(/ /,"") $0; print}' pom.xml
}

VERSION=$(get_pom_version_own)
if [ -z "$VERSION" ]; then
  VERSION=$(get_pom_version_parent)
fi

GROUP_ID=$(get_pom_groupId_own)
if [ -z "$GROUP_ID" ]; then
  GROUP_ID=$(get_pom_groupId_parent)
fi

ARTIFACT_ID=$(get_pom_artifactId)

echo "Exporting Maven coordinates: ${GROUP_ID}:${ARTIFACT_ID}:${VERSION} ..."

# export variables to the GitHub env
echo "POM_GROUP_ID=$GROUP_ID" >> "$GITHUB_ENV"
echo "POM_ARTIFACT_ID=$ARTIFACT_ID" >> "$GITHUB_ENV"
echo "POM_VERSION=$VERSION" >> "$GITHUB_ENV"
