#!/usr/bin/env groovy

/**
 * Jenkinsfile for building a Maven-based Jenkins plugin.
 * Assumes the Jenkins agent has `java`, `maven`, and optionally `docker` installed.
 */

def runTests = true

// Retain recent builds & artifacts
properties([
    buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '20'))
])

node('java') {
    timestamps {
        stage('Checkout') {
            checkout scm
        }

        stage("Build / Test") {
            timeout(time: 180, unit: 'MINUTES') {
                withMavenEnv([
                    "JAVA_OPTS=-Xmx1536m -Xms512m",
                    "MAVEN_OPTS=-Xmx1536m -Xms512m"
                ]) {
                    def testFlag = runTests ? '-Dmaven.test.failure.ignore=true' : '-DskipTests'
                    sh """
                        mvn -Pdebug -U clean install ${testFlag} -V -B -Dmaven.repo.local=${pwd()}/.repository
                    """
                }
            }
        }

        stage('Archive Artifacts / Test Results') {
            archiveArtifacts artifacts: '**/target/*.jar, **/target/*.war, **/target/*.hpi', fingerprint: true
            if (runTests) {
                junit testResults: '**/target/surefire-reports/*.xml', healthScaleFactor: 20.0
            }
        }
    }
}

void withMavenEnv(List envVars = [], Closure body) {
    // Set tools (you must configure these names in Jenkins Global Tool Config)
    String mvntool = tool name: 'mvn', type: 'hudson.tasks.Maven$MavenInstallation'
    String jdktool = tool name: 'jdk8', type: 'hudson.model.JDK'

    List toolEnv = [
        "PATH+MVN=${mvntool}/bin",
        "PATH+JDK=${jdktool}/bin",
        "JAVA_HOME=${jdktool}",
        "MAVEN_HOME=${mvntool}"
    ]

    toolEnv.addAll(envVars)

    withEnv(toolEnv) {
        body()
    }
}
