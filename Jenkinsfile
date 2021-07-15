
pipeline {
    agent any

     environment {
        AWS_ACCESS_KEY_ID     = credentials('Access_Key_ID')
        AWS_SECRET_ACCESS_KEY = credentials('Secret_Access_Key')
        TF_VAR_SSH_KEY        = credentials('SSH_KEY')
    }

    stages {
        stage('terraform init') {
            steps {
               
                sh 'terraform init'
            }
        }

        stage('terraform plan') {
            steps {
               
                sh 'terraform plan'     
            }
        }
        
        stage('terraform apply') {
            steps {
               
                sh 'terraform apply -auto-approve'     
            }
        }
    }
}
