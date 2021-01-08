red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
KUBECTL_CONFIGS = src/main/ocp
DUMMY_DEPLOY_NAMESPACE ?= default
DEPLOY_NAMESPACE ?= default
# These repos can be the same, the differentiation here is CRC specific
EXTERNAL_IMAGE_REPO ?= default-route-openshift-image-registry.apps-crc.testing
INTERNAL_IMAGE_REPO ?= image-registry.openshift-image-registry.svc:5000

.EXPORT_ALL_VARIABLES:

build:
	@echo "${green}Building with mvnw${reset}"
	./mvnw clean package -Pnative -Dquarkus.native.container-build=true -Dnative-image.xmx=5g -Dquarkus.container-image.build=true -Dquarkus.container-image.registry=${EXTERNAL_IMAGE_REPO} -Dquarkus.container-image.group=default

apply:
	@echo "${green}Applying configs from ${KUBECTL_CONFIGS} on ${DEPLOY_NAMESPACE} namespace${reset}"
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.crd.yaml -n ${DEPLOY_NAMESPACE}
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.serviceaccount.yaml -n ${DEPLOY_NAMESPACE}
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.clusterrole.yaml -n ${DEPLOY_NAMESPACE}
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.clusterrolebinding.yaml -n ${DEPLOY_NAMESPACE}

deploy:
	@echo "${green}Deploying config ${KUBECTL_CONFIGS}/operator-quarkus.deployment.yaml on ${DEPLOY_NAMESPACE} namespace${reset}"
	envsubst < ${KUBECTL_CONFIGS}/operator-quarkus.deployment.yaml | kubectl apply -f - -n ${DEPLOY_NAMESPACE}

apply-cr:
	@echo "${green}Deploying CR ${KUBECTL_CONFIGS}/operator-quarkus.cr.yaml on ${DEPLOY_NAMESPACE} namespace${reset}"
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.cr.yaml -n ${DEPLOY_NAMESPACE} --validate=false
