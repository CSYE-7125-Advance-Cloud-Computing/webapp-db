pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_IMAGE_NAME = 'mahithchigurupati/webapp-db'
        GITHUB_TOKEN = 'GITHUB-TOKEN'
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
                    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GH_TOKEN')]) {
                        sh "npx semantic-release"
                    }
                    
                    LATEST_TAG = sh(script: 'git describe --tags --abbrev=0', returnStdout: true).trim()
                }
            }                    
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:${LATEST_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'DOCKERHUB_CREDENTIALS') {
                        docker.image(DOCKER_IMAGE_NAME).push("${LATEST_TAG}")
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
