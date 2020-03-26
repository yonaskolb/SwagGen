# swaggen-docker

**Official Docker image** for [SwagGen](https://github.com/yonaskolb/SwagGen)

## Update process

In order to update the docker image just run `./updateDockerImage.sh`
If Swift or Swaggen has a new version it will create a new docker container accordingly.

This require you to have installed `swift-sh`([Github](https://github.com/mxcl/swift-sh)).

## Available Tags

<!--* `4.3.1-slim`, `latest` ([_Dockerfile_](https://github.com/mackoj/swaggen-docker/blob/4.3.1-slim/Dockerfile))
* `4.3.0-slim` ([_Dockerfile_](https://github.com/mackoj/swaggen-docker/blob/4.3.0-slim/Dockerfile))
* `4.2.0-slim` ([_Dockerfile_](https://github.com/mackoj/swaggen-docker/blob/v4.2.0/Dockerfile))
* `4.2.0` ([_Dockerfile_](https://github.com/mackoj/swaggen-docker/blob/v4.2.0/Dockerfile)) -->

## Usage

```bash
# Pull this image
docker pull yonaskolb/swaggen:latest

declare DOCKER_MOUNTED_PATH="/tmp/workdir"

curl https://www.mysite.com/swagger.json -o api.json

# Run swaggen
#   - This assumes your spec file is in $(pwd)/spec.json
#   - Generated code will be available in $(pwd)/swaggen-output

docker run                                                              \
  --rm                                                                  \
  -v "$(pwd):${DOCKER_MOUNTED_PATH}"                                    \
  yonaskolb/swaggen:latest                                                 \
  swaggen generate "${DOCKER_MOUNTED_PATH}/api.json"                    \
  --language swift                                                      \
  --template "${DOCKER_MOUNTED_PATH}/Templates/Swift/template.yml"      \
  --destination "${DOCKER_MOUNTED_PATH}/Generated/Swift"                \
  --clean all                                                           \
  --verbose
```
