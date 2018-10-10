IMAGE_NAME = quay.io/gsaslis/3scale-system-builder

all: build test

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

test:
#	docker run --user root --rm $(IMAGE_NAME) sh -c 'echo $$HOME | grep '
#	docker run --rm $(IMAGE_NAME) sh -c 'echo $$HOME | grep /ruby'
	docker run --rm $(IMAGE_NAME) ruby -v | grep 2.3
	docker run --rm $(IMAGE_NAME) node -v
	docker run --rm $(IMAGE_NAME) bundle -v
	docker run --rm $(IMAGE_NAME) sh -c 'sudo ls -al /root'