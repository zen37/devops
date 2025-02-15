### **Azure DevOps Pipeline with Automatic Job Retries on Failure**  
This YAML pipeline demonstrates:  
- ✅ **Parallel jobs**  
- ✅ **Conditional execution (`succeeded()`, `failed()`)**  
- ✅ **Automatic job retries using `retryCount`**  
- ✅ **Line-by-line comments explaining each step**  

---

### **🔹 Pipeline YAML**
```yaml
trigger:
  branches:
    include:
      - main  # Run pipeline only when changes are pushed to the 'main' branch

pool:
  vmImage: 'ubuntu-latest'  # Use an Ubuntu virtual machine for all jobs

stages:
  - stage: Build
    displayName: "Build Stage"
    jobs:
      - job: BuildApp
        displayName: "Build Application"
        timeoutInMinutes: 10  # Set a timeout to prevent infinite hangs
        retryCount: 2  # Retry up to 2 times if the job fails
        steps:
          - script: |
              echo "Building application..."
              dotnet build
            displayName: "Build Code"  # Run the build command

      - job: RunTests
        displayName: "Run Unit Tests"
        timeoutInMinutes: 10  # Set timeout to prevent infinite runs
        retryCount: 3  # Retry up to 3 times if the job fails
        steps:
          - script: |
              echo "Running tests..."
              dotnet test
            displayName: "Execute Unit Tests"  # Run unit tests

  - stage: Deploy
    displayName: "Deploy Stage"
    dependsOn: Build  # This stage runs only if the 'Build' stage succeeds
    condition: succeeded()  # Ensures deployment only runs if the Build stage is successful
    jobs:
      - job: DeployWebApp
        displayName: "Deploy Web App"
        timeoutInMinutes: 15  # Timeout to avoid long-running deployments
        retryCount: 2  # Retry if the deployment fails
        steps:
          - task: AzureWebApp@1
            inputs:
              azureSubscription: 'MyAzureServiceConnection'  # Azure service connection name
              appName: 'MyApp'  # Name of the Azure Web App
              package: '$(Pipeline.Workspace)/BuildArtifacts'  # Path to the build artifact
            displayName: "Deploy Web App to Azure"

      - job: DeployDatabase
        displayName: "Deploy Database"
        dependsOn: DeployWebApp  # This job runs only if 'DeployWebApp' completes successfully
        condition: succeeded()  # Ensures it only runs if DeployWebApp succeeds
        timeoutInMinutes: 10  # Limit database deployment duration
        retryCount: 3  # Retry up to 3 times if the database deployment fails
        steps:
          - script: |
              echo "Deploying database..."
              echo "Running migrations..."
            displayName: "Run Database Migrations"  # Simulated DB deployment

      - job: NotifySuccess
        displayName: "Notify Team of Success"
        dependsOn: [DeployWebApp, DeployDatabase]  # Runs after both jobs complete
        condition: succeeded()  # Runs only if all dependencies succeed
        steps:
          - script: echo "Deployment successful! Notifying team..."
            displayName: "Send Success Notification"  # Notify team on success

      - job: NotifyFailure
        displayName: "Notify Team of Failure"
        dependsOn: [DeployWebApp, DeployDatabase]  # Runs after both jobs
        condition: failed()  # Runs only if one of its dependencies fails
        steps:
          - script: echo "Deployment failed! Notifying team..."
            displayName: "Send Failure Notification"  # Notify team on failure
```

---

### **🔹 Explanation of Retries**
| **Job** | **Retries** | **When?** |
|---------|-----------|------------|
| `BuildApp` | **2 times** | If it fails, retries **2 more times** before failing completely |
| `RunTests` | **3 times** | If tests fail, retries **3 more times** before stopping |
| `DeployWebApp` | **2 times** | Retries **twice** in case of a failed deployment |
| `DeployDatabase` | **3 times** | Retries **3 times** if database migration fails |

---

### **🔹 Additional Features**
✅ **`retryCount`** → Retries jobs automatically upon failure.  
✅ **`timeoutInMinutes`** → Prevents jobs from running indefinitely.  
✅ **`dependsOn:`** → Ensures ordered execution of deployment jobs.  
✅ **`condition: succeeded()` & `condition: failed()`** → Triggers success/failure notifications.  

---

### **🔹 What Happens in Case of Failures?**
1. If **BuildApp fails**, it is retried **twice** before stopping.  
2. If **RunTests fail**, they are retried **three times** before marking the stage as failed.  
3. If **DeployWebApp fails**, it is retried **twice** before stopping.  
4. If **DeployDatabase fails**, it is retried **three times** before failing.  
5. If **DeployWebApp or DeployDatabase fail**, the `NotifyFailure` job **sends an alert**.  
6. If **everything succeeds**, the `NotifySuccess` job **sends a success notification**.  

---

### **🔹 Key Takeaways**
- ✅ **`retryCount` automatically retries failing jobs** instead of manually restarting pipelines.  
- ✅ **`timeoutInMinutes` prevents infinite hangs** (important for long-running processes).  
- ✅ **Failure notifications are automatically sent** if a deployment job fails.  
- ✅ **Efficient use of parallel execution** improves speed while keeping dependencies structured.  

Would you like to extend this with conditional **rollback actions** if deployment fails? 🚀