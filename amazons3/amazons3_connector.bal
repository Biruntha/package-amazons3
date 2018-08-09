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

function AmazonS3Connector::getBucketList() returns BucketList|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/";
    host = AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, GET, requestURI, UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint -> get("/", message = request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var amazonResponse = response.getXmlPayload();
            match amazonResponse {
                error err => {
                    amazonS3Error.message = err.message;
                    return amazonS3Error;
                }
                xml xmlResponse => {
                    if (statusCode == 200) {
                        return converTotBucketList(xmlResponse);
                    } else {
                        amazonS3Error.message = xmlResponse["Message"].getTextValue();
                        amazonS3Error.statusCode = statusCode;
                        return amazonS3Error;
                    }
                }
            }
        }
    }
}

function AmazonS3Connector::createBucket() returns Status|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/";
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, PUT, requestURI, UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint-> put("/", request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return convertToStatus(TRUE, statusCode);
            }
            else {
                return convertToStatus(FALSE, statusCode);
            }
        }
    }
}

function AmazonS3Connector::getObjectsInBucket() returns S3ObjectList|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/";
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, GET, requestURI, UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint-> get("/", message = request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var amazonResponse = response.getXmlPayload();
            match amazonResponse {
                error err => {
                    amazonS3Error.message = err.message;
                    return amazonS3Error;
                }
                xml xmlResponse => {
                    if (statusCode == 200) {
                        return convertToS3ObjectList(xmlResponse);
                    }
                    else{
                        amazonS3Error.message = xmlResponse["Message"].getTextValue();
                        amazonS3Error.statusCode = statusCode;
                        return amazonS3Error;
                    }
                }
            }
        }
    }
}

function AmazonS3Connector::getObject(string objectName) returns S3ObjectContent|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/" + objectName;
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, GET, requestURI, UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint-> get(requestURI, message = request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var amazonResponse = response.getPayloadAsString();
            match amazonResponse {
                error err => {
                    amazonS3Error.message = err.message;
                    return amazonS3Error;
                }
                string stringResponse => {
                    if (statusCode == 200) {
                        return convertToS3ObjectContent(stringResponse);
                    }
                    else{
                        amazonS3Error.statusCode = statusCode;
                        return amazonS3Error;
                    }
                }
            }
        }
    }
}

function AmazonS3Connector::createObject(string objectName, string payload) returns Status|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/" + objectName;
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    request.setTextPayload(payload);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, PUT, requestURI, UNSIGNED_PAYLOAD);
    var httpResponse = clientEndpoint-> put(requestURI, request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return convertToStatus(TRUE, statusCode);
            }
            else {
                return convertToStatus(FALSE, statusCode);
            }
        }
    }
}

function AmazonS3Connector::deleteObject(string objectName) returns Status|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/" + objectName;
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, DELETE, requestURI,
        UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint-> delete(requestURI, request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == 204) {
                return convertToStatus(TRUE, statusCode);
            }
            else {
                return convertToStatus(FALSE, statusCode);
            }
        }
    }
}

function AmazonS3Connector::deleteBucket() returns Status|AmazonS3Error {

    endpoint http:Client clientEndpoint = self.clientEndpoint;

    AmazonS3Error amazonS3Error = {};
    string requestURI;
    string host;

    http:Request request = new;
    requestURI = "/";
    host = self.bucketName + "."+ AMAZON_AWS_HOST;

    request.setHeader(HOST, host);
    request.setHeader(X_AMZ_CONTENT_SHA256, UNSIGNED_PAYLOAD);
    generateSignature(request, self.accessKeyId, self.secretAccessKey, self.region, DELETE, requestURI,
        UNSIGNED_PAYLOAD);

    var httpResponse = clientEndpoint-> delete(requestURI, request);
    match httpResponse {
        error err => {
            amazonS3Error.message = err.message;
            return amazonS3Error;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            if (statusCode == 204) {
                return convertToStatus(TRUE, statusCode);
            }
            else {
                return convertToStatus(FALSE, statusCode);
            }
        }
    }
}
