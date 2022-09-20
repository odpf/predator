NAME="predator"
PROTON_COMMIT := "5c0b3bb5df406f2d6ea0f20e2dc41bb89c5cfbe5"

.PHONY: build test migrate rollback run cover

all: build

build:
	go build -o predator ./cmd/predator

run:
	./predator

coverage:
	go test `go list ./... | grep -v /cmd | grep -v mock` -count 1 -cover -parallel 100 -coverprofile coverage.txt > /dev/null
	go tool cover -func coverage.txt

test:
	go test `go list ./... | grep -v /cmd | grep -v mock` -count 1 -cover -parallel 100

unit-test-ci:
	go test -count 5 -race -coverprofile coverage.txt -covermode=atomic -timeout 3m -tags=unit_test ./...

migrate:
	go run ./cmd/migrator/migration.go up

rollback:
	go run ./cmd/migrator/migration.go down

build-cli:
	go build -o predatorcli ./cmd/predatorcli

generate-db-resource:
	@echo " > generating resources"
	@go generate ./db/migrations

generate-proto:
	@echo " > generating protobuf from odpf/proton"
	@buf generate https://github.com/odpf/proton/archive/${PROTON_COMMIT}.zip#strip_components=1 --template buf.gen.yaml --path odpf/predator
	@echo " > protobuf compilation finished"

lint:
	golangci-lint run --fix
