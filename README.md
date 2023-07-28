# **AWS Cloud Resume Challenge**

This document captures the steps that were taken to build and host a personal resume website on AWS. This challenge originated from The Cloud Resume Challenge by Forrest Brazeal.

# **Architecture Diagram**
![image](https://github.com/pohwj/aws-crc/assets/118417467/4bcb658a-f01c-4f83-b348-8469e3c254e3)

Services used:
1) S3 Bucket: Stores the HTML, CSS and Javascript file of the static website
2) Route 53: Domain for the static website and directs traffic to Cloudfront
3) AWS Certificate Manager: Set up HTTPS for the website 
4) Cloudfront: Retrieves contents from S3 and serve to end users
5) AWS Lambda: API that receives visits to the website. It updates the visitor count stored in DynamoDB, and display the view count on the website.
6) DynamoDB: Stores the view count to the website
7) Terraform: Infrastructure as Code (Iac) tool that is used to provision S3 bucket, AWS Lambda and DyanmoDB
8) Github Actions: Updates the website and infrastructure automatically when there are changes to the code 

My website: https://resume.woshipwj.click/

