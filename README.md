### FILES

- main.tf
- variables.tf
- terraform.tfvars
- output.tf
- azure-pipeline.yaml

### VARIABLES

- subscription id
- resource group name
- vnet name
- subnet name

## EXPLANATION OF EACH FILE

#### Terraform Files

1. **`main.tf`**:

   - **Purpose**: This file contains the main Terraform configuration.
   - **Components**:
     - **Provider**: Specifies the Azure provider for Terraform.
     - **Resources**:
       - `azurerm_virtual_machine`: Defines the VM resource.
       - `azurerm_network_interface`: Defines the network interface for the VM.
     - **Data Source**:
       - `azurerm_subnet`: Fetches existing subnet information.
   - **Flow**: When applied, this configuration will create a VM and its associated network interface in the specified subnet and resource group.

2. **`variables.tf`**:

   - **Purpose**: Defines the variables used in the Terraform configuration.
   - **Components**:
     - Variables such as `subscription_id`, `resource_group_name`, `vnet_name`, `subnet_name`, `vm_name`, `location`, `vm_size`, `admin_username`, and `admin_password`.
   - **Flow**: Provides a way to parameterize the Terraform configuration, making it reusable and configurable.

3. **`terraform.tfvars`**:

   - **Purpose**: Contains the values for the variables defined in `variables.tf`.
   - **Components**:
     - Assigns actual values to the variables, e.g., `subscription_id`, `resource_group_name`, etc.
   - **Flow**: When Terraform runs, it uses these values to replace the placeholders in the configuration.

4. **`output.tf`**:
   - **Purpose**: Defines the outputs of the Terraform configuration.
   - **Components**:
     - `vm_id`: Outputs the ID of the created VM.
   - **Flow**: After Terraform applies the configuration, it will display the VM ID.

#### Azure Pipeline File

1. **`azure-pipeline.yaml`**:
   - **Purpose**: Defines the Azure Pipeline that runs the Terraform configuration.
   - **Components**:
     - **Trigger**: Specifies when the pipeline should run (e.g., on commits to the master branch).
     - **Pool**: Defines the VM image for the build agent.
     - **Variables**: Defines pipeline variables, including the Terraform version.
     - **Stages**:
       - **Initialize**:
         - **Job: Init**: Installs Terraform and initializes the Terraform configuration.
       - **UserInput**:
         - **Job: WaitForUserInput**: Pauses the pipeline and waits for user input.
       - **ApplyOrDestroy**:
         - **Job: Terraform**: Based on user input, either applies the Terraform configuration to create resources or destroys them.

### Flow Explanation

1. **Trigger and Initialization**:

   - The pipeline is triggered by a commit to the main branch.
   - The `Initialize` stage runs, installing Terraform and initializing the Terraform configuration using `terraform init`.

2. **Manual Validation (User Input)**:

   - The `UserInput` stage runs next, where the `ManualValidation` task pauses the pipeline and notifies the specified user(s) to provide input.
   - The user receives an email or notification and needs to go to the Azure DevOps portal to provide the input (create or destroy).

3. **Applying or Destroying Resources**:

   - Based on the user input, the `ApplyOrDestroy` stage executes:
     - If the user input is `create`, Terraform applies the configuration (`terraform apply -auto-approve`), creating the VM and associated resources.
     - If the user input is `destroy`, Terraform destroys the resources (`terraform destroy -auto-approve`).

4. **Outputs**:
   - After applying or destroying the resources, the pipeline outputs the VM ID (if created) or confirms destruction.

### Example Run

1. **Commit and Push**:

   - You commit changes to the repository, triggering the pipeline.

2. **Pipeline Initialization**:

   - The `Initialize` stage runs, setting up Terraform.

3. **User Input**:

   - The pipeline pauses at the `UserInput` stage, waiting for you to provide input (create or destroy).

4. **Creation/Destruction**:

   - Based on your input, the `ApplyOrDestroy` stage runs, either creating or destroying the VM.

5. **Completion**:
   - The pipeline completes, providing outputs such as the VM ID or confirmation of resource destruction.

By following this structured approach, you can effectively manage the lifecycle of your Azure resources using Terraform and Azure Pipelines, ensuring that resources are created or destroyed based on real-time user input during pipeline execution.

## HOW TO USE THIS REPO TO CREATE PRIVATE VM ON AZURE PIPELINE

#### Steps to Run the Pipeline

> Create and Push the Files:

- Create the Terraform files and the azure-pipeline.yaml file in your local repository.
  Push the files to your Azure DevOps repository.

> Configure the Service Connection:

- In Azure DevOps, go to your project settings.
  Under Pipelines, select Service connections.
  Create a new service connection to your Azure subscription.

> Steps to Add Variables in Azure DevOps Portal:

1. Click on the Variables tab in your pipeline.
2. Click on + New variable.
3. Enter the variable name (e.g., subscription_id) and value.
4. Repeat for all variables (resource_group_name, vnet_name, subnet_name, admin_password).
5. For sensitive variables like admin_password, mark them as secret.

**`Option 2:`** **Hardcoding Values in terraform.tfvars**

> Run the Pipeline:

- Navigate to your Azure DevOps project.
  Go to Pipelines and create a new pipeline.
  Select the repository and the azure-pipeline.yaml file.
  Run the pipeline.

> Manual Validation:

- When the pipeline reaches the ManualValidation step, it will pause and notify the specified user.
  The user will need to go to the Azure DevOps portal and provide the required input (create or destroy).

> Resume and Complete the Pipeline:

- Based on the user input, the pipeline will either create or destroy the VM.

### NOTE

> Azure Pipelines does not natively support capturing user input during pipeline execution as dynamic variables directly within the pipeline YAML. The above configuration uses a notification method where the user has to manually intervene in the Azure DevOps portal. If you need more complex user input handling directly within the pipeline, consider integrating with Azure Logic Apps, Azure Functions, or other external systems that can handle user input and pass the information back to the pipeline.
