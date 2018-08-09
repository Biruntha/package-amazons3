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

documentation {
    Define the Amazon S3 connector.
    F{{accessKeyId}} - The access key is of the Amazon S3 account.
    F{{secretAccessKey}} - The secret access key of the Amazon S3 account.
    F{{region}} - The AWS Region.
}
public type AmazonS3Connector object {
    public string accessKeyId;
    public string secretAccessKey;
    public string region;

    documentation {
        Retrieve the existing buckets.
        R{{}} - If success, returns BucketList object, else returns AmazonS3Error object.
    }
    public function getBucketList() returns BucketList|AmazonS3Error;

    documentation {
        Create a bucket.
        R{{}} - If success, returns Status object, else returns AmazonS3Error object.
    }
    public function createBucket(string bucketName) returns Status|AmazonS3Error;

    documentation {
        Retrieve the existing objects in a given bucket.
        R{{}} - If success, returns S3ObjectList object, else returns AmazonS3Error object.
    }
    public function getAllObjects(string bucketName) returns S3ObjectList|AmazonS3Error;

    documentation {
        Retrieve the existing buckets.
        P{{objectName}} - The name of the object.
        R{{}} - If success, returns S3ObjectContent object, else returns AmazonS3Error object.
    }
    public function getObject(string bucketName, string objectName) returns S3ObjectContent|AmazonS3Error;

    documentation {
        Create an object.
        P{{objectName}} - The name of the object.
        P{{payload}} - The file that needed to be added to the bucket.
        R{{}} - If success, returns Status object, else returns AmazonS3Error object.
    }
    public function createObject(string bucketName, string objectName, string payload) returns Status|AmazonS3Error;

    documentation {
        Delete an object.
        P{{objectName}} - The name of the object.
        R{{}} - If success, returns Status object, else returns AmazonS3Error object.
    }
    public function deleteObject(string bucketName, string objectName) returns Status|AmazonS3Error;

    documentation {
        Delete a bucket.
        R{{}} - If success, returns Status object, else returns AmazonS3Error object.
    }
    public function deleteBucket(string bucketName) returns Status|AmazonS3Error;
};

documentation {
    AmazonS3 Client object
    E{{}}
    F{{amazonS3Config}} - AmazonS3 connector configurations.
    F{{amazonS3Connector}} - AmazonS3 Connector object.
}
public type Client object {

    public AmazonS3Configuration amazonS3Config = {};
    public AmazonS3Connector amazonS3Connector = new;

    documentation {
    AmazonS3 connector endpoint initialization function.
        P{{config}} - AmazonS3 connector configuration.
    }
    public function init(AmazonS3Configuration config);

    documentation {
    Return the AmazonS3 connector client.
        R{{}} - AmazonS3 connector client.
    }
    public function getCallerActions() returns AmazonS3Connector;

};

documentation {
    AmazonS3 connector configurations can be setup here
    F{{accessKeyId}} - The access key is of the Amazon S3 account.
    F{{secretAccessKey}} - The secret access key of the Amazon S3 account.
    F{{region}} - The AWS Region.
}
public type AmazonS3Configuration record {
    string accessKeyId;
    string secretAccessKey;
    string region;
};

documentation {
    Define the bucket list type.
    F{{owner}} - The owner type.
    F{{buckets}} - The array of bucket type.
}
public type BucketList record {
    Owner owner;
    Bucket[] buckets;
};

documentation {
    Define the bucket type.
    F{{name}} - The name of the bucket.
    F{{creationDate}} - The creation date of the bucket.
}
public type Bucket record {
    string name;
    string creationDate;
};

documentation {
    Define the s3objectlist type.
    F{{name}} - The name of the bucket.
    F{{prefix}} - The string to limits the response to keys that begin with the specified prefix.
    F{{marker}} - The key to start with when listing objects in a bucket.
    F{{maxKeys}} - The maximum number of keys returned in the response body.
    F{{isTruncated}} - The creation date of the bucket.
    F{{s3Objects}} - The array of objects.
}
public type S3ObjectList record {
    string name;
    string prefix;
    string marker;
    string maxKeys;
    string isTruncated;
    S3Object[] s3Objects;
};

documentation {
    Define the S3Object type.
    F{{key}} - The name of the object.
    F{{lastModified}} - The last modified date of the object.
    F{{eTag}} - The etag of the object.
    F{{size}} - The size of the object.
    F{{ownerId}} - The id of the object owner.
    F{{ownerDisplayName}} - The display name of the object owner.
    F{{storageClass}} - The storage class of the object.
}
public type S3Object record {
    string key;
    string lastModified;
    string eTag;
    string size;
    string ownerId;
    string ownerDisplayName;
    string storageClass;
};

documentation {
    Define the owner type.
    F{{id}} - The id of the owner.
    F{{displayName}} - The display name of the owner.
}
public type Owner record {
    string id;
    string displayName;
};

documentation {
    Define the status type.
    F{{success}} - The status of the AmazonS3 operation.
    F{{statusCode}} - The status code of the response.
}
public type Status record {
    string success;
    int statusCode;
};

documentation {
    Define the S3ObjectContent type.
    F{{content}} - The content of the object.
}
public type S3ObjectContent record {
    string content;
};

documentation {
    AmazonS3 Client Error.
    F{{message}} - Error message of the response.
    F{{cause}} - The error which caused the AmazonS3 error.
    F{{statusCode}} - Status code of the response.
}
public type AmazonS3Error record {
    string message;
    error? cause;
    int statusCode;
};
