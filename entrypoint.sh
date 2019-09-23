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
  git push --force --quiet https://"x-access-token:$INPUT_GITHUB_TOKEN"@github.com/${GITHUB_REPOSITORY}.git master:${INPUT_TARGET}
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
  cd "$INPUT_SOURCE"
  echo "Copy ${INPUT_SOURCE} to ${GITHUB_WORKSPACE}/../gittemp"
  cp -rf . "${GITHUB_WORKSPACE}/../gittemp"
  cd "${GITHUB_WORKSPACE}/../gittemp"
  git add *
  git commit --allow-empty -m 'Github Pages Deployment' -m "Date $(date)"
  git push --quiet https://"x-access-token:$INPUT_GITHUB_TOKEN"@github.com/${GITHUB_REPOSITORY}.git ${INPUT_TARGET}:${INPUT_TARGET}
  cd "$GITHUB_WORKSPACE"
  rm -rf "${GITHUB_WORKSPACE}/../gittemp"
fi

cd "$GITHUB_WORKSPACE"


if [ ! "$INPUT_PAT" = false ]; then
  echo "Personal Access Token was provided. Queueing page build!"
  curl -XPOST -H "Authorization: token ${INPUT_PAT}" -H "Accept: application/vnd.github.mister-fantastic-preview+json" https://api.github.com/repos/${GITHUB_REPOSITORY}/pages/builds
elif [ ! "$INPUT_DEPLOY_KEY" = false ]; then
  echo "Deploy key was provided. Queueing page build!"
  curl -XPOST -H "Authorization: token ${INPUT_DEPLOY_KEY}" -H "Accept: application/vnd.github.mister-fantastic-preview+json" https://api.github.com/repos/${GITHUB_REPOSITORY}/pages/builds
else
  echo "No key was provided. No page build queued!"
fi
echo "Done"