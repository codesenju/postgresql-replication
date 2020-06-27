pipeline {
  agent {
    docker {
      image 'docker:dind-rootless'
      args '-v /var/run/docker.sock:/var/run/docker.sock --privileged'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh '''whoami
pwd
ls
./reset.sh
'''
        sh '''      docker network create mynet
      echo "Created network \'mynet\'"
      docker build -t psql-12/movie-db .'''
        sleep 1
      }
    }

    stage('MasterDB') {
      steps {
        sh '''
        echo "Spinning up master-db container"
        docker run --name master-db -d -p 15432:5432 --net mynet -e POSTGRES_DB=movie -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgres:/var/lib/postgresql/data psql-12/movie-db
        sleep 8
        echo "master-db container running on port 15432"
        
        '''
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
        sh '''
        
        echo "Wait 30 seconds"
sleep 10 && echo "Populating tables with movie data" && sleep 10 && echo "Loading..." && sleep 10
echo "Starting backup"
docker exec master-db /bin/bash -c \'pg_basebackup -h master-db -U replicator -p 5432 -D /tmp/postgresslave -Fp -Xs -P -Rv\' 
sleep 5
docker cp master-db:/tmp/postgresslave /$PWD/ # copy backup data to current directory
        '''
        sleep 5
      }
    }

    stage('SlaveDB') {
      steps {
        sh 'docker run --name slave-db -d -p 15433:5432 -e POSTGRES_DB=movie -e POSTGRES_HOST_AUTH_METHOD=trust -v /$PWD/postgresslave:/var/lib/postgresql/data --net mynet psql-12/movie-db'
        sleep 2
      }
    }

    stage('Test') {
      steps {
        sleep 15
        sh 'docker exec master-db psql -U postgres -c \'select * from pg_stat_replication;\''
        echo 'Complete'
      }
    }

  }
}
