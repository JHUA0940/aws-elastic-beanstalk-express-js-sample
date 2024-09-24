pipeline {
    agent any

    environment {
        DOCKER_NETWORK = 'project_network'
        DOCKER_IMAGE = 'express-app'
        DOCKER_CONTAINER_NAME = 'express-app-container'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                        branches: [[name: 'refs/heads/main']],
                        userRemoteConfigs: [[url: 'https://github.com/JHUA0940/aws-elastic-beanstalk-express-js-sample.git']]
                    ])
                }
                sh 'ls -la' // 查看目录结构，确保 package.json 存在
            }
        }

        stage('Setup Network') {
            steps {
                script {
                    // 如果网络已存在，不会报错
                    sh "docker network create ${DOCKER_NETWORK} || true"
                    // 检查网络是否创建成功
                    sh "docker network inspect ${DOCKER_NETWORK}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // 打印当前 Jenkins 工作空间路径，便于调试
                    echo "Jenkins workspace: ${env.WORKSPACE}"

                    // 使用 docker run 手动管理容器，并使用相同的路径映射
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${env.WORKSPACE}:/workspace \
                        -w /workspace \
                        node:16 sh -c "npm install"
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image..."
                    // 构建 Docker 镜像，指定 Dockerfile 路径（如有需要）
                    sh "docker build --network ${DOCKER_NETWORK} -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // 先停止并移除可能存在的旧容器
                    sh '''
                    if [ $(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then
                        docker stop ${DOCKER_CONTAINER_NAME}
                        docker rm ${DOCKER_CONTAINER_NAME}
                    fi
                    '''
                    // 启动新的 Docker 容器，并为容器指定名称
                    sh "docker run --network ${DOCKER_NETWORK} -d -p 8081:8081 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}"
                    // 检查容器状态
                    sh 'docker ps'
                    // 查看容器日志
                    sh "docker logs ${DOCKER_CONTAINER_NAME}"
                }
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
