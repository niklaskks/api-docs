#!/bin/sh

# confirm environment variables
if [ ! -n "$GH_PAGES_TOKEN" ]
then
  fail "missing option \"token\", aborting"
fi

# use repo option or guess from git info
if [ -n "$GH_PAGES_REPO" ]
then
  repo="$GH_PAGES_REPO"
else
  fail "missing option \"repo\", aborting"
fi

info "using github repo \"$repo\""

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
  warning "$result"
  fail "failed pushing to github pages"
else
  success "pushed to github pages"
fi
