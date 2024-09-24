pipeline {
    agent any

    options {
        // Set log retention policy to keep the latest 30 builds and artifacts
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
    }

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
                    // Redirect output to log file
                    sh "docker network create ${DOCKER_NETWORK} || true > setup-network.log 2>&1"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Use verbose mode to install dependencies and redirect output to log file
                    sh """
                    docker run --rm --network ${DOCKER_NETWORK} \\
                        -v ${env.WORKSPACE}:/workspace \\
                        -w /workspace \\
                        node:16 sh -c "npm install --verbose" > install-dependencies.log 2>&1
                    """
                }
            }
        }

        stage('Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'test21712836', variable: 'SNYK_TOKEN')]) {
                    // Perform security scan in debug mode and redirect output to log file
                    sh '''
                    docker run --rm --network ${DOCKER_NETWORK} \
                        -v ${WORKSPACE}:/workspace \
                        -w /workspace \
                        -e SNYK_TOKEN \
                        node:16 sh -c "npm install -g snyk && snyk auth $SNYK_TOKEN && snyk test --severity-threshold=high --debug" > security-scan.log 2>&1
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with detailed output, redirecting to log file
                    sh "DOCKER_BUILDKIT=0 docker build --network ${DOCKER_NETWORK} --progress=plain -t ${DOCKER_IMAGE} . > build-docker-image.log 2>&1"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container, redirect output to log file
                    sh '''
                    {
                        if [ $(docker ps -q -f name=${DOCKER_CONTAINER_NAME}) ]; then
                            docker stop ${DOCKER_CONTAINER_NAME}
                            docker rm ${DOCKER_CONTAINER_NAME}
                        fi
                        docker run --network ${DOCKER_NETWORK} -d -p 8081:8081 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}
                    } > deploy.log 2>&1
                    '''
                }
            }
        }
    }

    post {
        always {
            // Archive log files for viewing in Jenkins
            archiveArtifacts artifacts: '*.log', fingerprint: true
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
