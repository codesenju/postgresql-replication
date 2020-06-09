pipeline {
  agent {
    node {
      label 'host'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh './reset.sh && docker network create mynet && docker pull codesenju/replication-psql:1.0'
        sh 'docker tag codesenju/replication-psql:1.0 replication/psql'
      }
    }

    stage('MasterDB') {
      steps {
        sh 'docker run --name master-db -d -p 15432:5432 --net mynet -e POSTGRES_DB=mydb -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgres:/var/lib/postgresql/data replication/psql'
      }
    }

    stage('Verify MasterDB') {
      steps {
        sleep 20
        sh 'docker logs master-db'
      }
    }

    stage('Backup') {
      steps {
        sh 'docker exec -it master-db /bin/bash -c \'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv\' '
        sleep 10
        sh 'docker cp master-db:/tmp/postgresslave /$PWD/'
      }
    }

    stage('SlaveDB') {
      steps {
        sh '''docker run --name slave-db -d -p 15433:5432 --net mynet -e POSTGRES_DB=mydb -e POSTGRES_HOST_AUTH_METHOD=trust
-v /$PWD/postgresslave:/var/lib/postgresql/data replication/psql'''
      }
    }

    stage('Test') {
      steps {
        sleep 10
        sh 'docker exec -it master-db psql -U postgres -c \'select * from pg_stat_replication;\''
        echo 'Complete'
        cleanWs(cleanWhenFailure: true, cleanWhenAborted: true)
      }
    }

  }
}