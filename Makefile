.PHONY: up
up:
	terraform init
	terraform apply -var-file=test.tfvars -auto-approve
	cat /tmp/terraform-output.json

.PHONY: down
down:
	terraform destroy -var-file=test.tfvars -auto-approve

.PHONY: clean
clean: down
clean:
	rm terraform.*
	rm -rf .terraform*
