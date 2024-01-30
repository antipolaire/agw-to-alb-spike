package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler() (events.ALBTargetGroupResponse, error) {
	response := events.ALBTargetGroupResponse{
		StatusCode:        200,
		StatusDescription: "200 OK",
		Headers: map[string]string{
			"Content-Type": "text/html",
		},
		Body:            `{ "message": "Hello World" }}`,
		IsBase64Encoded: false,
	}
	return response, nil
}

func main() {
	lambda.Start(handler)
}
