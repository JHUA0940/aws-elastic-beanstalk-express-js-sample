pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                // 拉取代码
                git 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                // 安装项目依赖项
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
            // 构建成功提示
            echo 'Pipeline succeeded!'
        }
        failure {
            // 构建失败提示
            echo 'Pipeline failed!'
        }
    }
}
