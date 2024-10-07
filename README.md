# Design and deploy an AWS EKS Cluster

## Infrastructure Diagram

## Description

Deploying Amazon Elastic Kubernetes Service (EKS) with 1 node group with 2 minimum worker nodes deployed across 2 availability zones (AZ).

### Worker Nodes

The worker nodes have a disk size of 50 GB and of a general purpose instance type (t3.small), which is a cost effective option for workloads that can grow.
They are deployed in 2 separate subnets. The 2 subnets are deployed in 2 different AZ, ap-southeast-1a and ap-southeast-1b. This ensures that the worker nodes will be highly available and accessible even if one of the zones is down.

### VPC

A VPC is created with 2 availability zones that allows for high availability even with 1 of the zones is facing an outage. The EKS control plane is also automatically created when the cluster is set up within the defined vpc's cidr block.

### Subnets

Subnets is used to influence how traffic is routed within VPC and to the Internet. Both public and private subnets is used in this deployment to allows better security and cost-efficacy. Having the subnets across 2 different AZ allows for maintaining high availability.

In each private subnet, the worker nodes are deployed. These nodes are connected to the public subnets before hitting the outside traffic (Internet). The separation of private and public subnets brings various benefits:

- Placing worker nodes in private subnets shield them from direct access to the internet and reducing attack surface.
- Worker nodes usually uses internet access for tasks liek pulling container images or communicating with external services. By providing access via a NAT Gateway in public subnet in each AZ save costs and provide better control over outgoing traffic.
- By having both public and private subnets in each AZ, application and its components that are residing in each private and public subnets can continue to function even if one AZ experiences an outage.

### Route Tables

Route tables are added to define the allow routes for private and public subnets within and outside the EKS cluster.

Two route tables are created, one for private subnet and one for public subnet. For the public subnet table, a route is created to allows the public subnets to access the Internet. This table is associated with both public subnets across two AZs. For the private subnets route table, the route created is to allow only for local vpc communication and not with the internet. This table is also associated with both private subnets across two AZs.

### Security Groups

Security groups are added to the EKS cluster to control the traffic to and from worker nodes and the EKS control plane.

One security group is created for EKS control plane. This security group allows the control plane to communicate with the worker nodes. One Security group is also created for the EKS worker nodes to allow worker nodes to communicate with each other internally and be able to access necessary resources such as the Elastic Block Store (EBS) and the control plane.

### Network Access Control Lists (NACL)

NACL are used to control traffic at the subnet level for both private and public subnets.

For this cluster , various access control rules are added on the to private subnets so as to allow minimal required traffic only. The rules allow inbound and outbound traffic to and from the VPC, but deny all inbound and outbound traffic to and from the internet. This prevent the private subnets to be able to access to the internet as well even if the security groups or route tables fail.

### Identity and Access Management (IAM) Roles and Policies

Various IAM roles are created to manage the access control to the EKS cluster. Necessary policies are also attached to the roles such that the worker nodes are able to communicate with the EKS cluster as well as for the cluster to access other AWS services.

An IAM role is created for the worker nodes which allow them to assume the required roles laid out in the policy. An instance profile is also added to act as a container for the IAM role.

The following policies are attached to the IAM role for worker nodes:

- **AmazonEKSWorkerNodePolicy.** This policy is a predefined IAM policy by AWS to provide permissions required for Amazon EKS worker nodes such as joining the cluster or retriving information about the cluster. Without this, worker node might not be able to connect to the EKS control plane.

- **AmazonEKSCNIPolicy.** This policy is a predefined IAM policy by AWS to provide permissions required to manage networking related actions, such as assigning IP addresses from the VPC CIDR block.

A custom IAM policy is also created for EBS storage. In the policy, various permissions such as creating volume, creating snapshots and modifying volues are added. These permissions allow the worker nodes to utilise EBS storage and store persistent data. This policy is also attached to the IAM role for worker nodes.

To allow interaction with various AWS services such as CloudWatch and S3, a custom IAM policy for the cluster is created with the necessary permissions added. If there are other AWS services required, more permissions can be added to this cluster policy. Currently, it is kept at the minimal with just these two examples to reduce the number of unnecessary permissions. This IAM policy is attached to the IAM role as well.

### Storage

To enable the EC2 instances to be able to store their data in a persistent storage, an Amazon Elastic Block Store (EBS) is also added to the cluster. They are connected to the worker nodes to enable them to use it as persistent storage.

A key point to note that the EBS is only available in one zone (ap-southeast-1a).

### Outputs

Output variables that are useful in managing the EKS cluster is outputted when the terraform is applied. These include:

- EKS Cluster Name
- VPC ID
- Worker Node Role ARN
- Public Subnets
- Security Groups

Route tables and private subnets are not outputted as they often contain sensitive information such as route destinations and internal network structure. They also have limited usefulness even when being outputted.

## Deployment

### Prerequisites

1. You have an AWS account ready with AWS CLI installed on your computer.
2. You have Terraform CLI installed on your computer.
3. The region to deploy the cluster is in Asia Pacific (Singapore) ap-southeast-1 in AWS.
4. You have an Internet connection to Terraform Providers Registry and AWS.

### Steps

1. Configure the AWS CLI with access credentials to your AWS account. This allows your deployment to be deployed directly onto AWS in further steps.

- Command: `aws configure`
- Preparation: AWS Access Key ID, Secret Access Key, Region (ap-southeast-1)

2. Clone the Repository and use the code.

- Command: `git clone 

## Assumptions for the EKS cluster set up

1. As there are various network traffic coming from different AZs for different worker nodes. It is assumed that there is a load balancer installed into the cluster to assist to balance the worker nodes such that the traffic will not be skewed.
2. Although this design started with only 2 worker nodes, it assumes future scaling of nodes across multiple AZs. Hence, it is assumed that the number of IP addresses declared within the VPC should be sufficient for the subnets for additional nodes.
3. Latency when communicating between the 2 worker nodes will be slightly higher as they are in different deployed in AZs. Hence, it is assumed that this latency is negligible for communication across AZs, or they can be depolyed in same AZs if the communication require the lowest latency.  
4. It is assumed that the EBS volumes attached to the EKS cluster is encrypted at rest, ensuring that the worker nodes' storage is protected.
