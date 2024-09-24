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
                // 如果网络已存在，不会报错
                sh 'docker network create project_network || true'
                // 检查网络是否创建成功
                sh 'docker network inspect project_network'
            }
        }

        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    // 合并所有 args 参数，使用一个字符串传递
                    args '-u root --network project_network'
                }
            }
            steps {
                // 网络连接性检查
                sh 'echo "Checking network connectivity..."'
                sh 'ping -c 3 google.com'
                // 安装依赖
                sh 'npm install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'echo "Building Docker Image..."'
                // 构建 Docker 镜像，指定 Dockerfile 路径（如有需要）
                sh 'docker build --network project_network -t express-app .'
            }
        }

        stage('Deploy') {
            steps {
                // 先停止并移除可能存在的旧容器
                sh '''
                if [ $(docker ps -q -f name=express-app) ]; then
                    docker stop express-app
                    docker rm express-app
                fi
                '''
                // 启动新的 Docker 容器，并为容器指定名称
                sh 'docker run --network project_network -d -p 8081:8081 --name express-app express-app'
                // 检查容器状态
                sh 'docker ps'
                // 查看容器日志
                sh 'docker logs express-app'
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
