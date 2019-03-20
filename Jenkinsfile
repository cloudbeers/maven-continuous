pipeline {
    agent any
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '1', daysToKeepStr: '', numToKeepStr: '10')
        disableConcurrentBuilds()
    }
    stages {
        stage('Build') {
            when {
                not { branch 'master' }
            }
            steps {
                withMaven(maven:'maven-3', jdk:'java-8', mavenLocalRepo: '.repository') {
                    sh 'mvn verify'
                }
            }
        }
        stage('Release') {
            when {
                branch 'master'
            }
            steps {
                withMaven(maven:'maven-3', jdk:'java-8', mavenLocalRepo: '.repository') {
                    sh 'mvn release:clean git-timestamp:setup-release release:prepare release:perform'
                }
            }
            post {
                success {
                    // Publish the tag
                    sshagent(['github-ssh']) {
                        // using the full url so that we do not care if https checkout used in Jenkins
                        sh 'git push git@github.com:cloudbeers/maven-continuous.git $(cat TAG_NAME.txt)'
                    }
                    // Set the display name to the version so it is easier to see in the UI
                    script { currentBuild.displayName = readFile('VERSION.txt').trim() }

                    // (If using a repository manager with staging support) Close staging repo
                }
                failure {
                    // Remove the local tag as there is no matching remote tag
                    sh 'test -f TAG_NAME.txt && git tag -d $(cat TAG_NAME.txt) && rm -f TAG_NAME.txt || true'

                    // (If using a repository manager with staging support) Drop staging repo
                }
            }
        }
    }
}
