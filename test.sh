#!/bin/bash

REPO="github.com/kylelemons/go-rpcgen"

function err {
  echo "$@"
  exit 1
}

set -e

if ! which protoc >/dev/null; then
  err "Could not find 'protoc'"
fi

echo "Building protoc-gen-go..."
go build -o protoc-gen-go/protoc-gen-go $REPO/protoc-gen-go
export PATH="protoc-gen-go/:$PATH"

echo "Building protobufs..."
for PROTO in $(find . -name "*.proto" | grep -v "option.proto"); do
  #echo " - Compiling ${PROTO}..."
  #protoc --go_out=. ${PROTO}
  ./ae_protoc.sh ${PROTO}
done

echo "Testing packages..."
go test -i ./...
go test ./...
