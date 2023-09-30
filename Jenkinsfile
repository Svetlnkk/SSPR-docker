pipeline {
    agent any
    environment {
		DOCKERHUB_CREDENTIALS=credentials('svetlnk')
	}
    stages {
        stage('Cloning Git') {
          steps {
              git([url: 'https://github.com/Svetlnkk/SSPR-docker.git', branch: 'master'])
          }
        }
        stage('Build') {

			steps {
				sh 'docker build -t svetlnk/sspr4:latest .'
			}
		}
        stage('Test') {
            steps {
				sh 'docker stop $(docker ps -a -q)'
				sh 'docker rm $(docker ps -a -q)'
				sh 'docker run -d --name "test_sspr" svetlnk/sspr4:latest bash'
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
				sh 'docker push svetlnk/sspr4:latest'
			}
		}
    }
    post {
		always {
			sh 'docker logout'
		}
	}
}