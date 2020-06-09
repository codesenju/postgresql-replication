pipeline {
  agent {
    docker {
      image 'postgres'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'docker network create mynet'
        sh 'echo "Created network \'mynet\'"'
        sh 'docker build -t replication/psql .'
      }
    }

  }
}