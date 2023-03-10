import ballerina/http;
service /billing on new http:Listener(9000) {
    resource function get billAmount() returns int {
        return 1000;
    }
}
