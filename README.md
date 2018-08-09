# Ballerina Amazon S3 Connector

The Amazon S3 connector allows you to access the Amazon S3 REST API through ballerina. The following section provide you the details on connector operations.

## Compatibility
| Ballerina Language Version | Amazon S3 API version  |
| -------------------------- | -------------------- |
| 0.981.0                    | 2006-03-01                  |


The following sections provide you with information on how to use the Ballerina Amazon S3 connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with Amazon S3 Connector actions](#working-with-amazon-s3-endpoint-actions)
- [Sample](#sample)

### Contribute To develop

Clone the repository by running the following command 
```shell
git clone https://github.com/wso2-ballerina/package-amazons3.git
```

### Working with Amazon S3 Connector 

First, import the `kesavany/amazons3` package into the Ballerina project.

```ballerina
import kesavany/amazons3;
```

In order for you to use the Amazon S3 Connector, first you need to create a AmazonS3 Client endpoint.

```ballerina
endpoint amazons3:Client amazonS3Client {
    accessKeyId:"",
    secretAccessKey:"",
    region:"",
    bucketName:"",
    clientConfig:{}
};
```

##### Sample

```ballerina
import ballerina/io;
import wso2/amazons3;

function main(string... args) {
    endpoint amazons3:Client amazonS3Client {
        accessKeyId:"",
        secretAccessKey:"",
        region:"",
        bucketName:"",
        clientConfig:{}
    };
    string status = "Amazon S3 endpoint test";

    var createBucketResponse = amazonS3Client -> createBucket();
    match createBucketResponse {
        amazons3:Status bucketStatus => {
            //If successful, returns the status value as TRUE.
            string status = <string> bucketStatus.success;
            io:println("Bucket Status: " + status);
        }
        //Unsuccessful attempts return a AmazonS3 error.
        amazons3:AmazonS3Error e => io:println(e);
    }
}
```