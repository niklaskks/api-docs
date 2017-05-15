#!/bin/sh
set -e

bundle exec middleman build

remote="https://$GH_PAGES_TOKEN@github.com/$GH_PAGES_REPO.git"
branch="gh-pages"

# get these variables while still in the original repo
LAST_AUTHOR=$(git log -1 --pretty=%an)
LAST_HASH=$(git log -1 --pretty=%h)

# if directory provided, cd to it
if [ -d "$GH_PAGES_BASEDIR" ]
then
  cd $GH_PAGES_BASEDIR
else
  echo "BASEDIR $GH_PAGES_BASEDIR not found, aborting"
  exit 1
fi

echo $GH_PAGES_DOMAIN > CNAME

# remove existing commit history
rm -rf .git

# build repository and commit
git init
git config user.email "aexea-deploy@ax-semantics.com"
git config user.name "Travis CI"

git add .
git commit -m "deploy from $LAST_AUTHOR, ($LAST_HASH)"
result="$(git push -f $remote master:$branch)"

if [[ $? -ne 0 ]]
then
  echo "$result"
  echo "failed pushing to github pages"
  exit 1
else
  echo "pushed to github pages"
fi
