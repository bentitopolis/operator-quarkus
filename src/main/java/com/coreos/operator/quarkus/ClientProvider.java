package com.coreos.operator.quarkus;

import io.fabric8.kubernetes.api.model.apiextensions.v1beta1.CustomResourceDefinition;
import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.dsl.NonNamespaceOperation;
import io.fabric8.kubernetes.client.dsl.Resource;
import io.fabric8.kubernetes.internal.KubernetesDeserializer;

import javax.enterprise.inject.Produces;
import javax.inject.Named;
import javax.inject.Singleton;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class ClientProvider {

    @Produces
    @Singleton
    @Named("namespace")
    private String findNamespace() throws IOException {
        return new String(Files.readAllBytes(Paths.get("/var/run/secrets/kubernetes.io/serviceaccount/namespace")));
    }

    @Produces
    @Singleton
    KubernetesClient newClient(@Named("namespace") String namespace) {
        return new DefaultKubernetesClient().inNamespace(namespace);
    }

    @Produces
    @Singleton
    NonNamespaceOperation<
            ExampleResource,
            ExampleResourceList,
            ExampleResourceDoneable,
            Resource<ExampleResource, ExampleResourceDoneable>>
    makeCustomResourceClient(KubernetesClient defaultClient,
                             @com.google.inject.name.Named("namespace") String namespace) {

        KubernetesDeserializer.registerCustomKind("coreos.com/v1alpha1", "Example", ExampleResource.class);

        CustomResourceDefinition crd = defaultClient
                .customResourceDefinitions()
                .list()
                .getItems()
                .stream()
                .filter(d -> "examples.coreos.com".equals(d.getMetadata().getName()))
                .findAny()
                .orElseThrow(
                        () -> new RuntimeException("Deployment error: Custom resource definition examples.coreos.com not found."));

        return defaultClient
                .customResources(crd, ExampleResource.class, ExampleResourceList.class, ExampleResourceDoneable.class)
                .inNamespace(namespace);
    }
}
