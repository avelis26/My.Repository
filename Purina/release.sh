#!/bin/sh

# This is meant to be run from inside the git-controlled project folder (ie, ../tools/release)

arg1="$1"
#arg2="$2" no longer need date passed in
arg3="$2"
arg4="$3"
arg5="$4"
arg6="$5"

isInteractive=0
if [[ "$arg6" == "" ]]; then
  isInteractive=1
  echo "Missing args, interactive mode triggered."
  echo "Usage: release [qa|qa2|uat|production] [branch to deploy] [jira slug] [jira description] [code]"
  echo ""
fi

printf "Environment (uat/production): $arg1"
if [[ "$arg1" != "" ]]; then echo ""; fi
while [[ "$arg1" == "" ]]; do read arg1; done

# the branch we will use to fork the deploy branch
# ultimately the target, but not really here
targetbranch='master'
target='production'
if [[ "$arg1" == "uat" ]]; then
  targetbranch='uat'
  target='uat'
fi

git fetch --all >/dev/null 2>&1
git checkout $targetbranch >/dev/null 2>&1
git pull origin $targetbranch >/dev/null 2>&1

#if [[ "$arg2" == "" ]]; then
  arg2=$(printf '%s%02d' $(date +%Y.%m.%d.) $(git tag | grep -c $(date +rc%Y_%m_%d_)))
#fi
printf "Date/version (xxxx.xx.xx.xx): $arg2\n"

printf "Branch to deploy (ex: feature/the-feature-branch): $arg3"
if [[ "$arg3" != "" ]]; then echo ""; fi
while [[ "$arg3" == "" ]]; do read arg3; done

printf "JIRA (ex: 'PURM-xxxx'): $arg4"
if [[ "$arg4" != "" ]]; then echo ""; fi
while [[ "$arg4" == "" ]]; do read arg4; done

printf "Name (ex: 'The Release Name'): $arg5"
if [[ "$arg5" != "" ]]; then echo ""; fi
while [[ "$arg5" == "" ]]; do read arg5; done

code="$arg6"

sourcebranch="$arg3"
deploybranch="release/rc$arg2"
deployslug="$arg2"
camelslug=${arg2//[\.]/_}
deploytag="rc${camelslug}"
if [[ "$target" == "uat" ]]; then
  deploybranch='uat'
  deployslug="${arg2}u"
  deploytag="rc${camelslug}u"
fi

echo ""
echo "******************************************"
echo "Push branch: $sourcebranch"
echo "Target environment: $target"
echo "Target branch: $targetbranch"
echo "Deploy branch: $deploybranch"
echo "Deploy tag: $deploytag"
echo "******************************************"
echo ""

git checkout $targetbranch
git fetch --all # probably not necessary
git pull origin $targetbranch # maybe not necessary

echo "Latest log for $target in $targetbranch:"
git log --oneline | head -5

if [[ "$targetbranch" != "uat" ]]; then
  if [[ $isInteractive == 1 ]]; then
    echo "Is $targetbranch up-to-date?"
    read -n 1 -s -p "Press any key to continue, or ctrl-c to break."
    echo ""
  fi
  echo "Creating branch $deploybranch"
  git checkout -b $deploybranch
  git push origin $deploybranch
else
  git checkout $deploybranch
fi

echo "Safe merging [$sourcebranch] into [$deploybranch]"
../tools/mergein $sourcebranch
echo "Safe merging complete"

if [[ "$code" == "" ]]; then
  echo "******************************************"
  echo "Please enter the auth code for $target:"
  echo "******************************************"
  read code
fi

git tag -a $deploytag -m "$code $target deployment $arg4 $arg5"
git status

echo ""
echo "Check the logs above very carefully to see if you have any errors."
echo "If you have a merge conflict, you'll have to 1) resolve it, 2) commit,"
echo "3) push uat, and then start over, using $deploybranch as the source branch."
echo ""
echo "If the merge was successful, execute the following (copy and paste it)."
echo "The build will trigger on the servers minutes after you execute this:"
echo ""
echo "    ../tools/releasecomplete"
echo ""
echo "Messed up? Use this to clean up and abandon this release:"
echo ""
echo "    ../tools/releaseabandon"
echo ""
echo "*** For profiles production, don't forget to clear the web/frontend cache(s) by using"
echo "*** the URL method, and only after you receive the notification emails!"
echo ""
