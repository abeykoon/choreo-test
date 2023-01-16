import ballerinax/github;
import ballerina/log;

@display {
    label: "Repository",
    description: "Repositoy to create the issue"
}
configurable string repository = ?;

@display {
    label: "Owner",
    description: "Repositoy owner"
}
configurable string repositoryOwner = ?;

configurable string gitHubOAuthConfig = ?;

github:Client githubClient = check new ({
    auth: {
        token: gitHubOAuthConfig
    }
});

public function main() returns error? {
    github:CreateIssueInput issueDetail = {
        title: "[Task] Upgade Ballerina version at Choreo",
        body: "Update to next version"
    };
    github:Issue issue = check githubClient->createIssue(issueDetail, repositoryOwner, repository);
    log:printInfo("Issue is created with ID = " + issue.number.toString());
}
