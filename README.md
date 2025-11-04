# HCL AppScan and GitLab
Your code is better and more secure with HCL AppScan.

You can use HCL AppScan with GitLab to run static analysis security testing (SAST) against the files in your repository on every merge request, thus preventing vulnerabilities from reaching the main branch. Results are stored in HCL AppScan.

# Usage
## Register
If you don't have an account, register on [HCL AppScan](https://www.hcltechsw.com/appscan/codesweep-for-github) to generate your API key and API secret.

## Setup
1. Generate your API key and API secret on [the API page](https://cloud.appscan.com/main/settings).
   - The API key and API secret map to the `APPSCAN_KEY` and `APPSCAN_SECRET` parameters for this action. Make note of the key and secret.
   
2. Create the [application](https://help.hcltechsw.com/appscan/ASoC/ent_create_application.html) in AppScan. 
   - Applications act as a container to store all scans that are related to the same project.
   
3. Copy the application ID. Select **Application >** **&lt;your application&gt;** and then click **Copy** next to **Application ID** under **Application details**.
   - The application ID in AppScan maps to `APP_ID` for this integration.
   
   ![APP_ID](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/img/appid.png)

4. Create three variables in GitLab. Select **Settings > CI/CD > Variables**, and set the variables as follows:

   ### Required Inputs
   | Name |   Description    |
   |    :---:    |    :---:    |
   | APPSCAN_KEY | Your API key from [the API page](https://cloud.appscan.com/main/settings) |
   | APPSCAN_SECRET | Your API secret from [the API page](https://cloud.appscan.com/main/settings) |
   | APP_ID | The ID of the application in ASoC |
   
   ![variables](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/img/variables.png)

5. Copy [.gitlab-ci.yaml](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/.gitlab-ci.yaml) and [Dockerfile](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/Dockerfile) into your GitLab repository root.

6. Build your own runner. Select **Settings > CI/CD >** Runners and follow the steps under **Specific Runners**.

7. On the system on which you are setting up the GitLab runner, log in and clone your GitLab repository if one does not already exist. Ensure that a Docker engine is installed on that machine.

8. Build a new Docker image called **saclient** from the Dockerfile. Change directory to the root of the repository and run the following command to build the Docker image:

   `docker build -t saclient .`
   
   **Important:** The period at the end indicates the current directory.
   
9. In GitLab, to prevent merges if the scan fails, enable **Pipelines must succeed** at **Settings > Merge requests > Merge checks**.

10. Verify a new scan job is initiated when new merge requests are created at **Settings > CI/CD > Pipelines**.

    ### Example
    
    If you are installing GitLab runner on CentOS, build a runner as follows:
    
    1. Download the binary for your systems
    
       `sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64`
    
    2. Set permission to execute:
    
       `sudo chmod +x /usr/local/bin/gitlab-runner`
    
    3. Create a GitLab Runner user:
    
       `sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash`
    
    4. Install and run as a service:
    
       ```
       sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner 
       sudo gitlab-runner start
       ```
    
    5. Register the runner:

       `sudo gitlab-runner register --url https://gitlab.com/ --registration-token $REGISTRATION_TOKEN`
       
## Additional Information
The current [yaml](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/.gitlab-ci.yaml) script contains a sample of a security policy check that fails the scan if the number of allowed security issues exceeds a certain threshold. The sample has `maxIssuesAllowed` set to `200`.
