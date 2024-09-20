pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root'  // Run as root user to install dependencies
        }
    }
    environment {
        SNYK_TOKEN = credentials('21712836')  // Use the specified Snyk credentials ID
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
        stage('Verify Test Script') {
            steps {
                script {
                    // Check if the test script is defined in package.json
                    def packageJson = readJSON file: 'package.json'
                    if (!packageJson.scripts?.test) {
                        echo "No test script defined in package.json. Skipping the test stage."
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
        stage('Run Tests') {
            when {
                expression {
                    def packageJson = readJSON file: 'package.json'
                    return packageJson.scripts?.test != null
                }
            }
            steps {
                // Run the test script
                sh 'npm test'
            }
        }
        stage('Verify Build Script') {
            steps {
                script {
                    // Check if the build script is defined in package.json
                    def packageJson = readJSON file: 'package.json'
                    if (!packageJson.scripts?.build) {
                        echo "No build script defined in package.json. Skipping the build stage."
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
        stage('Build') {
            when {
                expression {
                    def packageJson = readJSON file: 'package.json'
                    return packageJson.scripts?.build != null
                }
            }
            steps {
                // Build the project
                sh 'npm run build'
            }
        }
        stage('Deploy') {
            steps {
                // Deploy the application (modify the deployment logic as needed)
                echo 'Deploying application...'
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
