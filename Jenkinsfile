pipeline {
    agent any
    stages {
        stage('Setup AWS Credentials') {
            steps {
                withAWS(credentials: 'aws_credentials_id', region: 'us-west-2') {
                    script {
                        // Run Terraform commands using AWS credentials
                        sh '''
                            terraform init
                            terraform plan -out=tfplan
                            terraform apply tfplan
                        '''
                    }
                }
            }
        }
    }
}
