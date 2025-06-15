#!/usr/bin/env bash
set -euo pipefail

PROTO_DIR="services"   # корень ваших *.proto
OUT_DIR="pb"           # куда кладём сгенерированные *.pb.go

# 1. Очистить предыдущую генерацию
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

# 2. Собрать список всех proto-файлов (рекурсивно)
mapfile -t PROTOS < <(find "${PROTO_DIR}" -type f -name "*.proto" | sort)

# 3. Если файлов нет — выходим с ошибкой
if [ ${#PROTOS[@]} -eq 0 ]; then
  echo "No .proto files found in ${PROTO_DIR}" >&2
  exit 1
fi

# 4. Опционально — вывести, что компилируем
echo "Generating for:"
printf "  • %s\n" "${PROTOS[@]}"

# 5. Пути к well-known types (google/protobuf/*)
#    protoc обычно знает их сам, но на всякий случай добавим go/pkg/mod :
GOMOD_DIR="$(go env GOPATH)/pkg/mod"

protoc \
  -I="${PROTO_DIR}" \
  -I="${GOMOD_DIR}" \
  --go_out="${OUT_DIR}"         --go_opt=paths=source_relative \
  --go-grpc_out="${OUT_DIR}"    --go-grpc_opt=paths=source_relative \
  "${PROTOS[@]}"