# Jobs Aggregator Infrastructure

This project contains the configuration needed to execute locally and deploy the _Jobs Aggregator_ in the cloud (both demo web application and the backend service).

## Requirements
* Make
* Docker
* Terraform
* Projects on the same folder level
  * jobs-aggregator-infrastructure
  * jobs-aggregator-web-demo
  * jobs-aggregator-service-[js|go|kotlin|python]

Besides the list above, it also requires to rename the file _.env-sample_ to _.env_ and fill the missing values.
Here is a list of values to provide:
  * **JOBS_PROVIDER_REEDCOUK_API_KEY** - For provider _reed.uk.co_ register [here](https://www.reed.co.uk/developers/jobseeker) to get an API key.


### Install Terraform
> brew tap hashicorp/tap

> brew install terraform

Confirm installation by running
> terraform -help

## How to run local

To run the application execute
> make start type=[js|go|kotlin|python]

To stop the application execute
> make stop
