# Questions received from the MDBW17 app

These are the questions received through the app. These are my initial responses as of today, but I will do my best to continue updating the information here.

## What would be your confidence level in running mongodb on docker in prod and are there any minimum requirements like linux kernel version, docker version, ... ?

Our general recommendation is to go with MongoDB on Docker in production only if:
- You have a particular use case for this (i.e. production running on Kubernetes for instance)
- Testing and staging are already running successfully with a similar configuration
- You have experience managing and using containers with the corresponding orchestration tool (i.e. Kubernetes)

Most of the issues with MongoDB on Docker and Swarm or Kubernetes come from the integration of these technologies. This means issues with the hostname resolution due to changes in IP addresses in the internal DNS server and the key-value store (consul, etcd in Kubernetes).

For production and critical applications, our recommendation is to consider using both MongoDB and Docker support at least.

For the Linux kernel, the main requirements would be the ones to run Docker
- https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#prerequisites

For the Docker and Kubernetes version, I would rely on what Google Cloud is currently using. Google container engine is generally few releases behind to use stable Docker and Kubernetes versions, so that might be a good point to start.

These are all young and fast-paced projects so it is important to achieve the correct compromise between bleeding-edge, stability and requirements (like StatefulSets or affinity rules available only from Kubernetes 1.6).

## What is the performance impact on running MongoDB on container versus bare metal?

We haven't performed any benchmark or similar between MongoDB on containers vs bare metal. But given the light overhead of Docker and Kubernetes when compared to Virtual Machines or Cloud environments like AWS, I would not expect a big difference between containers and VMs. Then containers versus bare metal could be quite close to VM versus bare metal.


## For a dynamically allocated storage, what happens if the whole kube cluster gets hosed

With dynamic storage, the behaviour when the Kubernetes cluster goes down would be similar to AWS when multiple nodes become unavailable. Depending on the crash of the nodes, the EBS volumes will be independent of the nodes/instances. So unless data is corrupted due to the crash, the volume should be accessible by future pods referring to that persistent volume.


## How do you related this architecture to on premise hardware?

Google Cloud Platform is actually the easiest way of getting Kubernetes on the Cloud. For Kubernetes running on on-premises hardware, _kubespray_ seems like an interesting option. I would look for recommendations as the ones below:
- https://kubernetes.io/docs/setup/pick-right-solution/
- https://kubernetes.io/docs/getting-started-guides/kubespray/
- https://github.com/kubernetes-incubator/kubespray

If interested in building a Kubernetes from scratch, https://kubernetes.io/docs/getting-started-guides/scratch/ would be the best place to start.

## What about dependencies? For example, node 3 will start only if node 0 started successfully, and waits for it while it is booting?

The dependencies are built into the StatefulSets to achieve serial deployment, scaling and termination. The deployment occurs when we deploy a StatefulSet with 3 replicas for instance. When we run the command to deploy the StatefulSet YAML file, all 3 pods will be started serially, so node3 won't start until node1 and node2 are started. This applies to the deployment of the StatefulSet, not to the case when node3 is killed and node2 is not available. In the starting phase, node3 will start for the previous nodes to become available as that is a requisite in the statefulset configuration.

## Does ops manager present more issues / challenges since most replica sets are deployed via ops manager?

We see great interest in managing MongoDB containers through OpsManager. However, this can add more complexity for the case when we use OpsManager automation, as the deployment, coordination and configuration of the mongod procesess would then relay on OpsManager instead of through Kubernetes.

I'd recommend starting with MongoDB on Kubernetes first, and then when familiar with the configuration, build the containers to run the automation agent and deploy the mongod process within the container.

## How about Mongo on Openshift on GCP?

I'm not familiar with MongoDB on Openshift on GCP, but the following blog post on MongoDB on an on-premises Openshift configuration might be useful: https://www.mongodb.com/blog/post/openshift-ecosystem-unleashing-mongodb-with-your-openshift-applications.

## The IP potentially changed when kubernetes brought it back online. The replica set doesn't know about the new IP. Is there a way to make this automatic?

During the second step of the last demo, the replica set member did not show as online after the pod was killed. In most of the previous executions of this process, the member came back online automatically. I believe this could have been due to the internal DNS resolution within Kubernetes (and the frequency to update the new IP for the existing hostname within MongoDB).

This is an area we are seeing in some internal environments and with customers and we are currently working on understanding this and improving this behaviour as much as possible in what can be related to MongoDB.
