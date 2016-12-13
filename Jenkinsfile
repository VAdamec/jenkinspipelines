node ('docker'){
    env.WORKSPACE = pwd()
    echo "${env.WORKSPACE}"
    def centosImg = docker.image('pauldavidgilligan/docker-centos6-puppet-ruby215');
    def pythonImg = docker.image('python:3.5')
    def redisImg = docker.image('redis:latest')
    centosImg.pull()
    pythonImg.pull()
    redisImg.pull()

    docker.withRegistry('https://swarm.service.dc1.consul:12345') {
        stage 'Mirror'
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/VAdamec/jenkinspipelines.git']]])

        stage 'Build Docker image'
          def appImg = docker.build("jenkinspipeline/app:${env.BUILD_TAG}", 'app/')
          appImg.push();

          def backendImg = docker.build("jenkinspipeline/backend:${env.BUILD_TAG}", 'backend/')
          backendImg.push();

          def testerImg = docker.build("jenkinspipeline/tester:${env.BUILD_TAG}", 'tester/')
          testerImg.push();

        stage 'Test Image'
            sh "docker-compose up"

        stage name: 'Promote Image', concurrency: 1
          appImg.push('master');
          backendImg.push('master');
          testerImg.push('master');
    }
}
