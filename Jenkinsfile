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
				bat 'docker build -t svetlnk/sspr4:latest .'
			}
		}
        stage('Test') {
            steps {
				bat 'FOR /F "tokens=*" %%i IN (\'docker ps -a -q\') DO docker stop %%i'
				bat 'docker rm "test_sspr"'
				bat 'docker run -d --name "test_sspr" svetlnk/sspr4:latest bash'
				bat 'docker exec "test_sspr" sh -c "dotnet vstest TestService.dll"'
				bat 'docker stop "test_sspr"'
            }
        }
		stages {
			stage('Check Environment Variables') {
				steps {
					script {
						echo "DOCKERHUB_CREDENTIALS_USR: ${env.DOCKERHUB_CREDENTIALS_USR}"
						echo "DOCKERHUB_CREDENTIALS_PSW: ${env.DOCKERHUB_CREDENTIALS_PSW}"
					}
				}
			}
		}

        stage('Login') {

			steps {
				bat 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				bat 'docker push svetlnk/sspr4:latest'
			}
		}
    }
    post {
		always {
			script {
				node {
					bat 'docker logout'
				}
            }
		}
	}
}