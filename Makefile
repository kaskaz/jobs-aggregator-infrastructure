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
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) apply -var='service_type=$(type)' -var-file=$(TERRAFORM_COMMON_VARS)

# Stops local environment
stop:
	@echo "Stopping infrastructure for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) destroy -var='service_type=js' -var-file=$(TERRAFORM_COMMON_VARS)
