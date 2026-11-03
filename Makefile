.PHONY: fmt validate lint security

fmt:
	terraform fmt -recursive

validate:
	./scripts/validate_modules.sh

lint:
	tflint --init
	tflint --recursive

security:
	./scripts/security_scan.sh
