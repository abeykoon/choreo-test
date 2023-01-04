import ballerina/io;

configurable int valueYouLike = 3;
configurable string name = ?;

public function main() {
    io:println("Hello " + name + " your prffered value is " + valueYouLike.toString());
}
