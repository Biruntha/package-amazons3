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

function converTotBuckets(xml response) returns Bucket[] {
    Bucket[] buckets;
    xml bucketsDetails = response["Buckets"];
    foreach i, b in bucketsDetails.*.elements(){
        xml bucketDetails = b.elements();
        Bucket bucket = {};
        bucket.name = bucketDetails["Name"].getTextValue();
        bucket.creationDate = bucketDetails["CreationDate"].getTextValue();
        buckets[i]= bucket;

    }
    return buckets;
}

function convertToS3ObjectList(xml response) returns S3ObjectList {
    S3ObjectList s3ObjectList = {};
    S3Object[] s3Objects;
    s3ObjectList.name = response["Name"].getTextValue();
    s3ObjectList.prefix = response["Prefix"].getTextValue();
    s3ObjectList.marker = response["Marker"].getTextValue();
    s3ObjectList.maxKeys = response["MaxKeys"].getTextValue();
    s3ObjectList.isTruncated = response["IsTruncated"].getTextValue();
    xml contents = response["Contents"];

    foreach i, c in contents {
        xml content = c.elements();
        S3Object s3Object = {};
        s3Object.key = content["Key"].getTextValue();
        s3Object.lastModified = content["LastModified"].getTextValue();
        s3Object.eTag = content["ETag"].getTextValue();
        s3Object.size = content["Size"].getTextValue();
        s3Object.ownerId = content["Owner"]["ID"].getTextValue();
        s3Object.ownerDisplayName = content["Owner"]["DisplayName"].getTextValue();
        s3Object.storageClass = content["StorageClass"].getTextValue();
        s3Objects[i] = s3Object;
    }
    s3ObjectList.s3Objects = s3Objects;
    return s3ObjectList;
}

function convertToStatus(int statusCode) returns Status {
    Status s = {};
    s.statusCode = statusCode;
    if (statusCode == 200 || statusCode == 204){
        s.success = true;
    }
    else {
        s.success = false;
    }
    return s;
}

function convertToS3ObjectContent(string response) returns S3ObjectContent {
    S3ObjectContent objectContent = {};
    objectContent.content =  response;
    return objectContent;
}
