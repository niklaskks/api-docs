#!/bin/sh
set -e

bundle exec middleman build
echo $GH_PAGES_REPO
# confirm environment variables
if [ ! -n "$GH_PAGES_TOKEN" ]
then
  echo "missing option \"token\", aborting"
  exit 1
fi

# use repo option or guess from git info
if [ -n "$GH_PAGES_REPO" ]
then
  repo="$GH_PAGES_REPO"
else
  echo "missing option \"repo\", aborting"
  exit 1
fi

echo "using github repo \"$repo\""

remote="https://$GH_PAGES_TOKEN@github.com/$repo.git"
branch="gh-pages"

# get these variables while still in the original repo
LAST_AUTHOR=$(git log -1 --pretty=%an)
LAST_HASH=$(git log -1 --pretty=%h)

# if directory provided, cd to it
if [ -d "$GH_PAGES_BASEDIR" ]
then
  cd $GH_PAGES_BASEDIR
fi

if [ -n $GH_PAGES_DOMAIN  ]
then
  echo $GH_PAGES_DOMAIN > CNAME
fi


# remove existing commit history
rm -rf .git

# build repository and commit
git init
git config user.email "@ax-semantics.com"
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
