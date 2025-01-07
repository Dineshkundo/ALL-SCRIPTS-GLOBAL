# GCP Disk Labeling Automation Script

This script automates the process of labeling disks in Google Cloud Platform (GCP) based on the labels of their corresponding instances. It fetches all zones in a GCP project, retrieves instances, extracts their labels, and updates the attached disks with these labels.

```
#!/bin/bash

# Initialize arrays
zones=()
instances=()
labels=()

# Ensure the script is executed with a project name
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

# Set the project name
gcloud config set project "$1"

# Get the list of zones and store them in the zones array
mapfile -t zones < <(gcloud compute zones list --format="value(name)")

# Loop through each zone
for z in "${zones[@]}"; do
  echo "Processing zone: $z"

  # Set the current zone
  gcloud config set compute/zone "$z"

  # Fetch all instances in the current zone
  mapfile -t instances < <(gcloud compute instances list --zones="$z" --format="value(name)")

  # Loop through each instance in the zone
  for i in "${instances[@]}"; do
    echo "Processing instance: $i"

    # Fetch the labels of the instance
    labels=$(gcloud compute instances describe "$i" --zone="$z" --format="csv[no-heading](labels)")

    # If the instance has labels, update the attached disks
    if [ -n "$labels" ]; then
      # Process each label and format it correctly
      formatted_labels=$(echo "$labels" | tr ';' ',' | sed -e 's/^[[:space:]]*//')

      # Fetch attached disks
      mapfile -t disks < <(gcloud compute instances describe "$i" --zone="$z" --format="value(disks.deviceName)")

      # Loop through each disk and update its labels
      for disk in "${disks[@]}"; do
        echo "Updating labels for disk: $disk in zone: $z"
        gcloud compute disks add-labels "$disk" --zone="$z" --labels="$formatted_labels"
      done
    else
      echo "No labels found for instance: $i"
    fi
  done
done

echo "Completed labeling disks for all instances."


```

---

## Prerequisites

1. **GCP CLI Installed**: Ensure that the `gcloud` CLI is installed and configured on your machine.
2. **Authentication**: Authenticate with GCP using:
   ```bash
   gcloud auth login
   ```
3. **Project Setup**: The target project must exist, and you should have sufficient permissions to manage instances and disks.

---

## Usage

### 1. Clone or Create the Script

Save the script as `code-label-disk.sh`.

### 2. Make the Script Executable

Run the following command to make the script executable:
```bash
chmod +x code-label-disk.sh
```

### 3. Execute the Script

Provide the GCP project name as an argument:
```bash
./code-label-disk.sh <project_name>
```

Replace `<project_name>` with the GCP project ID you want to operate on.

---

## Script Workflow

1. **Project Name Validation**:
   - The script ensures that a project name is provided as an argument (`$1`).
   - Sets the project using `gcloud config set project`.

2. **Fetch Zones**:
   - Retrieves all available zones in the project and stores them in an array.

3. **Process Each Zone**:
   - Iterates through the zones.
   - Sets the current zone for processing.

4. **Fetch Instances**:
   - Retrieves the list of instances in the current zone.

5. **Fetch Labels**:
   - For each instance, retrieves its labels in CSV format.

6. **Fetch Attached Disks**:
   - Gets the list of attached disks for each instance.

7. **Update Disk Labels**:
   - Updates each disk's labels with the corresponding instance's labels.

8. **Completion**:
   - Prints a success message after processing all zones, instances, and disks.

---

## Sample Output

### Example Execution:
```bash
./code-label-disk.sh my-gcp-project
```

### Output:
```
Processing zone: us-central1-a
Processing instance: instance-1
Updating labels for disk: disk-1 in zone: us-central1-a
...
Completed labeling disks for all instances.
```

---

## Notes

- The script will skip instances without labels.
- Ensure sufficient IAM permissions for managing disks and instances.
- If you encounter errors, ensure that the `gcloud` CLI is authenticated and configured correctly.

---

## Troubleshooting

### Common Issues

1. **Invalid Project**:
   - Ensure the project name provided exists and is active.

2. **Permission Denied**:
   - Verify that your account has permissions to manage compute instances and disks.

3. **No Zones Found**:
   - Ensure the project has resources allocated to zones.

---

## License
This script is open-source and can be modified or redistributed under the MIT License.
