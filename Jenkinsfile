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
			}
		}
        stage('Test') {
            steps {
				sh 'docker stop $(docker ps -a -q)'
				sh 'docker rm $(docker ps -a -q)'
				sh 'docker run -d --name "test_sspr" timovey/sspr4:latest bash'
				sh 'docker exec "test_sspr" sh -c "dotnet vstest TestService.dll"'
				sh 'docker stop "test_sspr"'
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