pipeline {
    agent any

    environment {
        DOCKER_NETWORK = 'project_network'
        DOCKER_IMAGE = 'express-app'
        DOCKER_CONTAINER_NAME = 'express-app-container'
        DOCKER_BUILDKIT = '0' // Disable BuildKit
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
            }
        }

        stage('Setup Network') {
            steps {
                script {
                    sh "docker network create ${DOCKER_NETWORK} || true"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Use docker run to manually manage containers and use the same path mapping
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \\
                        -v ${env.WORKSPACE}:/workspace \\
                        -w /workspace \\
                        node:16 sh -c "npm install"
                    """
                }
            }
        }

        stage('Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'test21712836', variable: 'SNYK_TOKEN')]) {
                    sh '''
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        -e SNYK_TOKEN \
                        node:16 sh -c "npm install -g snyk && snyk auth \$SNYK_TOKEN && snyk test --severity-threshold=high"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "DOCKER_BUILDKIT=0 docker build --network ${DOCKER_NETWORK} -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container if any
                    sh '''
                    if [ $(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then
                        docker stop ${DOCKER_CONTAINER_NAME}
                        docker rm ${DOCKER_CONTAINER_NAME}
                    fi
                    '''
                    sh "docker run --network ${DOCKER_NETWORK} -d -p 8081:8081 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace
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
