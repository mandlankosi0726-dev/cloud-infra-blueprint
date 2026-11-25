.PHONY: fmt validate lint security ansible-install ansible-inventory ansible-check ansible-lint

fmt:
	terraform fmt -recursive

validate:
	./scripts/validate_modules.sh

lint:
	tflint --init
	tflint --recursive

security:
	./scripts/security_scan.sh

ansible-install:
	ansible-galaxy collection install -r ansible/requirements.yml

ansible-inventory:
	ANSIBLE_CONFIG=ansible/ansible.cfg ansible-inventory -i ansible/inventories/aws_ec2.yml --graph

ansible-check:
	ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ansible/inventories/aws_ec2.yml ansible/playbooks/site.yml --check --diff $(ANSIBLE_ARGS)

ansible-lint:
	ANSIBLE_CONFIG=ansible/ansible.cfg ansible-lint ansible/playbooks/site.yml ansible/roles
