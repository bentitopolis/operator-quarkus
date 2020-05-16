red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
KUBECTL_CONFIGS = "src/main/ocp"
DEPLOY_NAMESPACE ?= "default"

apply:
	@echo "${green}Applying configs from ${KUBECTL_CONFIGS} on ${DEPLOY_NAMESPACE} namespace${reset}"
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.clusterrole.yaml -n ${DEPLOY_NAMESPACE}
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.serviceaccount.yaml -n ${DEPLOY_NAMESPACE}
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.clusterrolebinding.yaml -n ${DEPLOY_NAMESPACE}

deploy:
	@echo "${green}Deploying config ${KUBECTL_CONFIGS}/operator-quarkus.deployment.yaml on ${DEPLOY_NAMESPACE} namespace${reset}"
	kubectl apply -f ${KUBECTL_CONFIGS}/operator-quarkus.deployment.yaml -n ${DEPLOY_NAMESPACE}
