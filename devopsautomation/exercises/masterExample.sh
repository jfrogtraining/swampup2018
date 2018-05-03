#!/bin/bash
# Exercise 4 - Create User and Repositories
# Reference URL -
#   REST API -  https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API
#   FILESPEC - https://www.jfrog.com/confluence/display/RTF/Using+File+Specs
#   JFROG CLI - https://www.jfrog.com/confluence/display/CLI/JFrog+CLI 

# Variables
ART_URL="https://artifactory-solutions-us.jfrogbeta.com/artifactory"
ARTDOCKER_REGISTRY="docker-artifactory-solutions-us.jfrogbeta.com"
ART_PASSWORD="password"
USER="swamp2018"
ACCESS_TOKEN=""
USER_APIKEY=""
SERVER_ID="swampup2018"
REMOTE_ART_ID="jfrogtraining"

# Exercise 4 - Create User and Repositories
createUser () {
  curl -s -uadmin:"${ART_PASSWORD}" -X PUT -H 'Content-Type: application/json' \
      "${ART_URL}"/api/security/users/${USER} -d '{
         "name":"'"${USER}"'",
         "password":"'"${ART_PASSWORD}"'",
         "email":"null@jfrog.com",
         "admin":true,
         "groups":["readers","admin-group"]
       }'
}

getUserSecurity () {
  local response=($(curl -s -u"${USER}":"${ART_PASSWORD}" -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
       "${ART_URL}"/api/security/token -d "username=${USER}" -d "scope=member-of-groups:admin-group"))
  ACCESS_TOKEN=$(echo ${response[@]} | jq '.access_token' | sed 's/"//g')

  local response=($(curl -s -u"${USER}":"${ART_PASSWORD}" -X GET -H 'Content-Type: application/json' "${ART_URL}"/api/security/apiKey))
  USER_APIKEY=$(echo ${response[@]} | jq '.apiKey' | sed 's/"//g')
  #echo "User api key: ${USER}:${USER_APIKEY} and access token: ${ACCESS_TOKEN}"
}


createRepo () {
  echo "Creating Repositories"
  local response=($(curl -s -u"${USER}":"${USER_APIKEY}" -X PATCH -H "Content-Type: application/yaml" \
       "${ART_URL}"/api/system/configuration -T $1))
  echo ${response[@]}
}

# Exercise 5 - JFrog CLI
loginArt () {
   echo "Log into Artifactories"
   curl -fLs jfrog https://getcli.jfrog.io | sh
   ./jfrog rt c ${REMOTE_ART_ID} --url=https://jfrogtraining.jfrog.io/jfrogtraining/ --apikey=AKCp2Vo711zssGkjSUgXYc32HVfNhUbddJ9uLGRhQDpDTWuKr7EFeZorbpbiFfBu2haZ81YLX
   ./jfrog rt c ${SERVER_ID} --url=${ART_URL} --apikey=${USER_APIKEY}
}

downloadDependenciesTools () {
# Download the required dependencies from remote artifactory instance (jfrogtraining)
# paths - 
#    tomcat-local/org/apache/apache-tomcat/
#    tomcat-local/java/
#    generic-local/helm 
# Similar to using third party binaries that are not available from remote repositories. 

  echo "Fetch tomcat for the later docker framework build"
  ./jfrog rt dl tomcat-local/org/apache/apache-tomcat/apache-tomcat-8.0.32.tar.gz ./tomcat/apache-tomcat-8.tar.gz --server-id ${REMOTE_ART_ID} --threads 5 --flat true
  echo "Fetch java for the later docker framework build"
  ./jfrog rt dl tomcat-local/java/jdk-8u91-linux-x64.tar.gz ./jdk/jdk-8-linux-x64.tar.gz --server-id ${REMOTE_ART_ID} --threads 5 --flat true
  echo "Fetch Helm Client for later helm chart"
  ./jfrog rt dl generic-local/helm ./ --server-id ${REMOTE_ART_ID}
}

# Exercise 5 - Filespec upload with properties
uploadFileSpec () {
  echo "Uploading binaries to Artifactory"
  ./jfrog rt u --spec $1 --server-id ${SERVER_ID}
}

# Exercise 6a - AQL find all jars with impl.class
aqlsearch () {
  echo "Listing all jars with impl.class"
  local response=($(curl -s -u"${USER}":"${USER_APIKEY}" -X POST  "${ART_URL}"/api/search/aql -T $1))
  local jarList=$(echo ${response[@]} | jq '.results[].archives[].items[] | .repo + "/" + .path + "/" + .name ')
  for jar in "${jarList[@]}"
  do
     printf "${jar} \n" 
  done
}


# Exercise 6b - AQL find latest Docker build 
latestDockerTag () {
   REPO=$1
   IMAGE=$2
   aqlString='items.find({"repo":"'$REPO'","type":"folder","$and":[{"path":{"$match":"'$IMAGE'*"}},{"path":{"$nmatch":"'$IMAGE'/latest"}}]}).include("path","created","name").sort({"$desc":["created"]}).limit(1)'
   local response=($(curl -s -u"${USER}":"${USER_APIKEY}" -H 'Content-Type: text/plain' -X POST "${ART_URL}"/api/search/aql -d "${aqlString}"))
   tag=$(echo ${response[@]} | jq '.results[0].name')
   printf "'$IMAGE':'$tag'\n"
}

# Exercise 7 
step1-create1-application () {
   git clone https://github.com/jfrogtraining/project-examples
   cd project-examples/gradle-examples/4/gradle-example-publish
   # create a build configuration file for a gradle build. The command's argument is a path to a new file which will be created by the command
   ./jfrog rt gradlec gradle-example.config
   # To run a gradle build
   ./jfrog rt gradle "clean artifactoryPublish -b ./build.gradle" gradle-example.config --build-name=gradle-example --build-number=$1
   # Environment variables are collected using the build-collect-env (bce) command.
   ./jfrog rt bce gradle-example $1
   # publish the accumulated build information for a build to Artifactory
   ./jfrog rt bp gradle-example $1 --server-id ${SERVER_ID}
}

step2-create-docker-image-template () {
  git clone https://github.com/jfrogtraining/swampup2018.git
  cd swampup2018/devopsautomation/step2_dockertemplate
  downloadDependenciesTools
  tagName = "${artdocker_registry}/docker-framework:$BUILD_NUMBER"  
  docker login $ARTDOCKER_REGISTRY -u $USER -p $ART_PASSWORD
  docker build -t $tagName . 
  docker run -d -p 3000:3000 ${artdocker_registry}/docker-framework:$BUILD_NUMBER
  sleep 10 
  curl --retry 10 --retry-delay 5 -v http://localhost:3000
  ./jfrog rt dp $tagname docker --build-name=step2-create-docker-image-template --build-number=$BUILD_NUMBER
  ./jfrog rt bce step2-create-docker-image-template $BUILD_NUMBER
  ./jfrog rt bp step2-create-docker-image-template $BUILD_NUMBER
}



# Excercise 8
deleteLatestDockerFolder () {
REPO=$2
DOCKERIMAGE=$3
cat <<EOF >$1
{
  "files": [{
  "aql": {
           "items.find": {
               "repo":"$REPO",
               "type":"folder",
               "\$and":[
                   {"path":{"\$match":"$DOCKERIMAGE*"}},
                   {"path":{"\$nmatch":"$DOCKERIMAGE/latest"}}]
           }
       },
  "sortBy" : ["created"],
  "sortOrder": "desc",
  "limit": 1 }]
} 
EOF
}

deleteLatetDockerTag () {
    echo "Delete latest docker tag"
    REPO=$1
    DOCKERIMAGE=$2
    filespec="$(mktemp)"
    deleteLatestDockerFolder ${filespec} ${REPO} ${DOCKERIMAGE}
    echo -e "y" | ./jfrog rt del --spec=${filespec} --server-id=${SERVER_ID}
}

main () {
   createUser
   getUserSecurity
   # createRepo "training-repo.yaml"
   loginArt
   downloadDependenciesTools
   # uploadFileSpec "swampupfilespecUpload.json"
   # aqlsearch "aql/implfilter.aql"
   # latestDockerTag "docker-prod-local" "docker-app" 
   # step1-create1-application 10
   # deleteLatetDockerTag "docker-prod-local" "docker-app"   
}

main
