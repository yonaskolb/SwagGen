#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
SPEC_NAME=$(basename $1)
SPEC_PATH=$1
SWAGGER_SPEC=$SPEC_PATH/spec.yml

if [ -f "${SWAGGER_SPEC}" ]
then
	SWAGGER_SPEC=$SPEC_PATH/spec.yml
else
	SWAGGER_SPEC=$SPEC_PATH/spec.json
fi

rm -f ${SPEC_PATH}/generated/Swift/Package.resolved

# echo "📦  Testing $SPEC_PATH"
echo "⚙️  Generating $SPEC_NAME..."
swift run swaggen generate ${SWAGGER_SPEC} --template Templates/Swift/template.yml --destination $SPEC_PATH/generated/Swift --option name:$SPEC_NAME --clean all --silent
echo "⚙️  Compiling $SPEC_NAME..."
swift build --package-path ${SPEC_PATH}/generated/Swift --build-path Specs/.build -c release
echo "✅  ${GREEN}Built $SPEC_NAME${NO_COLOR}"
rm -f ${SPEC_PATH}/generated/Swift/Package.resolved
