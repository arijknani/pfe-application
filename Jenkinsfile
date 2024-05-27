
@Library('deploy-openshift-library') _
def config = [openshift_project: 'arij-project', app_name: 'my-app-library', quay_repo: 'arijknani', image_name:'my-app-library' ]
pipeline {    
    agent {
        kubernetes {
            inheritFrom 'buildah' 
        }
    }
    environment { 
        repo_url= 'https://github.com/arijknani/containerized-app.git'
        quay_repo= 'arijknani'
        image_name= 'my-app-library'
        QUAY_CREDS= credentials('quay_creds')
        openshift_url= 'https://api.ocp.smartek.ae:6443'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        durabilityHint('PERFORMANCE_OPTIMIZED')
        disableConcurrentBuilds()
    }
    
    stages {
        stage('Build with Buildah') {
            steps {
                container('buildah') {
                    sh "buildah build --storage-driver=vfs -t quay.io/${quay_repo}/${image_name} -f Dockerfile ."
                    sh "echo ${QUAY_CREDS_PSW} | buildah login -u ${QUAY_CREDS_USR} --password-stdin quay.io"
                    sh "buildah push --storage-driver=vfs quay.io/${quay_repo}/${image_name}"
                }
            }
        }
        stage('deployment') {
            steps {
                script {
                    wrap([$class: 'OpenShiftBuildWrapper',  
                          installation: 'oc', 
                          url: "${openshift_url}", 
                          insecure: true, 
                          credentialsId: 'sa_token']) { 
                          deployOpenshift(config)
                    }
                }
            }
        }
    }
    post {
        always {
            container('buildah') {
                sh "buildah logout quay.io"
            }
        }
    }
}
