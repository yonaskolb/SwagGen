FROM swift:5.0.1

WORKDIR /SwagGen
COPY . /SwagGen
RUN make install
