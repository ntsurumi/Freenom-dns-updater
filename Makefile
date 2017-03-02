ARCHITECTURES = arm aarch64
QEMU_STATIC = https://github.com/multiarch/qemu-user-static/releases/download/v2.8.0
IMAGE = python:3.6-alpine
MULTIARCH = multiarch/qemu-user-static:register
TMP_DIR = tmp
TMP_DOCKERFILE = Dockerfile.generated
ifeq ($(REPO),)
  REPO = freenom
endif
ifeq ($(TRAVIS_BRANCH),)
	TAG = latest
else
  ifeq ($(TRAVIS_BRANCH), master)
    TAG = latest
  else
    TAG = $(TRAVIS_BRANCH)
	endif
endif

all: amd64 $(ARCHITECTURES)

$(ARCHITECTURES):
	@mkdir -p $(TMP_DIR)
	@curl -L -o $(TMP_DIR)/qemu-$@-static.tar.gz $(QEMU_STATIC)/qemu-$@-static.tar.gz
	@tar xzf $(TMP_DIR)/qemu-$@-static.tar.gz -C $(TMP_DIR)
	@sed -e "s|<IMAGE>|$@/$(IMAGE)|g" -e "s|<QEMU>|COPY $(TMP_DIR)/qemu-$@-static /usr/bin/qemu-$@-static|g" Dockerfile.generic > $(TMP_DOCKERFILE)
	@sed -i -e "s|arm/$(IMAGE)|armhf/$(IMAGE)|g" $(TMP_DOCKERFILE)
	@docker run --rm --privileged $(MULTIARCH) --reset
	@docker build -f $(TMP_DOCKERFILE) -t $(REPO):$@-$(TAG) .
	@rm -rf $(TMP_DIR) $(TMP_DOCKERFILE)

amd64:
	@sed -e "s|<IMAGE>|$(IMAGE)|g" -e "s|<QEMU>||g" Dockerfile.generic > $(TMP_DOCKERFILE)
	docker build -f $(TMP_DOCKERFILE) -t $(REPO):$@-$(TAG) .
	@rm -rf $(TMP_DOCKERFILE)

push:
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
	$(foreach arch,$(ARCHITECTURES) amd64, docker push $(REPO)/$(arch)-$(TAG);)
	@docker logout

clean:
	@rm -rf $(TMP_DIR) $(TMP_DOCKERFILE)
