# gcp-cloudbuild using github-push trigger
test how to use github-cloudbuild (http-trigger)

GCP Cloud build: Building path of your code:
GitHub ➔ Cloud Build (Trigger) ➔ Cloud Storage (Source Code) ➔ Cloud Build (Worker/Docker) ➔ Artifact Registry (Runtime Image)➔ Cloud Functions.

## Cloud Build:
  Triggers - Manage repositories: build connect GCP-github repo
  Triggers - Create trigger: when run build

## Service API

### show enabled services API
gcloud services list --enabled

## Build Function: Service-account
IAM -> Service account > Create
name: sa_github

### Build Function - sa_github: Roles:

Service name    Role Name                         Role ID/Description
---------------------------------------------------------------------------------------------------------------------------------------------------
Functions	      Cloud Functions Developer	        roles/cloudfunctions.developer
                                                  Allows you to create, update, and delete functions.
IAM	            Service Account User	            roles/iam.serviceAccountUser
                                                  Critical. Allows Cloud Build to "impersonate" the function's runtime account when deploying it.
IAM	            Project IAM Admin	                roles/resourcemanager.projectIamAdmin
                                                  (Optional) To automatically configure --allow-unauthenticated.
Registry	      Artifact Registry Writer	        roles/artifactregistry.writer
                                                  Uploading the assembled Docker image to the registry.
                                                  Cloud Functions 2nd Gen (which is now the standard) creates a Docker image of your code and stores it in the Artifact Registry. Without this role, the build will fail at the image upload stage.
Build	          Cloud Build Service Agent	        roles/cloudbuild.serviceAgent
Storage	        Storage Admin	                    roles/storage.admin
                                                  Uploading a .zip archive with the code to Cloud Storage.
                                                  grant the Admin-role not to the entire project, but only to a specific bucket where the function code is stored.
Logging	        Logs Writer	                      roles/logging.logWriter
                                                  Recording logs of the build process itself (Build Logs).
                                                  Allows you to write the execution logs of Cloud Build itself to Cloud Logging (fixes your initial error).

### Bulding - Check roles:
gcloud projects get-iam-policy test-cloud-run-490713 \
--flatten="bindings[].members" \
--format="table(bindings.role, bindings.members)" \
--filter="bindings.members:(sa-github@test-cloud-run-490713.iam.gserviceaccount.com)"


## Runtime Service Account
IAM -> Service account > Create
name: sa_run

### Run Function - sa_run_function: Roles:

Service name    Role Name                         Role ID/Description
---------------------------------------------------------------------------------------------------------------------------------------------------
Logging         Logs Writer                       roles/logging.logWriter
                                                  Дозволяє функції писати власні логи (console.log).
Tracer          Cloud Trace Agent	                roles/cloudtrace.agent
                                                  (Рекомендовано) Для відстеження часу виконання запитів.

Running - check roles:
gcloud projects get-iam-policy test-cloud-run-490713 \
--flatten="bindings[].members" \
--format="table(bindings.role, bindings.members)" \
--filter="bindings.members:(sa-func-runtime@test-cloud-run-490713.iam.gserviceaccount.com)"

Binding Service Accounts:
надаємо роль iam.serviceAccountUser саме на ресурс акаунта func-runtime
gcloud iam service-accounts add-iam-policy-binding \
    func-runtime@test-cloud-run-490713.iam.gserviceaccount.com \
    --member="serviceAccount:github@test-cloud-run-490713.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

Bindig Service Accountі - check status:
Ми перевіряємо, чи має право акаунт деплою (github) виступати від імені рантайм-акаунта (func-runtime).
gcloud iam service-accounts get-iam-policy func-runtime@test-cloud-run-490713.iam.gserviceaccount.com \
    --format="table(bindings.role, bindings.members)"
