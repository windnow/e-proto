#!/usr/bin/env bash
set -e

PROTO_DIR=services
OUT_DIR=pb

# очистить старую генерацию
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

# одна команда для обоих proto-файлов
protoc \
  -I="${PROTO_DIR}" \
  --go_out="${OUT_DIR}" --go_opt=paths=source_relative \
  --go-grpc_out="${OUT_DIR}" --go-grpc_opt=paths=source_relative \
  "${PROTO_DIR}/common/common.proto" \
  "${PROTO_DIR}/user/user.proto"