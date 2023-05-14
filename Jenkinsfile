pipeline {
    agent any
    stages {
        stage('Checkout SCM'){
            steps {
                echo 'checkout from SCM'
            }
        }
        stage('Build') {
            steps {
                sh '''
                    terraform init
                    terraform apply --auto-approve
                '''
            }
        }
    }
}