###############################################################################
# DOCKERFILE FOR swaggen
###############################################################################

# -----------------------------------------------------------------------------
# BUILD STAGE
# -----------------------------------------------------------------------------

FROM swift:latest as builder

RUN apt-get update && apt-get install -y curl

ARG DOCKER_IMAGE_DESCRIPTION
ARG MAINTAINER
ARG EXPECTED_TAR_FILENAME
ARG DEPENDENCY_ARCHIVE_URL
ARG GITHUB_USER

RUN curl -LSs --fail -o /tmp/swaggen.tgz -- "${DEPENDENCY_ARCHIVE_URL}"     \
    && cd /tmp                                                              \
    && tar -xzf swaggen.tgz                                                 \
    && mv "$(ls -d ${EXPECTED_TAR_FILENAME} | grep ${GITHUB_USER})" ./swaggen  \
    && cd /tmp/swaggen                                                      \
    && make install PREFIX=/tmp/swaggen-install

# -----------------------------------------------------------------------------
# RUN STAGE
# -----------------------------------------------------------------------------

FROM swift:slim
LABEL maintainer="${MAINTAINER}"
LABEL description="${DOCKER_IMAGE_DESCRIPTION}"

COPY --from=builder /tmp/swaggen-install/ /usr/local/

COPY Dockerfile /Dockerfile
COPY LICENSE /LICENSE
COPY VERSION /VERSION

RUN chmod +x /usr/local/bin/swaggen

###############################################################################
