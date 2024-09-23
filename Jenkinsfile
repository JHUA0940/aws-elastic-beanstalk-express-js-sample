pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample.git'
            }
        }
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    args '--network jenkins_network'  // 确保 Docker 操作在与 `dind` 同一网络
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('Build Docker Image') {
            steps {
                // 构建 Docker 镜像
                sh 'docker build -t express-app .'
            }
        }
        stage('Deploy') {
            steps {
                // 运行 Docker 容器
                sh 'docker run -d -p 8081:8081 express-app'
            }
        }
    }
    post {
        always {
            // 清理工作区
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
