#!/usr/bin/make -f

SAM_DEPLOY_OPTIONS+=--no-fail-on-empty-changeset --no-progressbar
AWS_REGION?=eu-west-1
STACK_NAME?=agw-to-alb
SAM_BUCKET?=${STACK_NAME}-sam-bucket

IMAGE_LAMBDA_PATH=./image_lambda
FRONTEND_LAMBDA_PATH=./frontend_lambda
API_LAMBDA_PATH=./api_lambda

# Build Lambda functions
build-lambdas: build-image-lambda build-frontend-lambda build-api-lambda
build-image-lambda:
	(cd ${IMAGE_LAMBDA_PATH} && go mod init image_lambda || true \
	&& go get github.com/aws/aws-lambda-go/events \
	&& go get github.com/aws/aws-lambda-go/lambda \
	&& GOOS=linux GOARCH=amd64 go build -o bootstrap main.go \
	&& zip -j function.zip bootstrap)

build-frontend-lambda:
	(cd ${FRONTEND_LAMBDA_PATH} && go mod init frontend_lambda || true \
	&& go get github.com/aws/aws-lambda-go/events \
	&& go get github.com/aws/aws-lambda-go/lambda \
	&& GOOS=linux GOARCH=amd64 go build -o bootstrap main.go \
	&& zip -j function.zip bootstrap)

build-api-lambda:
	(cd ${API_LAMBDA_PATH} && go mod init api_lambda || true \
	&& go get github.com/aws/aws-lambda-go/events \
	&& go get github.com/aws/aws-lambda-go/lambda \
	&& GOOS=linux GOARCH=amd64 go build -o bootstrap main.go \
	&& zip -j function.zip bootstrap)

# Generate Self-Signed Certificate Using OpenSSL
generate-certificate:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certificate.key -out certificate.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

sam-deploy: validate build-lambdas
	sam deploy --region ${AWS_REGION} ${SAM_DEPLOY_OPTIONS} --stack-name ${STACK_NAME} --s3-bucket ${SAM_BUCKET} --capabilities CAPABILITY_IAM

validate:
	sam validate --region ${AWS_REGION}
	cfn-lint template.yaml