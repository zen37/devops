# DevOps

## What’s a CI/CD pipeline?

A continuous integration and continuous deployment (CI/CD) pipeline is a series of steps that must be performed in order to deliver a new version of software

A pipeline is a process that drives software development through a path of building, testing, and deploying code.
By automating the process, the objective is to minimize human error and maintain a consistent process for how software is released.
Tools that are included in the pipeline could include: compiling code, unit tests, code analysis, security, and binaries creation. For containerized environments, this pipeline would also include packaging the code into a container image to be deployed across a hybrid cloud.

![alt text](pipeline.png)

## Pipelines

It's common practice to have separate pipelines for staging and production environments in more complex CI/CD setups.

Separate pipelines for staging and production environments allow for greater control and isolation between the two environments. This separation ensures that changes are tested thoroughly in a staging environment before being promoted to production, reducing the risk of introducing bugs or issues into the production environment.

Typically, the staging pipeline would deploy changes to a staging environment where testing can be performed, while the production pipeline would deploy changes to the live production environment. Each pipeline may have similar configurations and steps, but they would target different environments and possibly have different levels of testing or approval processes.

If you need separate staging and production pipelines, you would duplicate the workflow configuration file and modify it to target the appropriate environments. Each pipeline would have its own triggers, configurations, and deployment targets tailored to the specific environment it serves. This ensures that changes are deployed safely and reliably to both staging and production environments.

Staging and production pipelines often differ in their configurations, especially regarding testing and deployment strategies.

### Testing
The staging pipeline may include more extensive testing, such as integration tests, end-to-end tests, or performance tests, to thoroughly validate changes before promoting them to production. The production pipeline may have fewer or lighter tests to minimize deployment time and potential disruptions to live services.

### Approval Process
The staging pipeline may require manual or automated approval before deploying changes to the production environment. This allows stakeholders to review and approve changes before they go live. The production pipeline may have a stricter approval process or additional checks to ensure that only verified changes are deployed to the live environment.

### Deployment Strategies
The staging pipeline may use different deployment strategies, such as deploying to a separate staging environment or using canary deployments, to validate changes with a smaller audience before rolling them out to all users in the production environment. The production pipeline may use more conservative deployment strategies, such as blue-green deployments or rolling updates, to minimize downtime and risks during deployment.

Environment Configuration: The staging environment may mirror the production environment closely but with simulated or mock dependencies to isolate testing. The production environment may have different configurations, such as higher resource allocations or additional security measures, to support live services and handle production traffic.


## Blue-Green Deployments:

In a blue-green deployment, you maintain two identical production environments: one "blue" and one "green."
At any given time, only one environment (either blue or green) is serving live traffic, while the other remains inactive.
When you need to deploy changes, you deploy them to the inactive environment (e.g., green).
After the deployment is successful and you've tested the changes in the inactive environment, you switch the router or load balancer to direct traffic to the updated environment (e.g., green).
This approach allows for quick rollback if issues arise because you can easily switch back to the previous environment (e.g., blue).

## Canary Deployments:

In a canary deployment, you gradually roll out changes to a subset of users or servers before deploying them to the entire production environment.
Initially, only a small percentage of users or servers (the "canary group") receive the new changes.
You monitor the performance and stability of the canary group to ensure that the changes don't introduce any issues.
If the changes are successful and no issues are detected, you gradually increase the percentage of users or servers receiving the changes until all are updated.
If issues are detected, you can quickly roll back the changes before they affect the entire production environment.
In summary, blue-green deployments involve maintaining two identical environments and switching traffic between them, while canary deployments involve gradually rolling out changes to a subset of users or servers. Both strategies aim to minimize risk and downtime during deployments while allowing for quick rollback if issues arise. The choice between the two depends on factors such as the complexity of your application, your risk tolerance, and your deployment infrastructure.

## Deployment Best Practices

https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices#use-deployment-slots

Production slot, which is not recommended for setting up CI/CD.Learn more



## Configure a user-assigned managed identity to trust an external identity provider

https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust-user-assigned-managed-identity?pivots=identity-wif-mi-methods-azp

### Managed Identity in Azure
User-Assigned Managed Identity: This is a type of managed identity in Azure that you create and assign to one or more Azure resources.

### External Identity Provider (IdP)
GitHub: In this context, GitHub acts as the external identity provider. GitHub provides the identity tokens that can be used to authenticate to Azure resources.

### Federated Identity Credential
A federated identity credential allows Azure to trust tokens issued by an external identity provider. This is useful for scenarios where applications or services running outside of Azure need to authenticate and access Azure resources securely without managing secrets or credentials.


### Example Scenario: GitHub Actions to Azure
GitHub Actions: workflow running in GitHub Actions.
Federated Identity Credential: federated identity credential in Azure that trusts tokens issued by GitHub.
Managed Identity: user managed identity assigned to the Azure resource that the GitHub Actions workflow needs to access.

### Summary
Managed Identity: Resides in Azure.
Identity Provider: GitHub, issuing tokens for GitHub Actions workflows.
Federated Identity Credential: Configured in Azure to trust tokens from GitHub, allowing secure, token-based access to Azure resources.

This setup facilitates secure and seamless integration between GitHub and Azure, enabling automated workflows (like CI/CD pipelines) to interact with Azure resources without handling traditional secrets.