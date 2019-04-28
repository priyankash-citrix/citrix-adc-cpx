include ../app.Makefile
include ../crd.Makefile
include ../gcloud.Makefile
include ../var.Makefile


TAG ?= 121.51.16
$(info ---- TAG = $(TAG))

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/citrix-adc-cpx/deployer:$(TAG)
NAME ?= citrix-adc-cpx-1

ifdef IMAGE_CITRIX_CPX
  IMAGE_CITRIX_CPX_FIELD = , "cpximage.image": "$(IMAGE_CITRIX_CPX)" endif
endif

fdef IMAGE_CITRIX_CONTROLLER
  IMAGE_CITRIX_CONTROLLER_FIELD = , "cicimage.image": "$(IMAGE_CITRIX_CONTROLLER)" endif
endif

ifdef CITRIX_SERVICE_ACCOUNT
  CITRIX_SERVICE_ACCOUNT = , "serviceAccount": "$(CITRIX_SERVICE_ACCOUNT)"
endif

APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)" \
  $(IMAGE_CITRIX_CONTROLLER_FIELD) \
  $(IMAGE_CITRIX_CPX_FIELD) \
  $(CITRIX_SERVICE_ACCOUNT) \
}

TESTER_IMAGE ?= $(REGISTRY)/citrix-adc-cpx/tester:$(TAG)


app/build:: .build/citrix-adc-cpx/debian9  \
            .build/citrix-adc-cpx/deployer \
            .build/citrix-adc-cpx/citrix-adc-cpx \
            .build/citrix-adc-cpx/tester


.build/citrix-adc-cpx: | .build
	mkdir -p "$@"


.build/citrix-adc-cpx/debian9: .build/var/REGISTRY \
                      .build/var/TAG \
                      | .build/citrix-adc-cpx
	docker pull marketplace.gcr.io/google/debian9
	docker tag marketplace.gcr.io/google/debian9 "$(REGISTRY)/citrix-adc-cpx/debian9:$(TAG)"
	docker push "$(REGISTRY)/citrix-adc-cpx/debian9:$(TAG)"
	@touch "$@"


.build/citrix-adc-cpx/deployer: deployer/* \
                       chart/citrix-adc-cpx/* \
                       chart/citrix-adc-cpx/templates/* \
                       schema.yaml \
                       .build/var/APP_DEPLOYER_IMAGE \
                       .build/var/MARKETPLACE_TOOLS_TAG \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/citrix-adc-cpx
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)/citrix-adc-cpx" \
	    --build-arg TAG="$(TAG)" \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/citrix-adc-cpx/citrix-adc-cpx: .build/var/REGISTRY \
                    .build/var/TAG \
                    | .build/citrix-adc-cpx
	docker pull quay.io/citrix/citrix-k8s-cpx-ingress:$(TAG)
	docker tag quay.io/citrix/citrix-k8s-cpx-ingress:$(TAG) \
	    "$(REGISTRY)/citrix-adc-cpx:$(TAG)"
	docker push "$(REGISTRY)/citrix-adc-cpx:$(TAG)"
	@touch "$@"


.build/citrix-adc-cpx/tester: .build/var/TESTER_IMAGE \
                     $(shell find apptest -type f) \
                     | .build/citrix-adc-cpx
	$(call print_target,$@)
	cd apptest/tester \
	    && docker build --tag "$(TESTER_IMAGE)" .
	docker push "$(TESTER_IMAGE)"
	@touch "$@"
