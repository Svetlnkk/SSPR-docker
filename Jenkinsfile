pipeline {
    agent any
    environment {
		DOCKERHUB_CREDENTIALS=credentials('timovey_docker')
	}
    stages {
        stage('Cloning Git') {
          steps {
              git([url: 'https://github.com/Timovey/SSPR-dotnet.git', branch: 'master'])
          }
        }
        stage('Build') {

			steps {
				sh 'docker build -t timovey/sspr4:latest .'
				sh 'docker run timovey/sspr4:latest'
			}
		}
        stage('Test') {
            steps {
                sh "dotnet vstest TestService.dll"
            }
        }

        stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				sh 'docker push timovey/sspr4:latest'
			}
		}
    }
    post {
		always {
			sh 'docker logout'
		}
	}
}