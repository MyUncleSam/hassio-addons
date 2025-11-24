properties(
    [
        githubProjectProperty(
            displayName: 'hassio-addons',
            projectUrlStr: 'https://github.com/ruepp-jenkins/hassio-addons/'
        ),
        disableConcurrentBuilds(abortPrevious: true)
    ]
)

pipeline {
    agent any

    triggers {
        cron('0 3 * * *')  // Run daily at 3:00 AM
    }

    stages {
        stage('Pre Cleanup') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                git branch: env.BRANCH_NAME,
                    credentialsId: 'ruepp-jenkins',
                    url: env.GIT_URL
            }
        }
        stage('Check Addons') {
            steps {
                script {
                    // Define addon mappings: [docker-image: addon-folder]
                    def addons = [
                        'internxt/webdav': 'internxt-webdav'
                    ]

                    // Use credentials for git operations
                    withCredentials([usernamePassword(credentialsId: 'ruepp-jenkins', usernameVariable: 'GIT_EMAIL', passwordVariable: 'GIT_TOKEN')]) {
                        // Configure git with credentials and identity
                        sh '''
                            git config --global user.email "${GIT_EMAIL}"
                            git config --global user.name "Jenkins CI"
                            git config --global credential.helper store
                            echo "https://${GIT_EMAIL}:${GIT_TOKEN}@github.com" > ~/.git-credentials
                        '''

                        // Loop through each addon
                        addons.each { dockerImage, addonFolder ->
                            stage("Check: ${addonFolder}") {
                                echo "Checking ${addonFolder} for updates (${dockerImage})..."
                                sh "scripts/update-addon-version.sh \"${dockerImage}\" \"${addonFolder}\""
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            discordSend result: currentBuild.currentResult,
                description: env.GIT_URL,
                link: env.BUILD_URL,
                title: JOB_NAME,
                webhookURL: DISCORD_WEBHOOK
        }
    }
}