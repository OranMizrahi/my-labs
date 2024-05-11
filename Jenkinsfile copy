import groovy.json.JsonSlurper

pipeline {
    agent any

    stages {
        stage('Update Issue') {
            steps {
                script {
                    // Define the issue key
                    def issueKey = 'ci-1'

                    // Define the new status
                    def newStatus = 'Done'

                    // Update status using REST API
                    def transitionId = getTransitionId(issueKey, newStatus)

                    if (transitionId != null) {
                        def response = sh(script: "curl -u jirauser:Strongpassword1 -X POST -H 'Content-Type: application/json' -d '{\"transition\": {\"id\": \"${transitionId}\"}}' http://20.115.55.55:8090/rest/api/2/issue/${issueKey}/transitions", returnStdout: true)
                        println "Response: ${response}"
                    } else {
                        println "Transition ID not found for ${newStatus}."
                    }
                }
            }
        }
    }
}

def getTransitionId(issueKey, statusName) {
    def response = sh(script: "curl -u jirauser:Strongpassword1 -X GET -H 'Content-Type: application/json' http://20.115.55.55:8090/rest/api/2/issue/${issueKey}/transitions", returnStdout: true).trim()
    def jsonSlurper = new JsonSlurper()
    def transitions = jsonSlurper.parseText(response)

    for (transition in transitions.transitions) {
        println "Transition: ${transition}"
        if (transition.to.name == statusName) {
            return transition.id
        }
    }

    return null
}
