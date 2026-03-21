# gcp-cloudbuild using github-push trigger
test how to use github-cloudbuild (http-trigger)


## Cloud Build:
  Triggers - Manage repositories: build connect GCP-github repo
  Triggers - Create trigger: when run build

## IAM - Service Accounts: create github account and add Roles:
  Cloud Function Developer
  Service Account User

## Essential roles for deployment:
- Cloud Functions Developer (roles/cloudfunctions.developer): Allows you to create, update, and delete functions.

- Service Account User (roles/iam.serviceAccountUser): Critical. Allows Cloud Build to "impersonate" the function's runtime account when deploying it.

- Artifact Registry Writer (roles/artifactregistry.writer): Cloud Functions 2nd Gen (which is now the standard) creates a Docker image of your code and stores it in the Artifact Registry. Without this role, the build will fail at the image upload stage.

## Roles for logging and building
- Logs Writer (roles/logging.logWriter): Allows you to write the execution logs of Cloud Build itself to Cloud Logging (fixes your initial error).

- Storage Object Viewer (roles/storage.objectViewer): For reading the source code that Cloud Build loads into a temporary bucket before deployment.

##assign these roles via terminal (replace PROJECT_ID and SA_EMAIL with your data):
### Allow functions to be managed
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:SA_EMAIL" \
    --role="roles/cloudfunctions.developer"

### Allow service accounts to be used
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:SA_EMAIL" \
    --role="roles/iam.serviceAccountUser"

### Allow logging
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:SA_EMAIL" \
    --role="roles/logging.logWriter"

### Allow work with the image repository
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:SA_EMAIL" \
    --role="roles/artifactregistry.writer"

### show enabled services
 gcloud services list --enabled
