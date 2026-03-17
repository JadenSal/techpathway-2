pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        AWS_ACCOUNT_ID = '208744928440'
        FRONTEND_REPO = 'fullstack-frontend'
        BACKEND_REPO = 'fullstack-backend'
        ECS_CLUSTER = 'fullstack-cluster'
        FRONTEND_SERVICE = 'frontend-service'
        BACKEND_SERVICE = 'backend-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t $FRONTEND_REPO ./frontend'
                sh 'docker build -t $BACKEND_REPO ./backend'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin \
                    $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    docker tag $FRONTEND_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$FRONTEND_REPO:latest
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$FRONTEND_REPO:latest

                    docker tag $BACKEND_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$BACKEND_REPO:latest
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$BACKEND_REPO:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service --cluster $ECS_CLUSTER --service $FRONTEND_SERVICE --force-new-deployment --region $AWS_REGION
                    aws ecs update-service --cluster $ECS_CLUSTER --service $BACKEND_SERVICE --force-new-deployment --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}