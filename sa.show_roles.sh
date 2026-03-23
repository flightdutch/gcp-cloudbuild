# 1. Визначаємо змінні (перевірте свій ID проекту)
PROJECT_ID="project ID"
SA_NAME_BUILD="sa_build"
SA_EMAIL_BUILD="${SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com"

echo "--- Build Account metadata ---"
gcloud iam service-accounts describe ${SA_EMAIL_BUILD}
echo ""

echo "--- ROLES FOR BUILD ACCOUNT ---"
gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --format="table(bindings.role)" \
    --filter="bindings.members:serviceAccount:${SA_EMAIL_BUILD}"
echo ""

SA_NAME_RUN="sa_run_function"
SA_EMAIL_RUN="${SA_NAME_RUN}@$PROJECT_ID.iam.gserviceaccount.com"

echo "--- RUNTIME Account metadata ---"
gcloud iam service-accounts describe ${SA_EMAIL_RUN}
echo ""

echo "--- ROLES FOR RUNTIME ACCOUNT ---"
gcloud projects get-iam-policy $PROJECT_ID \
    --flatten="bindings[].members" \
    --format="table(bindings.role)" \
    --filter="bindings.members:serviceAccount:${SA_EMAIL_RUN}"
