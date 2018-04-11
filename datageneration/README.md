#Data Generator
*****************

*****************
| Package Type  | Jenkins Job
|---------------|----------------|
| Docker    |   data-generator-docker   |
| Debian    |   data-generator-debian  |
| Maven | data-generator-maven |
| RPM | data-generator-rpm |

###_Docker Data Generator_
####Default settings (recommend to set your own):
// Parameters - the following parameters can be exposed using Jenkins Parameters.
* baseIamge - The base image to build the images from. default: busybox
* SIZE = <int>M/K ,Size of single package to generate(before comprassion). default: (random.nextInt(100) + 1).toString() + "M"
* PNUM = <int> ,Number of packges to generate. default: random.nextInt(10) + 1
* NUMOFTAGS - The number of tags per image. default: 1
* DNAME = sample-docker - The docker image name. default: "sample_docker"
* NAMESPACE - jfrog - the namespace to push the docker image to. default: "beta"
* FNUM - Number of files in the lowset level (inside the package created in each layer). default: random.nextInt(10) + 1
* INUM - Number of images of to build". default: random.nextInt(1) + 1
* LNUM - Number of layers. default: random.nextInt(10) + 1
* TESTING - build label to use. default: "beta"
* WATCHNAME - Xray watch name. default: "docker-stage-local"
* TAG = 1 - The tag prefix to add to built images. default: 1
* NAMESPACEDOMAIN - namespace.domain name: default: solutions-us.jfrogbeta.com. The artifactory and XRAY url are derived from this - artifactory-solutions-us.jfrogbeta.com


###_Debian Data Generator_
####Default settings (recommend to set your own):
####Parameters - the following parameters can be exposed using Jenkins Parameters.
* SIZE = <int>M/K ,Size of single package to generate(before comprassion). default: (random.nextInt(50) + 1).toString() + "M"
* PNUM = <int> ,Number of packges to generate. default: random.nextInt(2) + 1
* DEST = <path> ,Destination path to generate the files. default: build-${BUILD_NUMBER}-debian"
* FNUM = <int>,Size of files in the lowset level. default: ""
* COMPRESS = 0-9,Compression level of the final packge (0-9). default: ""
* PROPS = <debian property>,trusty/main/all. default: trusty
* REPO = <debian repository>,The repository to deploy debian packages. default: "debian-dev-local"
* DEPTH = <int>,Size of the final packge tree; default: ""
* DPATH = <path>,The path files will be deployed to. default: "build-${BUILD_NUMBER}-debian"
* TESTING - build label to use. default: "beta"
* WATCHNAME - Xray watch name. default: "debian-dev-local (must match REPO)
* NAMESPACEDOMAIN - namespace.domain name: default: solutions-us.jfrogbeta.com. The artifactory and XRAY url are derived from this - artifactory-solutions-us.jfrogbeta.com

###Maven Data Generator
####Default settings (recommend to set your own)
* unique_packages  - Number of Maven packages to build. default: unique_packages = random.nextInt(2) + 1
* major_packages   - Number of major packages. default: random.nextInt(2) + 1
* minor_packages   - Number of minor packages within major packages. default: random.nextInt(2) +1
* nooffiles        - Number of random files to include in the Maven package.  The FILESIZE parameter specifies the size of each of these files. default: random.nextInt(2) + 1
* filesize         - Size of each file in Megabytes. default: (random.nextInt(2) + 1).toString() + "M"
* prefix           - Prefix of the file name to use for the random files. default: "beta"
* repository       - Repository to deploy artifacts. default: "maven-data-local"
* type             - type of artifacts {release | snapshot | plugin-release | plugin-snapshot}. default" "release"
* group_id         - Maven GAVC. default: "org.pom.test.${BUILD_NUMBER}"
* watchname        - XRAY watch name to monitor the artifacts. Must be the same as repository. default: "maven-data-local"
* num_of_snapshots - number of snapshot builds. default: 0
* NAMESPACEDOMAIN - namespace.domain name: default: solutions-us.jfrogbeta.com. The artifactory and XRAY url are derived from this - artifactory-solutions-us.jfrogbeta.com
