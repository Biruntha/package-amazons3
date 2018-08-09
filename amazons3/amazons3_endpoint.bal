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

import ballerina/http;
import ballerina/io;

function Client::init(AmazonS3Configuration config) {
    self.amazonS3Connector.bucketName = config.bucketName;
    self.amazonS3Connector.accessKeyId = config.accessKeyId;
    self.amazonS3Connector.secretAccessKey = config.secretAccessKey;
    self.amazonS3Connector.region = config.region;
    if (self.amazonS3Connector.bucketName != "" ){
        config.clientConfig.url = HTTPS +self.amazonS3Connector.bucketName + "." + AMAZON_AWS_HOST;
    }
    else {
        config.clientConfig.url = HTTPS + AMAZON_AWS_HOST;
    }
    self.amazonS3Connector.clientEndpoint.init(config.clientConfig);
}

function Client::getCallerActions() returns AmazonS3Connector {
    return self.amazonS3Connector;
}
