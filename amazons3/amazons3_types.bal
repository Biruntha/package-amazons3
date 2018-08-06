//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
//

import ballerina/io;

documentation {
    AmazonS3 Client object
    E{{}}
    F{{amazons3Config}} - AmazonS3 connector configurations
    F{{amazons3Connector}} - AmazonS3 Connector object
}
public type Client object {

    public AmazonS3Configuration amazons3Config = {};
    public AmazonS3Connector amazonS3Connector = new;

    documentation {AmazonS3 connector endpoint initialization function
        P{{config}} - AmazonS3 connector configuration
    }
    public function init(AmazonS3Configuration config);

    documentation {Return the AmazonS3 connector client
        R{{}} - AmazonS3 connector client
    }
    public function getCallerActions() returns AmazonS3Connector;

};

public type AmazonS3Connector object {
    string uri;
    public string accessKeyId;
    public string secretAccessKey;
    public string region;
    public http:Client clientEndpoint = new;

    documentation {
        Retrieve the created buckets.
        P{{bucketList}} - The list of buckets.
        R{{}} - If success, returns BucketList object, else returns AmazonS3Error object.}
    public function getBucketList() returns BucketList|AmazonS3Error;

};

public type AmazonS3Configuration record {
    string uri;
    string accessKeyId;
    string secretAccessKey;
    string region;
    http:ClientEndpointConfig clientConfig = {};
};

public type BucketList record {
    string Name;
    string creationDate;
};

public type AmazonS3Error record {
    string message;
    error? cause;
    int statusCode;
};