## Connector Tests 

This project contains test applications that can be used to test connectors and Choreo functionality. It involves following connectors. 

1. Gmail 
2. Gsheet
3. Github 
4. Hubspot connector 

It also covers following component types in Choreo 

1. github-test --> manual trigger
2. gmail-test --> Choreo service
3. hubspot-connector --> scheduled task 


Following are the instructions to run the tests

### github-test 

Deploy as a **manual trigger**.
Use your github PAT token to configure `gitHubOAuthConfig`. This program will create an issue with given information in pointed repository.

### gmail-test

Deploy as a **service**.
Invoke the service with following payload structure. 
http://localhost:9090/sendemail

```
{
    "recipient":"abc.com",
    "header":"This is a test email",
    "message":"Please ignore and do not reply."
}
```

It will send an email to the specified with specified information. Get gmail tokens following [this](https://docs.google.com/document/d/1wl45tSHrZXLbnvIE3Zh57-2TpoXWxcxVGL7rpAojYus/edit#heading=h.seuclod1jklt) guide. 


### hubspot-connector

Deploy as a **scheduled task**. 
This will read customer information of specified GSheet (first 20 rows) and insert/update them as Hubspot customers. 

* Get Google Sheet tokens : https://docs.google.com/document/d/1wl45tSHrZXLbnvIE3Zh57-2TpoXWxcxVGL7rpAojYus/edit#heading=h.seuclod1jklt
* Get Hubspot creds: https://developers.hubspot.com/docs/api/oauth-quickstart-guide

Spreadsheet should be in this format with headers included. 


| First Name | Last Name | Email           | Telephone    |
| ---------- | --------- | --------------- | ------------ |
| Oliver     | Jake      | jake@wso2.com   | 202-555-0133 |
| Jack       | Connor    | connor@wso2.com | 202-555-0146 |
| Harry      | Callum    | callum@wso2.com | 202-555-0118 |







