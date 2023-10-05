pipeline {
    agent any
    environment {
		DOCKERHUB_CREDENTIALS=credentials('svetlnk_docker')
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

        stage("Push Image To Docker Hub") {
            steps {
                withCredentials([string(credentialsId: 'svetlnk-docker', variable: 'svetlnkdocker')]) {
                    bat "docker login --username svetlnk --password ${svetlnkdocker}"
                    bat 'docker push svetlnk/sspr4:latest'
                }
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