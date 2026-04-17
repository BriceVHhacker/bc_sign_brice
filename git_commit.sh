#!/bin/bash

git_commit() {

  CURRENT_BRANCH=$(git branch --show-current)

  if [ "$CURRENT_BRANCH" != "dev" ]; then
    echo "You must be on the dev branch to execute this script."
    exit 1
  fi

  read -p "What is your commit message ? " MESSAGE

  if [ -z "$MESSAGE" ]; then
    echo "No answer has been given, aborting the git commit process …"
    exit 1
  fi

  git add .
  git commit -m "$MESSAGE"
  git push origin dev

  echo "✅ Commit and push to dev completed successfully."
}

git_commit