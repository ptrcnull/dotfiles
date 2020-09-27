function go-static-build () {
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $1 .
}
