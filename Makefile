.PHONY: all
all: down up

.PHONY: up
up:
	terraform init
	terraform apply -var-file=test.tfvars -auto-approve
	cat /tmp/terraform-output.json | jq .

#| jq .

.PHONY: down
down:
	-terraform destroy -var-file=test.tfvars -auto-approve

.PHONY: clean
clean: down
clean:
	-rm /tmp/terraform-output.json
	-rm terraform.*
	-rm -rf .terraform*

console:
	terraform console -var-file=test.tfvars
