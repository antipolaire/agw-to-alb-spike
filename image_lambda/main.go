package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"image"
)

func handler() (events.ALBTargetGroupResponse, error) {

	img := image.NewGray(image.Rect(0, 0, 100, 100))
	response := events.ALBTargetGroupResponse{
		StatusCode:        200,
		StatusDescription: "200 OK",
		Headers: map[string]string{
			"Content-Type": "image/jpeg",
		},
		Body:            string(img.Pix),
		IsBase64Encoded: false,
	}
	return response, nil
}

func main() {
	lambda.Start(handler)
}
