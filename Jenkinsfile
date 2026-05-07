pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: maven
      image: maven:3.9.9-eclipse-temurin-21
      command:
        - cat
      tty: true
    - name: docker
      image: docker:27-cli
      command:
        - cat
      tty: true
      volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
'''
        }
    }

    environment {
        DOCKER_IMAGE = 'oithreed/dunoesanchaeg-backend'
        DOCKER_CREDENTIALS_ID = 'dockerhub-access'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Jar') {
            steps {
                container('maven') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker version'
                    sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
                    sh 'docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('docker') {
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

        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    def imageTag = "${BUILD_NUMBER}"

                    withCredentials([usernamePassword(
                        credentialsId: 'github-access',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_TOKEN'
                    )]) {
                        sh """
                        rm -rf brainwalk-k8s-manifests

                        git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/0lthree/brainwalk-k8s-manifests.git
                        cd brainwalk-k8s-manifests/backend

                        sed -i 's|image: .*|image: oithreed/dunoesanchaeg-backend:${imageTag}|' deployment.yaml

                        git config user.email "jenkins@local"
                        git config user.name "jenkins"

                        git add deployment.yaml
                        git commit -m "Update backend image to ${imageTag}"
                        git push
                        """
                    }
                }
            }
        }
    }
}

// Jenkins 자동 빌드 테스트를 위한 주석
// Jenkins 자동 빌드 테스트를 위한 주석2
// Jenkins 자동 빌드 테스트를 위한 주석3
// Jenkins 자동 빌드 테스트를 위한 주석4