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
		Body: `<html>
                  <head>
                      <title>Hello CD2</title>
                  </head>
                  <body style="background-color: #C0FFEE;">
                      <h1>Hello CD2!</h1>
                  </body>
               </html>`,
		IsBase64Encoded: false,
	}
	return response, nil
}

func main() {
	lambda.Start(handler)
}
