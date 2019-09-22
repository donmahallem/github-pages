#!/bin/sh
set -e

if [ ! -d "$INPUT_SOURCE" ]; then
  echo "Source not defined"
  exit 1
fi
if [ -z "$INPUT_TARGET" ]; then
  echo "Target not defined"
  exit 1
fi

echo "Deploying $INPUT_SOURCE directory to $INPUT_TARGET branch. (Force: $INPUT_FORCE_PUSH)"

if [ "$INPUT_FORCE_PUSH" = true ]; then
  echo "Commiting with force push"
  cd "$INPUT_SOURCE"
  git init
  git config user.name "${GITHUB_ACTOR}"
  git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
  git add *
  git commit --allow-empty -m 'Github Pages Deployment' -m "Date ${date}"
  git push --force --quiet https://"x-access-token:$GITHUB_TOKEN"@github.com/${GITHUB_REPOSITORY}.git master:${INPUT_TARGET}
  rm -rf .git

  cd "$GITHUB_WORKSPACE"
else
  echo "B"
fi

echo "Done"