# DEVSHELL: Refers to the Google Cloud Shell environment.
# PROJECT_ID: The ID of the active project you're working with in Google Cloud.
# Set text styles
YELLOW=$(tput setaf 3)    # Defines a variable for yellow text color using `tput`.
BOLD=$(tput bold)         # Defines a variable for bold text using `tput`.
RESET=$(tput sgr0)        # Defines a variable to reset text styles to normal.

# Prompt the user to enter a region
echo "Please set the below values correctly"  # Displays a message to the user.
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION  # Prompts the user to input the region and stores it in the `REGION` variable.

# Export variables after collecting input
export REGION            # Exports the `REGION` variable to make it available for child processes.

# Enable the Google Cloud SQL Admin API
gcloud services enable sqladmin.googleapis.com  # Enables the Cloud SQL Admin API to allow Cloud SQL operations.

# Create a Cloud SQL instance
gcloud sql instances create my-instance --project=$DEVSHELL_PROJECT_ID --database-version=MYSQL_5_7 --tier=db-n1-standard-1  
# Creates a Cloud SQL instance named `my-instance` in the active project, with MySQL version 5.7 and `db-n1-standard-1` machine type.

# Create a MySQL database in the Cloud SQL instance
gcloud sql databases create mysql-db --instance=my-instance --project=$DEVSHELL_PROJECT_ID  
# Creates a database named `mysql-db` in the `my-instance` Cloud SQL instance.

# Create a BigQuery dataset
bq mk --dataset $DEVSHELL_PROJECT_ID:mysql_db  
# Creates a BigQuery dataset named `mysql_db` in the active project.

# Create a table in the BigQuery dataset
bq query --use_legacy_sql=false \
"CREATE TABLE \`${DEVSHELL_PROJECT_ID}.mysql_db.info\` (
  name STRING,
  age INT64,
  occupation STRING
);"  
# Executes a SQL query to create a table named `info` in the BigQuery dataset `mysql_db` with columns: `name`, `age`, and `occupation`.

# Create a CSV file containing employee information
cat > employee_info.csv <<EOF_CP
"Sean", 23, "Content Creator"
"Emily", 34, "Cloud Engineer"
"Rocky", 40, "Event coordinator"
"Kate", 28, "Data Analyst"
"Juan", 51, "Program Manager"
"Jennifer", 32, "Web Developer"
EOF_CP  
# Writes the employee data into a file named `employee_info.csv`.

# Create a Cloud Storage bucket
gsutil mb gs://$DEVSHELL_PROJECT_ID  
# Creates a Google Cloud Storage bucket named after the active project ID.

# Upload the CSV file to the Cloud Storage bucket
gsutil cp employee_info.csv gs://$DEVSHELL_PROJECT_ID/  
# Copies the `employee_info.csv` file to the created Cloud Storage bucket.

# Get the service account email of the Cloud SQL instance
SERVICE_EMAIL=$(gcloud sql instances describe my-instance --format="value(serviceAccountEmailAddress)")  
# Fetches the service account email associated with the Cloud SQL instance `my-instance`.

# Assign the storage admin role to the Cloud SQL instance's service account for the Cloud Storage bucket
gsutil iam ch serviceAccount:$SERVICE_EMAIL:roles/storage.admin gs://$DEVSHELL_PROJECT_ID/  
# Grants the Cloud SQL instance's service account `roles/storage.admin` permissions on the bucket.
