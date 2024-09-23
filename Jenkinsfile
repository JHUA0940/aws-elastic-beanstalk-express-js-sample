pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root'  // Run as root user to install dependencies
        }
    }
    environment {
        DOCKER_HOST = 'tcp://dind:2376'        // 设置 Docker 主机为 DinD 服务
        DOCKER_TLS_VERIFY = '0'                // 禁用 TLS 验证
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
        stage('Start Application') {
            steps {
                // Start the Node.js application
                sh 'npm start'
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
