AWS_PROFILE = mine
STACK_NAME = sam-custom-domain
BUCKET = dabase.com

DOMAINNAME = domaintest.goserverless.sg
ACMCERTIFICATEARN = arn:aws:acm:us-east-1:407461997746:certificate/13c6805d-4c20-426b-b237-f1120dcb8a12
HOSTEDZONEID = Z1LX50EVZWR0DV
SAM = AWS_PROFILE=$(AWS_PROFILE) sam

deploy: packaged.yaml
	$(SAM) deploy --template-file packaged.yaml --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM \
		--parameter-overrides \
			DomainName=$(DOMAINNAME) \
			ACMCertificateArn=$(ACMCERTIFICATEARN) \
			HostedZoneId=$(HOSTEDZONEID) \
		--no-fail-on-empty-changeset

packaged.yaml: validate template.yaml
	$(SAM) package --template-file template.yaml \
		--s3-bucket $(BUCKET) --s3-prefix $(STACK_NAME) \
		--output-template-file packaged.yaml

clean:
	rm -f packaged.yaml

destroy:
	AWS_PROFILE=$(AWS_PROFILE) aws cloudformation delete-stack --stack-name $(STACK_NAME)

test:
	curl https://$(DOMAINNAME)

validate:
	AWS_PROFILE=$(AWS_PROFILE) aws cloudformation validate-template --template-body file://template.yaml
