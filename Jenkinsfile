pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root --network jenkins_network'  // 使用 root 用户，并将代理连接到 jenkins_network 网络
        }
    }
    stages {
        stage('Checkout') {
            steps {
                // 从 Git 仓库检出代码
                git url: 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample', branch: 'main'
            }
        }
        stage('Install Dependencies') {
            steps {
                // 安装项目依赖项
                sh 'npm install'
            }
        }
        stage('Start Application') {
            steps {
                // 启动 Node.js 应用
                sh 'npm start'
            }
        }
    }
    post {
        always {
            // 管道结束时始终执行的操作，例如清理
            echo 'Pipeline finished. Cleaning up...'
        }
        success {
            // 当管道成功完成时执行的操作
            echo 'Pipeline completed successfully!'
        }
        failure {
            // 当管道失败时执行的操作
            echo 'Pipeline failed. Please check the logs and resolve any issues.'
        }
    }
}
