---
title: "Elastic stack: A complete guide to set up a modern log monitoring system on Kubernetes"
author: thainm
date: 2024-03-16 00:00:00 +0700
categories: [Observability, Elastic stack]
tags: [elastic, fundamental, observability, sre]
---

<style>
figcaption {
  color: #fff;
  text-align: center;
}
</style>

## Introduction

Running application generates a huge amount of logs. From the logs, we can say that the application is functioning well if most of them are information logs, or failing if they are stacktraces/errors. 

**Scenario:**

Let's say, a bank application user is trying to login to pay for a cup of coffee :) Every time she tried, it only shows "Login failed. Please try again!", even if her credentials are perfect. Not only this frustrates the user, but also the bank application administrators (usually, it's us, SRE team). After getting reports from users, the SRE team started to check the application backend and after several hours checking running services, they found the access control service returned so many of errors. They connected with stakeholders, and worked together to resolve the issue. Everything backed to normal. The users are now happy again.

But here's the thing: The SRE team had to go through all the services running in the Kubernetes cluster to find out that the access control service was malfunctioning. It did not stop and exited, but kept retrying indefinitely. If there's a tool which helps to centralizely store and visualize the logs from running services, the SRE team could take the rest much earlier.

**Solution:**

Here **Elastic** stack comes to rescue. The **Elastic** stack can be a good solution for the case as it is designed to store logs effectively and bring intuitive dashboards for log visualization.

This blog is a self-study lab, intends to share about Elastic stack's benefits, how it can be deployed, and the pros and cons of the stack. 

## Pre-requisite
The lab is performed under Linux environment using `kind` to create a local Kubernetes cluster with 2 nodes: 1 master and 1 worker. Each node has 2GB of storage so make sure your local machine has enough capabity. The following tools are required for this lab:
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [helm](https://helm.sh/docs/)
- [Docker Engine](https://docs.docker.com/engine/install/)

Readers should be familiar with the following knowledge:
- Docker concepts: Fundamental
- Kubernetes concepts: Intermediate
- Helm: Fundamental
- Linux: Intermediate
- (Optional) SSL/TLS: Intermediate

## Architecture overview

### Cluster overview
<figure>
  <img
  src="../assets/img/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/cluster-architecture.png" 
  alt="cluster-architecture">
</figure>

### Introduction to Elastic stack components
<figure>
  <img
  src="../assets/img/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/elastic-stack-architecture.png" 
  alt="elastic-search-architecture">
</figure>


- [Fluent Bit](https://docs.fluentbit.io/manual): A lightweight yet performance telemetry agent. In our architecture, Fluent Bit acts as a log collector and is deployed on every node to gather logs from running containers.
- [Logstash](https://www.elastic.co/guide/en/logstash/current/introduction.html): A data collector that accepts input from a variety of sources, and a powerful data processing pipeline with multiple filter plugins. In our architecture, Logstash accepts raw log output from Fluent Bit, transform the log into a structured format and then publish to Elasticsearch.
- [Elastic Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html): The heart of the Elastic stack. Elasticsearch is used to centralize, index, manage all the log and their lifecycles. By providing APIs, Elasticsearch allows developers to interact, search, and analyse the logs.
- [Kibana](https://www.elastic.co/guide/en/kibana/current/index.html): Not everyone loves to interact via APIs. In our architecture, Kibana provides a central place for anyone who needs access to Elasticsearch along with intuitive dashboards and customization options. 

## Laboratory

### Cluster setup
Every code or file in this blog is stored in [the blog resource repository](https://github.com/thai-nm/my-chirpy-website-resources/blob/main/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/).

- Download and use the [kind.yaml file](https://github.com/thai-nm/my-chirpy-website-resources/blob/main/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/kind.yaml) in the blog resource repository to create the desired cluster.

  ```bash
  # Create lab cluster
  kind create cluster --config=kind.yaml

  # Update kubectl to access lab cluster
  kubectl cluster-info --context kind-elastic-stack-lab
  ```

- After running this command, you will have a Kubernetes cluster with 2 nodes running as 2 Docker containers. Let's run this command to check if everything goes well until now:
  ```bash
  # Check status of pods in every namespace
  kubectl get pod -A

  # Check status of cluster nodes
  kubectl get node
  ```

  The output should look similar to this:
  <figure>
    <img
    src="../assets/img/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/cluster-status-output.png" 
    alt="elastic-search-architecture">
  </figure>

- We will set up Elastic stack by using Helm charts provided by Bitnami. Add Bitnami chart repository to Helm and try to list available charts:
  ```bash
  # Add Bitnami chart repo
  helm repo add bitnami https://charts.bitnami.com/bitnami
  
  # List available charts
  helm search repo bitnami
  ```

  The output should look like this:
  <img alt="elastic-search-architecture" src="../assets/img/2024-03-16-elastic-stack-a-complete-guide-to-set-up-a-modern-log-monitoring-system-on-kubernetes/list-charts.png">

Now we're good to go, let's start provisioning!

### Set up Elasticsearch
Chart information:
  - [Source repository](https://github.com/bitnami/charts/tree/main/bitnami/elasticsearch)
  - [ArtifactHub](https://artifacthub.io/packages/helm/bitnami/elasticsearch)

By default, this chart will install `Elasticsearch` as a `StatefulSet` object. This `StatefulSet` will control 4 types of [Elasticsearch node](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html):
  - Master node
  - Ingest node
  - Data node
  - Coordinating node

Elasticsearch node is represented by `Pod`s, and each pod will be associated with a **8Gi** `PersistentVolumeClaim`.

We can install Elasticsearch using chart's default values. In fact, the default values of this chart is nearly what we want in practical to ensure our Elasticsearch cluster is highly avalable and secured, but we still need to overide some values to fit our resource capacity. The `values-elasticsearch.yaml` here can be a good start for our use case, as well as for development/staging environments in practical:
```yaml
---
security:
  enabled: true                         # [1]
  existingSecret: elasticsearch-admin   # [2]
  tls:
    restEncryption: true                # [3]
    autoGenerated: true                 # [4]
master:
  replicaCount: 1                       # [5]
  resources:
    requests:
      cpu: 1                            # [6]
      memory: 256Mi                     # [7]
    limits:
      cpu: 2                            # [8]
      memory: 1024Mi                    # [9]
data:
  replicaCount: 2                       # [10]
  resources:
    requests:
      cpu: 1                            # [11]
      memory: 256Mi                     # [12]
    limits:
      cpu: 2                            # [13]
      memory: 1024Mi                    # [14]
ingest:
  enabled: false                        # [15]
coordinating:
  enabled: false                        # [16]
```

Let's explain what those options are and why we choose:
  1. We enable [X-Pack security plugin](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html) for our Elasticsearch cluster. If we don't enable this option, our cluster will be exposed publicly, which means it can be accessed from anyone without authentication/authorization. With this option enabled, every connection to our cluster will need to authenticate to join our cluster.
  2. Use existing secret as password for `elastic` built-in user.

### Set up Kibana
- Set up Kibana

### Set up Fluent Bit
- Set up Fluent Bit

### Set up Logstash
- Set up Logstash

## Analysis: Pros and Cons
- About pros
- About cons
- Futher enhancement
- Q&A
  - Why this architecture?
  - Why don't we use only Fluent Bit?
  - Why not Elastic official Helm chart?

## Terminate lab resources

## Conclusion
- Here is the conclusion of the Elastic stack.

## Reference
- References to mentioned resources.
