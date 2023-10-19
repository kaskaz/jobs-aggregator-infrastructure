TERRAFORM_FODER_LOCAL := terraform/environments/local

check-type:
ifndef type
	${error Provide variable type=[js|go|kotlin|python]}
endif

set-service:
ifeq ($(type), js)
SERVICE=service-js
else
SERVICE=service-js
endif

# Starts local environment
start: check-type set-service
	@echo "Initializing terraform for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) init 
	
	@echo "Initializing infrastructure for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) apply

# Stops local environment
stop:
	@echo "Stopping infrastructure for local environment"
	terraform -chdir=$(TERRAFORM_FODER_LOCAL) destroy
