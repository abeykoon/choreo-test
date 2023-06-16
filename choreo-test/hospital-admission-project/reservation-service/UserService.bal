import ballerina/http;
import ballerina/log;

type User record {
    string name;
    string address;
    string telephone;
};

service /users on new http:Listener(9090) {
    resource function post .(@http:Payload User user) returns int {
        log:printInfo("Create user for " + user.name);
        return 1;
    }
}
