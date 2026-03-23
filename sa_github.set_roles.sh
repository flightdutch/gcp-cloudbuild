# 1. Визначаємо змінні (перевірте свій ID проекту)
PROJECT_ID="project ID"
SA_NAME="service account name"
SA_EMAIL="${SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com"

# 2. Додаємо безпечний набір ролей
for role in \
    cloudfunctions.developer \
    iam.serviceAccountUser \
    resourcemanager.projectIamAdmin \
    artifactregistry.writer \
    storage.objectAdmin \
    logging.logWriter
do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/$role"
done
