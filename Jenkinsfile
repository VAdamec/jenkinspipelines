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
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/VAdamec/jenkinspipeline']]])

        stage 'Build Docker image'
          def appImg = docker.build("jenkinspipeline/app:${env.BUILD_TAG}", '.')
          appImg.push();

          def backendImg = docker.build("jenkinspipeline/backend:${env.BUILD_TAG}", '.')
          backendImg.push();

          def testerImg = docker.build("jenkinspipeline/tester:${env.BUILD_TAG}", '.')
          testerImg.push();

        stage 'Test Image'
          testerImg.pull()
          testerImg.inside('--privileged -u root') {
            sh 'python app/sample/app_unit.py'
          }

        stage name: 'Promote Image', concurrency: 1
          appImg.push('master');
          backendImg.push('master');
          testerImg.push('master');
    }
}
