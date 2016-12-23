node ('docker'){
    env.WORKSPACE = pwd()
    echo "${env.WORKSPACE}"
    def centosImg = docker.image('pauldavidgilligan/docker-centos6-puppet-ruby215');
    def pythonImg = docker.image('python:3.5')
    def redisImg = docker.image('redis:latest')
    centosImg.pull()
    pythonImg.pull()
    redisImg.pull()

    docker.withRegistry('http://registry.marathon.l4lb.thisdcos.directory:5000') {
        stage 'Get SCM content'
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/VAdamec/jenkinspipelines.git']]])

        stage 'Build Docker image'
          def appImg = docker.build("jenkinspipeline/app:${env.BUILD_TAG}", 'app/')
          appImg.push();

          def backendImg = docker.build("jenkinspipeline/backend:${env.BUILD_TAG}", 'backend/')
          backendImg.push();

          def testerImg = docker.build("jenkinspipeline/tester:${env.BUILD_TAG}", 'tester/')
          testerImg.push();

        stage 'Integration tests - run composer'
            parallel(firstTask: {
                try {
                        sh "/usr/local/bin/docker-compose up --build -d"
                        TESTER = sh (
                            script: "docker ps | grep tester | cut -f 1 -d ' '",
                            returnStdout: true
                        ).trim()

                        sh "docker exec ${TESTER} python /code/app/sample/app_unit.py"

                        RUN_CURL_TEST = sh (
                            script: 'docker exec ${TESTER} curl -v -H "Content-Type: application/json" -X PUT -d \'{"value":123}\' http://frontend:8080',
                            returnStdout: true
                        ).trim()
                        echo "CURL test output: ${RUN_CURL_TEST}"

                        sh "docker-compose down"
                        currentBuild.result = 'SUCCESS'
                        }
                catch (Exception err) {
                      currentBuild.result = 'FAILURE'
                }
            }, secondTask: {
               sh "echo RUNNING SOME OTHER TEST"
               sh "sleep 10"
            }, thirdTask: {
               sh "echo RUNNING SOME OTHER TEST"
               sh "sleep 10"
            })

    echo "RESULT: ${currentBuild.result}"

        stage name: 'Promote Image to master', concurrency: 3
          appImg.push('master');
          backendImg.push('master');
          testerImg.push('master');

        stage name: 'Deploy newly build images to staging'
          sh "echo RUNPROVISION.sh STG"

        stage name: 'Run staging tests'
          sh "echo RUNTEST.sh STG"

        stage name: 'Deploy newly build images to production - BLUE'
          input message: 'Waiting for approve', ok: 'Approve'
          sh "echo RUNPROVISION.sh PROD BLUE"

        stage name: 'Run production tests - BLUE'
          sh "echo RUNTEST.sh PROD BLUE"

        stage name: 'Run production tests - promote BLUE as a production'
          sh "echo RUNSWITCH.sh PROD BLUE"

        stage name: 'Deploy newly build images to production - GREEN'
          sh "echo RUNPROVISION.sh PROD GREEN"

        stage name: 'Run production tests - GREEN'
          sh "echo RUNTEST.sh PROD GREEN"

        stage name: 'Run production tests - promote GREEN as a production'
          sh "echo RUNSWITCH.sh PROD GREEN"
    }
}
