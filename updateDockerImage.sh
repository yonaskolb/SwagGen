# Manually set
# THIS IS THE ONLY PART OF THE SCRIPT THAT WE SHOULD CHANGE IF NEEDED
declare GITHUB_REPO="yonaskolb/SwagGen"
declare TAG_OR_BRANCH="master"
declare DOCKERHUB_USER="yonaskolb"
declare DOCKERHUB_PROJECT="swaggen"
declare MAINTAINER="Yonas Kolb(@yonaskolb)"
declare SWIFT_VERSION_CUSTOM=""
declare DOCKER_IMAGE_VERSION_ALIAS="latest"


# PLEASE DON'T CHANGE CODE BEHIND THIS LINE

#########################################################################################
# DYNAMICALLY SET INPUTS																#
#########################################################################################
declare SWIFT_VERSION=$(swift sh getLastSwiftTag.swift "apple/swift" "-RELEASE")
if [[ -n "${SWIFT_VERSION_CUSTOM}" ]]; then
	SWIFT_VERSION="${SWIFT_VERSION_CUSTOM}"
fi
declare DEPENDENCY_VERSION="$(curl --silent "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
if [[ "${TAG_OR_BRANCH}" != "master" ]]; then
	DEPENDENCY_VERSION="${TAG_OR_BRANCH}"
fi
declare GITHUB_USER="$(echo ${GITHUB_REPO} | cut -d"/" -f1)"
declare GITHUB_PROJECT="$(echo ${GITHUB_REPO} | cut -d"/" -f2)"
declare GITHUB_FULLURL="https://github.com/${GITHUB_REPO}"
declare OLD_DEPENDENCY_VERSION="$(cat VERSION)"
declare OLD_SWIFT_VERSION="$(cat SWIFT_VERSION)"
declare EXPECTED_TAR_FILENAME="${GITHUB_USER}-${GITHUB_PROJECT}-*"
declare DOCKERHUB_PROJECT_ACCOUNT="${DOCKERHUB_USER}/${DOCKERHUB_PROJECT}"
declare DOCKER_IMAGE_VERSION="${DEPENDENCY_VERSION}-slim"
declare DOCKER_IMAGE_DESCRIPTION="Slim docker image for ${GITHUB_PROJECT}(${DEPENDENCY_VERSION}) with ${SWIFT_VERSION}"
declare DEPENDENCY_ARCHIVE_URL="${GITHUB_FULLURL}/tarball/${DEPENDENCY_VERSION}"
declare FORCE_UPDATE=false

# TEST for empty DEPENDENCY AND SWIFT VERSION
if [[ -z "${OLD_DEPENDENCY_VERSION}" ]] || [[ -z "${OLD_SWIFT_VERSION}" ]]; then
  echo "${DEPENDENCY_VERSION}" > VERSION
  echo "${SWIFT_VERSION}" > SWIFT_VERSION
  FORCE_UPDATE=true
  OLD_SWIFT_VERSION="$(cat SWIFT_VERSION)"
  OLD_DEPENDENCY_VERSION="$(cat VERSION)"
  DOCKER_IMAGE_VERSION="${DEPENDENCY_VERSION}-slim"
fi

# Generated
declare DOCKER_IMAGE_TAG="${DOCKERHUB_USER}/${DOCKERHUB_PROJECT}:${DOCKER_IMAGE_VERSION}"

#########################################################################################
# BUILD																					#
#########################################################################################
echo "Building Docker image 🐳🔨"
echo "---------------------------"
echo "Previous dependency version: ${OLD_DEPENDENCY_VERSION}\n"
echo "Previous Swift version: ${OLD_SWIFT_VERSION}\n"

if [[ "$FORCE_UPDATE" = true ]] || [[ "${DEPENDENCY_VERSION}" != "${OLD_DEPENDENCY_VERSION}" ]] || [[ "${SWIFT_VERSION}" != "${OLD_SWIFT_VERSION}" ]]; then

  echo "Remove previous image"
  echo "---------------------"
  docker login
  docker rmi -f ${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION} || true

  # Build
  docker build                                                            \
  --build-arg DEPENDENCY_ARCHIVE_URL="${DEPENDENCY_ARCHIVE_URL}"          \
  --build-arg GITHUB_USER="${GITHUB_USER}"                                \
  --build-arg EXPECTED_TAR_FILENAME="${EXPECTED_TAR_FILENAME}"            \
  --build-arg MAINTAINER="${MAINTAINER}"                                  \
  --build-arg DOCKER_IMAGE_DESCRIPTION="${DOCKER_IMAGE_DESCRIPTION}"      \
  --force-rm                                                              \
  --pull                                                                  \
  --tag "${DOCKER_IMAGE_TAG}"                                             \
  .

  echo "FORCE_UPDATE: ${FORCE_UPDATE}"
  echo "${DEPENDENCY_VERSION}" > VERSION
  echo "${SWIFT_VERSION}" > SWIFT_VERSION

else
  echo "-- Last Build info"
  echo "Swaggen: ${OLD_DEPENDENCY_VERSION}"
  echo "Swift: ${OLD_SWIFT_VERSION}"
  echo "No need to update 👍"
  exit 0 # EXIT_SUCCESS
fi

#########################################################################################
# TEST																					#
#########################################################################################
if [[ "${TAG_OR_BRANCH}" == "master" ]]; then

echo "Testing ⚙️"
echo "---------------------------"
DEPENDENCY_TEST_VERSION=$(docker run --rm "${DOCKER_IMAGE_TAG}" swaggen --version)
if [[ "Version: ${DEPENDENCY_VERSION}" == "${DEPENDENCY_TEST_VERSION}" ]]; then
  echo "👍"
else
  echo "👎"
fi

fi

#########################################################################################
# TAG																					#
#########################################################################################
echo "Tag"
echo "---------------------------"

## Delete Tag
git push --delete origin "${DOCKER_IMAGE_VERSION}" || true
git tag -d "${DOCKER_IMAGE_VERSION}" || true

## Push Tag
git tag "${DOCKER_IMAGE_VERSION}" -m "${DEPENDENCY_VERSION}/${SWIFT_VERSION}"
git push origin "${DOCKER_IMAGE_VERSION}"

#########################################################################################
# PUBLISH																				#
#########################################################################################
echo "Publish 🚀"
echo "---------------------------"

docker login
if [[ "${TAG_OR_BRANCH}" != "master" ]]; then
	docker tag	${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION} "${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION}-latest"
	docker push ${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION}
else
	docker tag	${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION} ${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION_ALIAS}
	docker push ${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION}
	docker push ${DOCKERHUB_PROJECT_ACCOUNT}:${DOCKER_IMAGE_VERSION_ALIAS}
fi
