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
                sh 'ls -la' // List directory structure to ensure package.json exists
            }
        }

        stage('Setup Network') {
            steps {
                script {
                    // Create network if it doesn't exist
                    sh "docker network create ${DOCKER_NETWORK} || true"
                    // Inspect network to ensure it's created
                    sh "docker network inspect ${DOCKER_NETWORK}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo "Jenkins workspace: ${env.WORKSPACE}"
                    // Install project dependencies
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${env.WORKSPACE}:/workspace \
                        -w /workspace \
                        node:16 sh -c "npm install"
                    """
                }
            }
        }

        stage('Security Scan') {
            steps {
                script {
                    echo "Running Snyk Security Scan..."
                    // Install Snyk CLI
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${env.WORKSPACE}:/workspace \
                        -w /workspace \
                        node:16 sh -c "npm install -g snyk"
                    """
                    // Run Snyk test without authentication
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${env.WORKSPACE}:/workspace \
                        -w /workspace \
                        node:16 sh -c "snyk test --severity-threshold=high"
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image..."
                    sh "DOCKER_BUILDKIT=0 docker build --network ${DOCKER_NETWORK} -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container if it exists
                    sh '''
                    if [ $(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then
                        docker stop ${DOCKER_CONTAINER_NAME}
                        docker rm ${DOCKER_CONTAINER_NAME}
                    fi
                    '''
                    // Run new Docker container with specified name
                    sh "docker run --network ${DOCKER_NETWORK} -d -p 8081:8081 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}"
                    // Check container status
                    sh 'docker ps'
                    // View container logs
                    sh "docker logs ${DOCKER_CONTAINER_NAME}"
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
