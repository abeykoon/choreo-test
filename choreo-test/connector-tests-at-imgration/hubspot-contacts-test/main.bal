import ballerina/log;
import ballerinax/hubspot.crm.contact as hubspotContact;
import ballerinax/googleapis.sheets as sheets;

// HubSpot configuration parameters
configurable string hubspotAccessToken = ?;
configurable OAuth2RefreshTokenGrantConfig gsheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

type HubSpotErrorDetail record {
    string status?;
    string message;
    string correlationId?;
    string category?;
};

type OAuth2RefreshTokenGrantConfig record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://oauth2.googleapis.com/token";
};

# This will read first 20 rows from specified GSheet and add them as hubspot customers
# + return - Error if operation failed
public function main() returns error? { 

    log:printInfo("Initializing connectors...");

    hubspotContact:Client hubSpotClient = check new hubspotContact:Client({auth: {token: hubspotAccessToken}});
    sheets:Client gSheetClient = check new ({
        auth: {
            clientId: gsheetOAuthConfig.clientId,
            clientSecret: gsheetOAuthConfig.clientSecret,
            refreshToken: gsheetOAuthConfig.refreshToken,
            refreshUrl: gsheetOAuthConfig.refreshUrl

        }
    });

    log:printInfo("Reading customer information from Google sheet...");

    sheets:Range gSheetData = check gSheetClient->getRange(spreadsheetId, worksheetName, "A1:D20");
    string[][] customerData = <string[][]>gSheetData.values;

    foreach string[] customer in customerData {
        hubspotContact:SimplePublicObjectInput contact = {
            properties: {
                "firstname": customer[0],
                "lastname": customer[1],
                "email": customer[2],
                "phone": customer[3]
            }
        };
        hubspotContact:SimplePublicObject|error creationStatus = hubSpotClient->create(contact);
        if creationStatus is hubspotContact:SimplePublicObject {
            log:printInfo(string `New HubSpot contact added successfully!`, contactId = creationStatus.id);
        } else {
            var detail = creationStatus.detail();
            HubSpotErrorDetail errorDetail = check detail.get("body").ensureType();

            if errorDetail.category == "CONFLICT" {
                string existingContactId = extractConactId(errorDetail.message);
                hubspotContact:SimplePublicObject updateStatus = check hubSpotClient->update(existingContactId, contact);
                log:printInfo(string `HubSpot contact updated successfully!`, contactId = updateStatus.id);
            } else {
                log:printError(string `Failed to add/update contact`, creationStatus);
            }
        }
    }

}

function extractConactId(string errorMessage) returns string {
    int lastIndex = errorMessage.lastIndexOf(" ") ?: 0;
    return errorMessage.substring(lastIndex + 1);
}
