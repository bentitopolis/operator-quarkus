Working from https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/ as a starting point.

## Notes for deploying the simple base operator-quarkus on CodeReadyContainers (CRC) [CRC v1.10.0/OpenShift 4.4.3]

The `jib` extension has been added to this project to allow for building the image and pushing. You can avoid having to push/pull to a remote registry if you are running CRC locally since it includes a built-in registry.

It is easiest to locally deploy the operator created if the `project`/`NameSpace` and `ServiceAccount` match up:

So if building and pushing with this:
```bash
./mvnw clean package -Pnative -Dquarkus.native.container-build=true -Dnative-image.xmx=5g -Dquarkus.container-image.build=true -Dquarkus.container-image.registry=default-route-openshift-image-registry.apps-crc.testing -Dquarkus.container-image.group=default
docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
docker push default-route-openshift-image-registry.apps-crc.testing/default/operator-quarkus:1.0-SNAPSHOT
```
The `quarkus.container-image.group` matches the `default` project in CRC and the registry set by: `quarkus.container-image.registry` matches the external registry route that CRC has.

There are corresponding entries in the `src/main/ocp/operator-quarkus.deployment.yaml` `spec.template.spec.containers.image` field, but pointing to the internal registry: `image-registry.openshift-image-registry.svc:5000/default/operator-quarkus:1.0-SNAPSHOT`

Setup and install for OpenShift can be somewhat automated by calling:
```bash
export DEPLOY_NAMESPACE=default
make apply
make deploy
make apply-cr
```

If all goes well you will have a deployment that creates an example daemonset and example pod in the default namespace.

# operator-quarkus project

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:
```
./mvnw quarkus:dev
```

## Packaging and running the application

The application can be packaged using `./mvnw package`.
It produces the `operator-quarkus-1.0-SNAPSHOT-runner.jar` file in the `/target` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/lib` directory.

The application is now runnable using `java -jar target/operator-quarkus-1.0-SNAPSHOT-runner.jar`.

## Creating a native executable

You can create a native executable using: `./mvnw package -Pnative`.

Or, if you don't have GraalVM installed, you can run the native executable build in a container using: `./mvnw package -Pnative -Dquarkus.native.container-build=true`.

You can then execute your native executable with: `./target/operator-quarkus-1.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult https://quarkus.io/guides/building-native-image.
