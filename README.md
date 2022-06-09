#  Maximo Application Suite - JDBC Gitops terraform module

Configures a JDBC resource for a Maximo Application Suite deployment.  This will currently create the resources within the MAS Core namespace given an `instanceid` provided.  The configuration is installed with workspace scope within the provided `workspaceid`.

The configuration scope by default is `workspace-application`, if you need another scope then set the `scope` variable when invoking the module.

Note if your cluster is not setup for gitops, download the gitops bootstrap BOM from the module catalog first to setup the gitops tooling.

## Supported platforms

- OCP 4.6+

## Suggested companion modules

The module itself requires some information from the cluster and needs a
namespace to be created. The following companion
modules can help provide the required information:

- Gitops:  github.com/cloud-native-toolkit/terraform-tools-gitops
- Gitops Bootstrap: github.com/cloud-native-toolkit/terraform-util-gitops-bootstrap

## Example usage

```hcl-terraform
module "mas_jdbc" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-mas-jdbc"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert

  instanceid = "masdemo"
  workspace_id = "demo"

  db_user = var.database_username
  db_password = var.database_password
  db_cert = var.database_cert
  db_url = var.database_url 

}
```
