pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        CI = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run BDD Tests') {
            steps {
                sh '''
                    if [ "$(uname)" = "Darwin" ]; then
                      export JAVA_HOME=$(/usr/libexec/java_home -v 24 2>/dev/null || /usr/libexec/java_home)
                      export PATH="/opt/homebrew/bin:$JAVA_HOME/bin:$PATH"
                    else
                      export PATH="/usr/local/bin:$PATH"
                    fi
                    mvn test -s maven-settings-central.xml -B --no-transfer-progress
                '''
            }
        }
    }

    post {
        always {
            junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true

            archiveArtifacts(
                artifacts: 'target/cucumber-reports.html',
                fingerprint: true,
                allowEmptyArchive: true
            )

            archiveArtifacts(
                artifacts: 'target/allure-results/**',
                fingerprint: true,
                allowEmptyArchive: true
            )
        }
        success {
            echo 'All BDD scenarios passed.'
        }
        failure {
            echo 'BDD tests failed — check Allure and console logs.'
        }
    }
}
