#!groovy

def repository = "registry.c.test-chamber-13.lan"
def repositoryCreds = "harbor-repository-creds"

def workspace
def dockerFile

def label = "kubernetes-${UUID.randomUUID().toString()}"
def templateName = "pipeline-worker"

pipeline {
    agent {
        kubernetes {
            yaml functions.podYaml(
                repo: repository,
                templateName: templateName,
                kaniko: true,
                alpine: true,
            )
        }
    }

    stages {
        stage ('Initalize Jenkins') {
            steps {
                parallel {
                    stage ('Configure Parameters') {
                        script {
                            workspace = pwd()
                        }
                    }
                    stage ('Install tools in container') {
                        container ('alpine') {
                            script {
                                sh """
                                    if ! command -v curl; then
                                        apk add --no-cache curl
                                    fi
                                    if ! command -v jq; then
                                        apk add --no-cache jq
                                    fi
                                    if ! command -v unzip; then
                                        apk add --no-cache unzip
                                    fi
                                """
                            }
                        }
                    }
                }
            }
        }

        stage ('NordVPN Configs') {
            steps {
                container ('alpine') {
                    script {
                        sh """
                            curl --location --silent --fail https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip -o ${workspace}/files/ovpn.zip
                            mkdir ${workspace}/openvpn
                            unzip ${workspace}/files/ovpn.zip -d ${workspace}/openvpn
                        """
                    }
                }
            }
        }

