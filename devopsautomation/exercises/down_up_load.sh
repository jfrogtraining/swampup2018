#!/bin/bash
# Exercise 4 - Create User and Repositories
# Reference URL - https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API
 
# Variables
ART_URL="https://artifactory-solutions-us.jfrogbeta.com/artifactory"
ART_PASSWORD="password"
USER="swamp2018"
ACCESS_TOKEN=""
USER_APIKEY=""

# Exercise 4 - Create User and Repositories
createUser () {
  curl -uadmin:"${ART_PASSWORD}" -X PUT -H 'Content-Type: application/json' \
      "${ART_URL}"/api/security/users/${USER} -d '{
         "name":"'"${USER}"'",
         "password":"'"${ART_PASSWORD}"'",
         "email":"null@jfrog.com",
         "admin":true,
         "groups":["readers","admin-group"]
       }'
}

getUserSecurity () {
  local response=($(curl -u"${USER}":"${ART_PASSWORD}" -X POST -H 'Content-Type: application/x-www-form-urlencoded' \
       "${ART_URL}"/api/security/token -d "username=${USER}" -d "scope=member-of-groups:admin-group"))
  ACCESS_TOKEN=$(echo ${response[@]} | jq '.access_token' | sed 's/"//g')

  local response=($(curl -u"${USER}":"${ART_PASSWORD}" -X GET -H 'Content-Type: application/json' "${ART_URL}"/api/security/apiKey))
  USER_APIKEY=$(echo ${response[@]} | jq '.apiKey' | sed 's/"//g')
  echo "User api key: ${USER}:${USER_APIKEY} and access token: ${ACCESS_TOKEN}"
}


createRepo () {
  echo "Creating Repositories"
  local response=($(curl -u"${USER}":"${USER_APIKEY}" -X PATCH -H "Content-Type: application/yaml" \
       "${ART_URL}"/api/system/configuration -T $1))
  echo ${response[@]}
}

# Exercise 5 - JFrog CLI
loginArt () {
   echo "Log into Artifactories"
   curl -fL jfrog https://getcli.jfrog.io | sh
   ./jfrog rt c jfrogtraining --url=https://jfrogtraining.jfrog.io/jfrogtraining/ --apikey=AKCp2Vo711zssGkjSUgXYc32HVfNhUbddJ9uLGRhQDpDTWuKr7EFeZorbpbiFfBu2haZ81YLX
   ./jfrog rt c swampup2018 --url=${ART_URL} --apikey=${USER_APIKEY}
}

downloadDependenciesTools () {
# Download the required dependencies from remote artifactory instance (jfrogtraining)
# paths - 
#    tomcat-local/org/apache/apache-tomcat/
#    tomcat-local/java/
#    generic-local/helm 
# Similar to using third party binaries that are not available from remote repositories. 

  echo "Fetch tomcat for the later docker framework build"
  ./jfrog rt dl tomcat-local/org/apache/apache-tomcat/ ./ --server-id jfrogtraining --threads 5
  echo "Fetch java for the later docker framework build"
  ./jfrog rt dl tomcat-local/java/ ./ --server-id jfrogtraining --threads 5
  echo "Fetch Helm Client for later helm chart"
  ./jfrog rt dl generic-local/helm ./ --server-id jfrogtraining
}

main () {
   createUser
   getUserSecurity
   createRepo "training-repo.yaml"
   downloadDependenciesTools
}

main

