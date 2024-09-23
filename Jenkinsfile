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
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    args '--network project_network'  // 使用自定义网络名称
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t express-app .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker run -d -p 8081:8081 express-app'
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
