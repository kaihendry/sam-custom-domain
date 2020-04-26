AWS_PROFILE = mine
STACK_NAME = sam-custom-domain-http
BUCKET = dabase.com

DOMAINNAME = domainhttptest.goserverless.sg
ACMCERTIFICATEARN = arn:aws:acm:ap-southeast-1:407461997746:certificate/103c4d5b-1309-460e-a0cb-a63a92372e2e
HOSTEDZONEID = Z1LX50EVZWR0DV
SAM = AWS_PROFILE=$(AWS_PROFILE) sam

deploy: packaged.yaml
	$(SAM) deploy --template-file packaged.yaml --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM \
		--parameter-overrides \
			DomainName=$(DOMAINNAME) \
			ACMCertificateArn=$(ACMCERTIFICATEARN) \
			HostedZoneId=$(HOSTEDZONEID) \
		--no-fail-on-empty-changeset

packaged.yaml: template.yaml
	$(SAM) package --template-file template.yaml \
		--s3-bucket $(BUCKET) --s3-prefix $(STACK_NAME) \
		--output-template-file packaged.yaml

clean:
	rm -f packaged.yaml

destroy:
	AWS_PROFILE=$(AWS_PROFILE) aws cloudformation delete-stack --stack-name $(STACK_NAME)

test:
	curl https://$(DOMAINNAME)
