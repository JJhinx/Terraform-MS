pipeline {
    agent any
    stages {
        stage('Setup AWS Credentials') {
            steps {
                withAWS(credentials: 'aws_creds', region: 'eu-west-1') {
                    script {
                        // Run Terraform commands using AWS credentials
                        //sh '''
                            //terraform init
                            //terraform plan -out=tfplan
                            //terraform apply tfplan
                        //'''

                        sh '''
                            terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
