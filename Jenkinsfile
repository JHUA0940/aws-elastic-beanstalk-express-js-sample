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
                sh 'docker network inspect project_network'
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
                sh 'echo "Checking network connectivity..."'
                sh 'ping -c 3 google.com'
                sh 'npm install'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'echo "Building Docker Image..."'
                sh 'docker build --network project_network -t express-app .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploying Docker Container..."'
                sh 'docker run --network project_network -d -p 8081:8081 express-app'
                sh 'docker ps'
                sh 'docker logs $(docker ps -q -f ancestor=express-app)'
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
