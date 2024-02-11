pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_IMAGE_NAME = 'mahithchigurupati/webapp-db'
    }

    tools {
        nodejs 'nodejs'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Semantic Release') {
            steps {
                script {
                    // Install semantic-releases if not already installed
                    sh 'npm install -g semantic-release'
                    // Run semantic-releases
                    sh 'semantic-release setup'
                    // Execute semantic-release to determine the next version
                    def nextVersion = sh(script: 'semantic-release version', returnStdout: true).trim()
                    // Set the DOCKER_TAG environment variable to the next version
                    env.DOCKER_TAG = nextVersion
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-hub-credentials') {
                        docker.image(DOCKER_IMAGE_NAME).push("${DOCKER_TAG}")
                    }
                    
                }

            }
        }

    }

    

    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}


