# HCL AppScan and GitLab
Your code is better and more secure with HCL AppScan.

You can use HCL AppScan with GitLab to run static analysis security testing (SAST) against the files in your repository on every merge request, thus preventing vulnerabilities from reaching the main branch. Results are stored in AppScan.

# Usage
## Register
If you don't have an account, register on [HCL AppScan on Cloud (ASoC)](https://www.hcltechsw.com/appscan/codesweep-for-github) to generate your API key and API secret.

## Setup
1. Generate your API key and API secret on [the API page](https://cloud.appscan.com/main/settings).
  - The API key and API secret map to the `APPSCAN_KEY` and `APPSCAN_SECRET` parameters for this action. Make note of the key and secret.

2. Create the [application](https://help.hcltechsw.com/appscan/ASoC/ent_create_application.html) in AppScan. 
  - Applications act as a container to store all scans that are related to the same project.

3. Copy the application name.
  - The application name in ASoC maps to `APP_NAME` for this integration.

  ![APP_ID](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/img/app_name.png)

4. Create variables in GitLab. Select **Settings > CI/CD > Variables**, and set the variables as follows:

  ### SAST Required Inputs
  | Name |   Description    |
  |    :---:    |    :---:    |
  | APPSCAN_KEY | Your API key from [the API page](https://cloud.appscan.com/main/settings) |
  | APPSCAN_SECRET | Your API secret from [the API page](https://cloud.appscan.com/main/settings) |
  | APP_NAME | The name of the application in AppScan |
  | APPSCAN_ASSET | The ID of the asset group in AppScan |

  ### DAST Required Inputs
  | Name |   Description    |
  |    :---:    |    :---:    |
  | APPSCAN_KEY | Your API key from [the API page](https://cloud.appscan.com/main/settings) |
  | APPSCAN_SECRET | Your API secret from [the API page](https://cloud.appscan.com/main/settings) |
  | APP_NAME | The name of the application in AppScan |
  | APPSCAN_ASSET | The ID of the asset group in AppScan |

  ![variables](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/img/ci_cd_variables.png)

5. Copy [.gitlab-ci.yaml](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/.gitlab-ci.yaml) and [Dockerfile](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/Dockerfile) into your GitLab repository root.

6. Build your own runner. Select **Settings > CI/CD >** Runners and follow the steps under **Specific Runners**.

7. On the system on which you are setting up the GitLab runner, log in and clone your GitLab repository if one does not already exist. Ensure that a Docker engine is installed on that machine.

8. Build a new Docker image called **saclient** from the Dockerfile. Change directory to the root of the repository and run the following command to build the Docker image:

  `docker build -t saclient .`

   **Important:** The period at the end indicates the current directory.

9. In GitLab, to prevent merges if the scan fails, enable **Pipelines must succeed** at **Settings > Merge requests > Merge checks**.

10. Verify a new scan job is initiated when new merge requests are created at **Settings > CI/CD > Pipelines**.

  Scan Job
  ![image](https://user-images.githubusercontent.com/69405400/144601178-9bc8c675-a2dd-44c4-a312-908800be1472.png)

  Artifact downloadable
  ![image](https://user-images.githubusercontent.com/69405400/144601700-40bfa642-a776-4e4f-ba05-e96f4324ef19.png)

  Scan passed based on maxIssuesAllowed
  ![image](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/img/scan_passed.png)

## Additional Information
The current [yaml](https://github.com/HCL-TECH-SOFTWARE/appscan-gitlab-integration/blob/main/.gitlab-ci.yaml) script contains a sample of a security policy check that fails the scan if the number of allowed security issues exceeds a certain threshold. The sample has `maxIssuesAllowed` set to `200`.
