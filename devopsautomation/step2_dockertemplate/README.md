DevOps Automation Training - Swampup Edition 
============================================

Description
-----------
Builds apache and java layer in docker container. Deploys to "docker" 

Jenkins Parameters
------------------
CREDENTIALS (credential parameter) - Artifactory credentials
NAMESPACEDOMAIN (String) - specify namespace.domain-name i.e. soldev-us.jfrogbeta.com; code will preappend "artifactory", "mission-control", "xray" (url: xray.soldev-us.jfrogbeta.com)
XRAY_SCAN (Choice) - YES | NO
TESTING (String) - build label to use

