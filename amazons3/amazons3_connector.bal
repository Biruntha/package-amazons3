// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/http;
import ballerina/time;
import ballerina/crypto;


function AmazonS3Connector::getBucketList() returns BucketList|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string signature;
    string httpMethod;
    string requestURI;
    string host;
    string amazonEndpoint;

    http:Request request = new;

    httpMethod = "GET";
    requestURI = "/";
    host = "s3.amazonaws.com";
    amazonEndpoint = "https://"+host;

    request.setHeader("Host", host);
    request.setHeader("X-Amz-Content-Sha256", "UNSIGNED-PAYLOAD");
    generateSignature(request, "XXXXXXXXXXx", "XXXXXXXXXXX", "us-east-1", httpMethod, requestURI, UNSIGNED_PAYLOAD);

    io:println(request.getHeader(AUTHORIZATION.toLower()));
    io:println(request.getHeader(X_AMZ_DATE.toLower()));

    //request.setHeaders(httpHeaders);

    var httpResponse = clientEndpoint->get("/", message = request);
    io:println(httpResponse);
    match httpResponse {
    error err => {
        amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            var amazonResponse = response.getXmlPayload();
            match amazonResponse {
                error err => {
                    amazonS3Error.message = err.message;
                    return amazonS3Error;
                }
                xml xmlResponse => {
                    BucketList buc ={};
                    return buc;
                }
            }
        }
    }
}
