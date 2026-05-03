pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'oithreed/dunoesanchaeg-backend'
        DOCKER_CREDENTIALS_ID = 'dunoesanchaeg-backend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Jar') {
            steps {
                sh '''
                docker run --rm \
                  -v $(pwd):/app \
                  -w /app \
                  maven:3.9.9-eclipse-temurin-21 \
                  mvn clean package -DskipTests
                '''  
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
                sh 'docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS_ID,
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:$BUILD_NUMBER'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }
    }
}
