pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root'  // Run as root to install dependencies
        }
    }
    environment {
        // Replace 'snyk-token' with your Jenkins credential ID for the Snyk API token
        SNYK_TOKEN = credentials('21712836')
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from the repository
                git url: 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample.git', branch: 'main'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Security Scan') {
            steps {
                script {
                    sh 'npm install -g snyk'
                    sh 'snyk auth $SNYK_TOKEN'
                    def snykTestResult = sh(script: 'snyk test', returnStatus: true)
//                     if (snykTestResult != 0) {
//                         error "Critical vulnerabilities found! Stopping the pipeline."
//                     }
                }
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Deploy') {
            steps {
                // Deployment steps (customize this part based on your deployment needs)
                echo 'Deploying application...'
            }
        }
    }
    post {
        success {
            // Actions to execute on successful pipeline completion
            echo 'Pipeline completed successfully!'
        }
        failure {
            // Actions to execute on pipeline failure
            echo 'Pipeline failed'
        }
    }
}
