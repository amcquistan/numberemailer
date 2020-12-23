# numberemailer

This is a demo project for playing with Segment and SendGrid. The project is a simple static website designed to be hosted in a S3 static website bucket. The website provides the ability to generate a random number and have that random number emailed to a user specified email address.

This project is designed to be used with the following peer projects:

* [numberemailer-sender](https://github.com/amcquistan/numberemailer-sender) is a SAM Python / Flask REST API for posting a random number along with an email address to which the SendGrid Email API is used to sending a random number email.
* [numberemailer-sender](https://github.com/amcquistan/numberemailer-sender) is a SAM Python / Flask REST API for posting a random number along with an email address to which the SendGrid Email API is used to sending a random number email.

## Running Locally

In order for the application to submit AJAX requests and utilize all the proper networked features of a browser this project should be ran locally with a simple local webserver such as [Web Server for Chrome](https://github.com/kzahel/web-server-chrome)

The create_number.html file uses the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch) for POSTing data to a REST API so, you will need to update the URL specified in there to the REST API server running locally or out on the web.

## Deploy to AWS

There are a couple of helper unix scripts in the deploy directory along with CORS configuration and an environment variable file .env.example which will serve as the example of environment variable relied on by the helper scripts.

__Create A Static Website Bucket__

The create-bucket.sh script can be used to create an S3 bucket with the necessary settings and permissions for hosting a static website and relies on the values in a .env file within the deploy directory

```
./deploy/create-bucket.sh
```

Once the S3 Static Website Bucket is created you can use the deploy-s3.sh script to deploy the project to. Do remember to update the REST API url within the create_number.html file.

```
./deploy/deploy-s3.sh
```

This will print out the URL of the site at the conclusion of the deploy-s3.sh script's execution.
