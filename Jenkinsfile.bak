pipeline {
    agent any

    stages {
        stage('credentials') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'e4dd944e-5fef-4109-801c-b478d41af2d7', keyFileVariable: 'SSH_KEY'),
                    string(credentialsId: 'aws_access_key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws_secret_key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'cp "$SSH_KEY" jenkins-aws.pem'
                    sh 'chmod 600 jenkins-aws.pem'
                    // Terraform commands with AWS credentials in environment
                    sh 'terraform plan -var ssh_key_path=jenkins-aws.pem -out=tfplan'
                    sh 'terraform apply tfplan'
                    }
                }
        }
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/JJhinx/Terraform-MS'
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}