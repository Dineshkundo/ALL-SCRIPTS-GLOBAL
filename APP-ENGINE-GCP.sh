# Set text styles
YELLOW=$(tput setaf 3)               # Sets the variable YELLOW to the ANSI escape code for yellow text.
BOLD=$(tput bold)                    # Sets the variable BOLD to the ANSI escape code for bold text.
RESET=$(tput sgr0)                   # Sets the variable RESET to reset text style (removes bold/yellow).

# Prompt the user to enter values
echo "Please set the below values correctly"  # Displays a message indicating inputs are needed.

# Read user input for the REGION variable
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION  # Displays a styled prompt and reads user input into the variable REGION.

# Export the REGION variable for use in subsequent commands
export REGION                        # Makes the REGION variable available to all child processes of this script.

# Print the value of the REGION variable
echo "REGION=${REGION}"              # Outputs the value of the REGION variable for confirmation.

# Authenticate with Google Cloud
gcloud auth list                     # Lists all accounts authenticated with Google Cloud CLI to verify login.

# Get the active project ID and export it
export PROJECT_ID=$(gcloud config get-value project)  # Retrieves the active project ID from gcloud config and assigns it to the PROJECT_ID variable.

# Enable the App Engine API for the active project
gcloud services enable appengine.googleapis.com  # Enables the App Engine service for the active Google Cloud project.

# Clone a repository containing Python App Engine samples
git clone https://github.com/GoogleCloudPlatform/python-docs-samples  # Clones the Google Cloud Python samples repository.

# Navigate to the Hello World example directory
cd ~/python-docs-samples/appengine/standard_python3/hello_world  # Changes directory to the App Engine "Hello World" Python sample.

# Export the PROJECT_ID variable (redundant here as it's already exported earlier)
export "PROJECT_ID=${PROJECT_ID}"    # Ensures the PROJECT_ID variable is exported in the current environment.

# Create a new App Engine application for the specified project and region
gcloud app create --project $PROJECT_ID --region=$REGION  # Creates an App Engine app in the specified region for the active project.

# Deploy the application using the app.yaml file
echo "Y" | gcloud app deploy app.yaml --project $PROJECT_ID  # Deploys the App Engine application, automatically confirming the deployment prompt with "Y".

# Change directory to ensure the current working directory is correct (redundant since it's the same directory)
cd ~/python-docs-samples/appengine/standard_python3/hello_world  # Ensures the directory is set (repetition of a previous `cd` command).

# Deploy the application with a version tag
echo "Y" | gcloud app deploy -v v1  # Deploys the app to App Engine and specifies the version as "v1", automatically confirming the deployment prompt with "Y".
