#!/bin/bash

git_push() {

  CURRENT_BRANCH=$(git branch --show-current)

  if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "You must be on the main branch to execute this script."
    exit 1
  fi

  read -p "To which branch do you want to push the commit ? " BRANCH
  read -p "What is your commit message before pushing it to the Internet ? " MESSAGE

  if [ -z "$BRANCH" ] || [ -z "$MESSAGE" ]; then
    echo "No answer has been given, aborting the git push process ..."
    exit 1
  fi

  if [ "$BRANCH" != "main" ]; then
    echo "You are only allowed to push to the main branch."
    exit 1
  fi

  git add .
  git commit -m "$MESSAGE"
  git push origin main

  echo "✅ Commit and push to main completed successfully."
}

git_push
``