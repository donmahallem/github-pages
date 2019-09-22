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
  echo "Commiting as ${GITHUB_ACTOR}(${GITHUB_ACTOR}@users.noreply.github.com)"
  git init
  git config user.name "${GITHUB_ACTOR}"
  git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
  git add *
  git commit --allow-empty -m 'Github Pages Deployment' -m "Date $(date)"
  git push --force --quiet https://"x-access-token:$GITHUB_TOKEN"@github.com/${GITHUB_REPOSITORY}.git master:${INPUT_TARGET}
  rm -rf .git

else
  echo "Commiting with force push"
  cd "$GITHUB_WORKSPACE/.."
  mkdir gittemp
  cd gittemp
  git clone https://github.com/${GITHUB_REPOSITORY}.git .
  git checkout ${INPUT_TARGET}
  git pull origin
  echo "Commiting as ${GITHUB_ACTOR}(${GITHUB_ACTOR}@users.noreply.github.com)"
  git config user.name "${GITHUB_ACTOR}"
  git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
  git rm -rf *
  cd "$GITHUB_WORKSPACE"
  cp -rf "$INPUT_SOURCE"/ ./../gittemp
  cd ./../gittemp
  git add *
  git commit --allow-empty -m 'Github Pages Deployment' -m "Date $(date)"
  git push --quiet https://"x-access-token:$GITHUB_TOKEN"@github.com/${GITHUB_REPOSITORY}.git master:${INPUT_TARGET}
  rm -rf .git
fi

cd "$GITHUB_WORKSPACE"
echo "Done"