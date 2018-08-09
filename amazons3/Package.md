Connects to Amazon S3 from Ballerina. 

# Package Overview

The Amazon S3 connector allows you to access the Amazon S3 REST API through ballerina. The following section provide you the details on connector operations.


**Buckets Operations**

The `kesavan/amazons3` package contains operations that work with buckets. You can list the existing buckets, create a bucket, 
delete a bucket and list objects in a bucket.

**Objects Operations**

The `kesavan/amazons3` package contains operations that create an object, delete an object and retrieve an object. 



## Compatibility
|                    |    Version     |  
|:------------------:|:--------------:|
| Ballerina Language |   0.981.0      |
| Amazon S3 API        |   2006-03-01     |


## Sample

First, import the `kesavan/amazons3` package into the Ballerina project.

```ballerina
import kesavan/amazons3;
```
    
The Amazon S3 connector can be instantiated using the accessKeyId, secretAccessKey, region, 
and bucketName in the Amazon S3 client config.

**Obtaining Access Keys to Run the Sample**

 1. Create a amazon account by visiting <https://aws.amazon.com/s3/>
 2. Obtain the following parameters
   * Access key ID.
   * Secret access key.
   * Desired Server region.
   * Desired bucket name for the operations.


You can now enter the credentials in the Amazon S3 client config:
```ballerina
endpoint amazons3:Client amazonS3Client {
    accessKeyId:"<your_access_key_id>",
    secretAccessKey:"<your_secret_access_key>",
    region:"<your_region>",
    clientConfig:{}
};
```

The `createBucket` function creates a bucket.

   `var createBucketResponse = amazonS3Client -> createBucket();`
   
If the creation was successful, the response from the `createBucket` function is a `Status` object with the success value. If the creation was unsuccessful, the response is a `AmazonS3Error`. The `match` operation can be used to handle the response if an error occurs.

```ballerina
match createBucketResponse {
    amazons3:Status bucketStatus => {
        //If successful, returns the status value as TRUE.
        string status = <string> bucketStatus.success;
        io:println("Bucket Status: " + status);
    }
    //Unsuccessful attempts return a AmazonS3 error.
    amazons3:AmazonS3Error e => io:println(e);
}
```

The `getBucketList` function retrives the existing buckets. It returns a `BucketList` object if successful or `AmazonS3Error` if unsuccessful.

```ballerina
var getBucketListResponse = amazonS3ClientForGetBucketList -> getBucketList();
match getBucketListResponse {
    amazons3:BucketList bucketList => {
        io:println("Owner Id: " + bucketList.owner.id);
        io:println("Name of the first bucket: " + bucketList.buckets[0].name);
    }
    amazons3:AmazonS3Error e => io:println(e);
}
```
## Example
```ballerina
import ballerina/io;
import kesavan/amazons3;

function main(string... args) {
    endpoint amazons3:Client amazonS3Client {
        accessKeyId:"<your_access_key_id>",
        secretAccessKey:"<your_secret_access_key>",
        region:"<your_region>",
        clientConfig:{}
    };
    
    string bucketName = "testBallerina";
    var createBucketResponse = amazonS3Client -> createBucket(bucketName);
    match createBucketResponse {
        amazons3:Status bucketStatus => {
            boolean status = bucketStatus.success;
            io:println("Bucket Status: " + status);
        }
        amazons3:AmazonS3Error e => io:println(e);
    }
    
    var getBucketListResponse = amazonS3Client -> getBucketList();
    match getBucketListResponse {
        amazons3:Bucket[] buckets => {
            io:println("Name of the first bucket: " + buckets[0].name);
        }
        amazons3:AmazonS3Error e => io:println(e);
    }
}
```
