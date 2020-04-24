STACK_NAME = domaintest
AWS_PROFILE = mine

deploy: packaged.yaml
	sam deploy --template-file packaged.yaml --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM

packaged.yaml: template.yaml
	sam package --template-file template.yaml --s3-bucket dabase.com --s3-prefix $(STACK_NAME) --output-template-file packaged.yaml

clean:
	rm -f packaged.yaml
