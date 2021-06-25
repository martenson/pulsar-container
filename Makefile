CONTAINER_NAME = pulsar-running
IMAGE_NAME = pulsar-inside

clean: stop
	docker rm  $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)

build:
	docker build -t $(IMAGE_NAME) .

run: build
	docker run -i \
	-u pulsar \
	--network="host" \
	--name $(CONTAINER_NAME) \
	--volume /Users/marten/devel/git/pulsar-container/config/app.yml:/mnt/pulsar/config/app.yml \
	--volume /Users/marten/devel/git/pulsar-container/config/local_env.sh:/mnt/pulsar/config/local_env.sh \
	$(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)
