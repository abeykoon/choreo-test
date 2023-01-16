import ballerina/http;
import ballerinax/googleapis.gmail;
import ballerina/log;

configurable OAuth2RefreshTokenGrantConfig gmailOAuthConfig = ?;

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

type Email record {
    string recipient;
    string header;
    string message;
};

type Response record {
    string message;
    string id;
};

final gmail:Client gmailClient = check new ({
    auth: {
        clientId: gmailOAuthConfig.clientId,
        clientSecret: gmailOAuthConfig.clientSecret,
        refreshToken: gmailOAuthConfig.refreshToken,
        refreshUrl: gmailOAuthConfig.refreshUrl
    }
});

service / on new http:Listener(9090) {

    resource function post sendemail(@http:Payload Email email) returns Response|error {

        gmail:MessageRequest emailToSend = {
            recipient: email.recipient,
            subject: email.header,
            messageBody: email.message
        };
        gmail:Message sendMessageResp = check gmailClient->sendMessage(emailToSend);
        log:printInfo("Email is sent successfully. Generated ID : " + sendMessageResp.id);
        Response respose =  {
            message:"Email is sent successfully to " + email.recipient,
            id: sendMessageResp.id 
        };
        return respose;
    }
}
