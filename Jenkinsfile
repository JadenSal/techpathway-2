pipeline {
  agent any

  environment {
    AWS_REGION      = 'us-east-2'
    AWS_ACCOUNT_ID  = '208744928440'
    ECR_FRONTEND    = "208744928440.dkr.ecr.us-east-2.amazonaws.com/techpathway-frontend"
    ECR_BACKEND     = "208744928440.dkr.ecr.us-east-2.amazonaws.com/techpathway-backend"
    ECS_CLUSTER     = 'techpathway-cluster'
    ECS_SVC_FRONT   = 'frontend-service'
    ECS_SVC_BACK    = 'backend-service'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('ECR Login') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION \
            | docker login --username AWS --password-stdin \
              $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        '''
      }
    }

    stage('Build Images') {
      parallel {
        stage('Frontend') {
          steps {
            sh 'docker build -t $ECR_FRONTEND:$BUILD_NUMBER -t $ECR_FRONTEND:latest ./frontend'
          }
        }
        stage('Backend') {
          steps {
            sh 'docker build -t $ECR_BACKEND:$BUILD_NUMBER -t $ECR_BACKEND:latest ./backend'
          }
        }
      }
    }

    stage('Push Images') {
      parallel {
        stage('Push Frontend') {
          steps {
            sh '''
              docker push $ECR_FRONTEND:$BUILD_NUMBER
              docker push $ECR_FRONTEND:latest
            '''
          }
        }
        stage('Push Backend') {
          steps {
            sh '''
              docker push $ECR_BACKEND:$BUILD_NUMBER
              docker push $ECR_BACKEND:latest
            '''
          }
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        sh '''
          aws ecs update-service \
            --cluster $ECS_CLUSTER \
            --service $ECS_SVC_FRONT \
            --force-new-deployment \
            --region $AWS_REGION

          aws ecs update-service \
            --cluster $ECS_CLUSTER \
            --service $ECS_SVC_BACK \
            --force-new-deployment \
            --region $AWS_REGION
        '''
      }
    }
  }

  post {
    success { echo 'Pipeline complete — both services deployed!' }
    failure { echo 'Pipeline failed — check logs above.' }
  }
}
