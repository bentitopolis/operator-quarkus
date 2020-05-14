# operator-example project

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:
```
./mvnw quarkus:dev
```

## Packaging and running the application

The application can be packaged using `./mvnw package`.
It produces the `operator-example-1.0-SNAPSHOT-runner.jar` file in the `/target` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/lib` directory.

The application is now runnable using `java -jar target/operator-example-1.0-SNAPSHOT-runner.jar`.

## Creating a native executable

You can create a native executable using: `./mvnw package -Pnative`.

Or, if you don't have GraalVM installed, you can run the native executable build in a container using: `./mvnw package -Pnative -Dquarkus.native.container-build=true`.

You can then execute your native executable with: `./target/operator-example-1.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult https://quarkus.io/guides/building-native-image.

## Notes about deploying on CodeReadyContainers (CRC) [v1.10.0 which is running OpenShift 4.4.3]

Easiest to locally deploy the operator created here if namespace and service account match up:

So if building and pushing with this:
```bash
./mvnw clean package -Dquarkus.container-image.build=true -Dquarkus.container-image.registry=default-route-openshift-image-registry.apps-crc.testing -Dquarkus.container-image.group=default
docker push default-route-openshift-image-registry.apps-crc.testing/default/operator-example:1.0-SNAPSHOT
```
That `quarkus.container-image.group` matches the `default` project in CRC and the registry set by: `quarkus.container-image.registry` matches the external registry route that CRC has.

There are corresponding entries in the `src/main/ocp/operator-example.deployment.yaml` `spec.template.spec.containers.image` field, but pointing to the internal registry: `image-registry.openshift-image-registry.svc:5000/default/operator-example:1.0-SNAPSHOT`

If all goes well you'll have a deployment with a pod up that ran the Quarkus operator on startup and listed all the pods running in `default` project.
