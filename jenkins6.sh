job('MNTLAB-dbarouka1-main-build-job') {
  description 'The Main job'

  parameters {
    gitParam('BRANCH_NAME') {
      description 'Jenkins task6'
      type 'BRANCH'
      defaultValue 'origin/jenkins6'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Choice from multiple parameters')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["MNTLAB-dbarouka1-child1-build-job", "MNTLAB-dbarouka1-child2-build-job", "MNTLAB-dbarouka1-child3-build-job", "MNTLAB-dbarouka1-child4-build-job"]')
           }
    }
  }
  
  scm {
    git {
      remote {
        url 'https://github.com/Dmitryb1986/build-t00ls-1'
      }
      branch '$BRANCH_NAME'
    }
  }
  steps {
       downstreamParameterized {
               trigger('$Job_name') {
                 block {
                    buildStepFailure('FAILURE')
                    failure('FAILURE')
                    unstable('UNSTABLE')
                 }
                 parameters {
                     currentBuild()
                 }
           }
       }
   }
}
def JOBS = ["MNTLAB-dbarouka1-child1-build-job", "MNTLAB-dbarouka1-child2-build-job", "MNTLAB-dbarouka1-child3-build-job", "MNTLAB-dbarouka1-child4-build-job"]
for(job in JOBS) {


mavenJob(job) {
  description 'Child jobs'
  parameters {
    gitParam('BRANCH_NAME') {
      description 'Jenkins Task6 child jobs'
      type 'BRANCH'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Multiple choice')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["MNTLAB-dbarouka1-child1-build-job", "MNTLAB-dbarouka1-child2-build-job", "MNTLAB-dbarouka1-child3-build-job", "MNTLAB-dbarouka1-child4-build-job"]')
           }
    }
  }  

  scm {
    git {
      remote {
        url 'https://github.com/Dmitryb1986/build-t00ls-1'
      }
      branch '$BRANCH_NAME'
    }
  }

  triggers {
    scm 'H/5 * * * *'
  }

  rootPOM 'home-task/pom.xml'
  goals 'clean install'
  postBuildSteps {
        shell('nohup java -jar home-task/target/hw3-app-1.0.jar com.test >> home-task/target/output.log')
        shell('tar -cvf "$(echo $BRANCH_NAME | cut -d "/" -f 2)_dsl_script.tar.gz" home-task/target/*.jar home-task/target/output.log')
    }
  
  publishers {
        archiveArtifacts('*.tar.gz')
    }
}
}
