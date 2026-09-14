#!/bin/bash

WORKDIR="$(dirname "$(realpath "$0")")"

TAG_MODULES=(
	"firenvim"
	"neo-tree.nvim"
)

pushd "$WORKDIR" || exit 1

git submodule update --remote --recursive

for module in "${TAG_MODULES[@]}"; do

	pushd pack/*/*/$module || continue

	git fetch --tags
	git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"

	popd || continue

done

popd || exit 1
