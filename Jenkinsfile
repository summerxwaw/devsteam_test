pipeline {
    agent any
    environment {
        REPO_SLUG = "devsteam_test";
        PROJECT_FLUTTER_VERSION = "2.0.4";
        // Tokens
        DEBUG_BUILD_TOKEN = " -d";
        RELEASE_BUILD_TOKEN = " -r";
        IOS_BUILD_TOKEN = " -i";
        ALL_BUILD_TOKEN = " -a";
        // Telegram settings.
        TELEGRAM_CHAT_ID = "-331920429";
        TELEGRAM_BOT_TOKEN = "1731149363:AAG6K4zj6EoMM4cJQGHX7qPPOKeDQYzDvPs";
        // Routes to .apk files.
        RELEASE_APK_ROUTE = "build/app/outputs/apk/release"
        DEBUG_APK_ROUTE = "build/app/outputs/apk/debug"
        // Routes to images
        SUCCESS_IMAGE = "https://miro.medium.com/max/668/1*FgdvdzDs64rW-1XJkQ-neA.jpeg"
        ERROR_IMAGE = "https://i.stack.imgur.com/9MxWX.png"
        ABORTED_IMAGE = "https://i0.wp.com/blog.mailon.com.ua/wp-content/uploads/2018/03/jenkins_secret.png"
        BUILD_STATUS_TEXT = "Build: ${env.BUILD_NUMBER} status - "
        BUILD_PAGE_TEXT = "\n\nBuild Page: ${env.BUILD_URL}"
        BUILD_LOGS_TEXT = "\n\nBuild logs: ${env.BUILD_URL}/consoleText\n\n\n"
        STATUS_SUCCESS = "SUCCESS!!!"
        STATUS_FAILED = "FAILED!!!"
        STATUS_UNSTABLE = "UNSTABLE!!!"
        STATUS_ABORTED = "ABORTED!!!"
        BITBUCKET_STATUS_SUCCESS = "SUCCESSFUL";
        BITBUCKET_STATUS_FAILED = "FAILED";
        BITBUCKET_STATUS_INPROGRESS = "INPROGRESS";
    }
    stages {
        stage ('Checkout') {
            steps {
                checkout scm
            }
        }
        stage ('Build Android Debug') {
            when {
                expression {env.IS_ANDROID_DEBUG_BUILD == "true" || env.IS_ALL_BUILDS == "true"}
            }
            steps {
                sh "flutter build apk --debug"
                script {
                    sh "mv $DEBUG_APK_ROUTE/app-debug.apk $DEBUG_APK_ROUTE/${env.PROJECT_NAME}-v${env.PROJECT_VERSION}-debug.apk"
                    archiveArtifacts artifacts: "$DEBUG_APK_ROUTE/${env.PROJECT_NAME}-v${env.PROJECT_VERSION}-debug.apk"
                }
            }
        }
        stage ('Build Android Release') {
            steps {
                sh "flutter build apk --release"
                script {
                    sh "mv $RELEASE_APK_ROUTE/app-release.apk $RELEASE_APK_ROUTE/${env.PROJECT_NAME}-v${env.PROJECT_VERSION}-release.apk"
                    archiveArtifacts artifacts: "$RELEASE_APK_ROUTE/${env.PROJECT_NAME}-v${env.PROJECT_VERSION}-release.apk"
                }
            }
        }
    }
    post {
        success {
             echo "Success"
             script {
                      telegramSend(message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})", chatId: TELEGRAM_CHAT_ID)
                }
        }
        aborted {
            echo "Aborted"
            script {
                     telegramSend(message: '${env.PROJECT_NAME} $BUILD_STATUS_TEXT $STATUS_ABORTED ${env.Build_text} $ABORTED_IMAGE', chatId: TELEGRAM_CHAT_ID)
                }
        }
        failure {
            echo "Failure"
            script {
                     telegramSend(message: '${env.PROJECT_NAME} $BUILD_STATUS_TEXT $STATUS_FAILED ${env.Build_text} $ERROR_IMAGE', chatId: TELEGRAM_CHAT_ID)

                }
        }
    }
}
