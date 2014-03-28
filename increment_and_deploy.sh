#/bin/bash 

set -e
git branch 
pwd 
#set up master branch locally if its not already
branch=`git branch --list master | cut -d' ' -f2`
echo "BRANCH = $branch" 
if [ "master" = "$branch" ] ; then
   echo "Branch master already exists."
   git checkout master
else
   git checkout -b master
fi

echo "Done checking git branch... Proceeding..."
function increment { 

	version=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v "\[") 
	newversion=$(python /home/fedora/version.py $version)
	mvn versions:set -DnewVersion=$newversion 
}

function push_new_version { 

        mvn versions:set -DnewVersion=$newversion 
        git branch 
        git add pom.xml 
        git commit -m "[ci-skip]" 
        git tag -a "$newversion" -m "[ci-skip] $newversion [ci-skip]" 
        git branch
        git push --follow-tags origin master 
}

function set_AIC {
        echo "Analyzing commit:" 
        git log -1
	if ( git log -1 | grep "ci" | grep "skip" ) > /dev/null; then
	   echo "the commit: [skip-ci] COMMIT"
	   AUTO_INC_POM="false"
	else

	   echo "Is human COMMIT"
	   echo "This commit :: `git log -1` ::: \nlooks good, proceeding"
	   AUTO_INC_POM="true"
	fi
        echo "... Done analyzing commit: $AUTO_INC_POM";
}

# Check f we should auto incrementing the pom, then
# we push a new version and increment
set_AIC
if [ $AUTO_INC_POM = "true" ]; then
   increment
   push_new_version
   #Only works if S3 env variables are available.
   #TODO : Rather than set these using build.properties and envInject, 
   #We could just set them RIGHT in this SCRIPT !
   mvn deploy -DskipTests=true
else
   echo "Skipped Deployment: This version was just a pom update for the new dev version"
   echo "To bad we're not using maven snapshots, this would have been done for us automatically via release plugin"
fi



