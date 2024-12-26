#!/bin/bash

# Exit on any error
set -e

# Step 1: Update Your System
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Python, Pip, and Virtual Environment
echo "Installing Python, Pip, and Virtual Environment..."
sudo apt install -y python3 python3-pip python3-venv

# Step 3: Create and Activate a Virtual Environment
echo "Creating and activating a virtual environment..."
mkdir -p ~/airflow_project
cd ~/airflow_project
python3 -m venv airflow_venv
source airflow_venv/bin/activate

# Step 4: Install Apache Airflow with Constraints
echo "Installing Apache Airflow..."
export AIRFLOW_VERSION=2.6.2
export PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
export CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

pip install --upgrade pip
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Step 5: Initialize the Database
echo "Initializing the Airflow database..."
export AIRFLOW_HOME=~/airflow
airflow db init

# Step 6: Start Airflow Services
echo "Starting the Airflow webserver and scheduler..."
airflow webserver --port 8085 &
airflow scheduler &

# Step 7: Optional - Create an Admin User
echo "Creating an Airflow admin user..."
airflow users create \
  --username admin \
  --firstname Gowtham \
  --lastname SB \
  --role Admin \
  --email test@admin.com \
  --password admin123

# Completion Message
echo "Apache Airflow installation and setup completed."
echo "Access the Airflow web interface at http://localhost:8085"
echo "use username--> admin"
echo "password--> admin123"

# Notes for User:
echo -e "\n--- Important Notes ---"
echo "1. Keep the virtual environment activated while using Airflow."
echo "2. To reactivate the environment, run:"
echo "   source ~/airflow_project/airflow_venv/bin/activate"
echo "3. To deactivate the environment, run:"
echo "   deactivate"
