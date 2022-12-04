TAG=devel
IMAGE=rsnapshot
VOLUMES= \
    -v ${PWD}/config:/config
ENV=
PORTS=

all: build

clean:
	find . -name \*~ -delete

run: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it ${IMAGE}:${TAG}

# Run the container with just a bash shell
run-bash: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it --entrypoint /bin/bash ${IMAGE}:${TAG}

# Start the container and run a bash shell
exec-bash: build
	docker run ${VOLUMES} ${ENV} ${PORTS} -it ${IMAGE}:${TAG} /bin/bash

build: true
	docker build -t ${IMAGE}:${TAG} .

true: ;
