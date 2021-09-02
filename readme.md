# CloudFront course files

## Deploy the initial version

* use the ```start.yml``` and deploy it to CloudFront
* or use this [quick deployment link](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://cloudfront-course.s3.eu-central-1.amazonaws.com/start.yml&stackName=CloudFront-Course-Start)

### Outputs

* ```URL```: The public URL of the webapp. Use this in the browser
* ```FrontendHost```: The hostname of the webapp
* ```BackendHost```: The hostname of the backend (same as the frontend)
* ```BackendPost```: The port of the backend (3000)

## Deploy the end version

* use the ```end.yml``` and deploy it to CloudFront
* or use this [quick deployment link](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://cloudfront-course.s3.eu-central-1.amazonaws.com/end.yml&stackName=CloudFront-Course-End)

### Outputs

* ```CloudFrontURL```: The domain of the CloudFront distribution

## Cleanup

* If you manually created a CloudFront distribution, make sure to delete that first!
* Delete the CloudFront stack using the Console (don't delete the nested stack; that will be removed along the main one)
