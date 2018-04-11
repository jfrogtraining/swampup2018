DevOps Automation Training - Swampup Edition 
============================================

Description
-----------
Builds a simple application using gradle. Deploys to "gradle-release" repository

Jenkins Parameters
------------------
NAMESPACEDOMAIN (String) - specify namespace.domain-name i.e. soldev-us.jfrogbeta.com; code will preappend "artifactory", "mission-control", "xray" (url: xray.soldev-us.jfrogbeta.com)
GRADLE_TOOL (String)  - gradle version to use
XRAY_SCAN (Choice) - YES | NO
TESTING (String) - build label to use

