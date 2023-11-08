include .env 

TERRAFORM_FODER_LOCAL := terraform/environments/local
TERRAFORM_COMMON_VARS := ../common.tfvars

check-type:
ifndef type
	${error Provide variable type=[js|go|kotlin|python]}
endif

# Starts local environment
start: check-type
	@echo "Initializing terraform for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) init 
	
	@echo "Initializing infrastructure for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) apply \
		-var-file=$(TERRAFORM_COMMON_VARS) \
		-var='service_type=$(type)' \
		-var='service_jobs_provider_reedcouk_api_key=$(SERVICE_JOBS_PROVIDER_REEDCOUK_API_KEY)'		

# Stops local environment
stop:
	@echo "Stopping infrastructure for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) destroy -var='service_type=js' -var-file=$(TERRAFORM_COMMON_VARS)
