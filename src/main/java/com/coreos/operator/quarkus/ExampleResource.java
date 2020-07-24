package com.coreos.operator.quarkus;

import io.fabric8.kubernetes.client.CustomResource;

public class ExampleResource extends CustomResource {

    private ExampleResourceSpec spec;

    public ExampleResourceSpec getSpec() {
        return spec;
    }

    public void setSpec(ExampleResourceSpec spec) {
        this.spec = spec;
    }

    @Override
    public String toString() {
        String name = getMetadata() != null ? getMetadata().getName() : "unknown";
        String version = getMetadata() != null ? getMetadata().getResourceVersion() : "unknown";
        return "name=" + name + " version=" + version + " value=" + spec;
    }
}
