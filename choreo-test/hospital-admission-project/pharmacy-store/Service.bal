import ballerina/http;

service /store on new http:Listener(9010) {
    resource function get itemCount(string itemName) returns int {
        return 30;
    }
}
