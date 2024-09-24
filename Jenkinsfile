pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: 'refs/heads/main']],
                    userRemoteConfigs: [[url: 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample.git']]
                ])
            }
        }
        stage('Setup Network') {
            steps {
                sh 'docker network create project_network || true'
            }
        }
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    args '--network project_network'
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build --network project_network -t express-app .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker run --network project_network -d -p 8081:8081 express-app'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
