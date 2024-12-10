pipeline {
    agent any

    stages {
        stage('credentials') {
            steps {
                withCredentials([sshUserPrivateKey(
                credentialsId: '3a643f94-65c9-421a-905a-93a12cfca59e',
                keyFileVariable: 'SSH_KEY')]){
                sh 'cp "$SSH_KEY" jenkins-aws.pem'
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