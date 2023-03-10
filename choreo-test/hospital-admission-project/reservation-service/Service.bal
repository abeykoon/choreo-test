import ballerina/http;
import ballerina/log;

type BookingDetail record {
    string name; 
    string address;
    string telephone;    
};

service /reserve on new http:Listener(9000) {
    resource function post requestReserve(@http:Payload BookingDetail detail) returns int {
        log:printInfo("Reserve request for " + detail.name);
        return 1; //booking reference
    }
}
