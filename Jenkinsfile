pipeline {
    agent {
        docker {
            image 'node:16'  // Use Node 16 as the build agent
            args '-u root --network jenkins_network'  // Run as root and use the custom network for communication
        }
    }
    environment {
        DOCKER_HOST = 'tcp://dind:2376'  // Set Docker host to use the DinD service
        DOCKER_TLS_VERIFY = '0'  // Disable TLS verification
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from the Git repository
                git url: 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample', branch: 'main'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Install project dependencies
                sh 'npm install'
            }
        }
        stage('Build') {
            steps {
                // Build the Node.js application
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                // Run tests for the application
                sh 'npm test'
            }
        }
        stage('Security Scan') {
            steps {
                // Run Snyk security scan for vulnerabilities
                sh 'snyk test'
            }
        }
        stage('Start Application') {
            steps {
                // Start the Node.js application
                sh 'npm start &'
            }
        }
    }
    post {
        always {
            // Actions to always execute after the pipeline finishes, such as cleanup
            echo 'Pipeline finished. Cleaning up...'
        }
        success {
            // Actions to execute when the pipeline completes successfully
            echo 'Pipeline completed successfully!'
        }
        failure {
            // Actions to execute when the pipeline fails
            echo 'Pipeline failed. Please check the logs and resolve any issues.'
        }
    }
}
