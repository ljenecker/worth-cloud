# Worth

> Note: There is a known bug where the first commit to a GitHub repository with a on: push: event workflow results in that action being executed twice. As a workaround, uncomment the rest of the github workflow code on the 2nd commit. see [Discussion](https://github.com/orgs/community/discussions/50356)

Features:

1. Utilizes GitHub Actions for Terraform infrastructure setup.

2. Employs AWS Code Pipelines for managing CI/CD of a Node.js application.


To deploy the Terraform project, do the following:

1. Create a new Github private repository.

2. Create github token.

3. AWS account with administrator role access.

4. Create GitHub Secrets for AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, GH_TOKEN and PG_TOKEN (postgress).

5. Clone source code.

6. Push source code to new private repository.

7. Uncomment github workflow prerequisite.yaml and push changes.

8. Uncomment cicd.tf and push changes.

9. Retrieve loadbalancer URL to access the application.

9. On Home Page, press Migrate Data. All users have `password` as their password