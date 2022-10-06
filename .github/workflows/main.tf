name: IaC Lifecycle

on:
  push:
    branches:
    - main

jobs:

  job-Terraform_Apply:
    runs-on: ubuntu-latest
 
    steps:

    - name: Step 01 - Terraform Install
      env :
        TERRAFORM_VERSION: "1.2.7"
      run : |
        tf_version=$TERRAFORM_VERSION
        wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
        unzip terraform_"$tf_version"_linux_amd64.zip
        sudo mv terraform /usr/local/bin/

    - name: Step 02 - Terraform Version
      run : terraform --version

    - name: Step 03 - CheckOut GitHub Repo
      uses: actions/checkout@v1

    - name: Step 04 - Set AWS Account
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id    : ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-session-token    : ${{ secrets.AWS_SESSION_TOKEN }}
        aws-region           : us-east-1

    - name: Step 05 - Terraform Init
      run : terraform -chdir=./terraform init -input=false

    - name: Step 06 - Terraform Validate
      run : terraform -chdir=./terraform validate

    - name: Step 07 - Terraform Plan
      run : terraform -chdir=./terraform plan -input=false

    - name: Step 08 - Terraform Apply
      run : terraform -chdir=./terraform apply -auto-approve -input=false

    - name: Step 09 - Terraform Show
      run : terraform -chdir=./terraform show