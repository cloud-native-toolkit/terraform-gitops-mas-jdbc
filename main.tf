locals {
  name           = "ibm-mas-jdbc"
  bin_dir        = module.setup_clis.bin_dir
  tmp_dir        = "${path.cwd}/.tmp/${local.name}"
  yaml_dir       = "${local.tmp_dir}/chart/${local.name}"
  secret_dir     = "${local.tmp_dir}/secrets"
  db_secret_name = "${var.instanceid}-jdbc-creds-${var.scope}-${var.appid}"
  workspace_name = "${var.instanceid}-${var.workspace_id}"
  jdbc_name_sffx = var.scope == "wsapp" ? "${var.workspace_id}-${var.appid}" : (var.scope == "ws" ? "${var.workspace_id}" : "${var.appid}")
  jdbc_name      = var.scope == "system" ? "${var.instanceid}-jdbc-${var.scope}" : "${var.instanceid}-jdbc-${var.scope}-${local.jdbc_name_sffx}"

  layer              = "services"
  type               = "operators"
  application_branch = "main"
  namespace          = "mas-${var.instanceid}-core"
  layer_config       = var.gitops_config[local.layer]
 
# set values content for subscription
  values_content = {
      masapp = {
        appid = var.appid
        instanceid = var.instanceid
        workspaceid = var.workspace_id
      }
      database = {
        url = var.db_url
        secretname = local.db_secret_name
        jdbcname = local.jdbc_name
        dbcert = var.db_cert
        scope = var.scope
      }
      workspace = {
        name = local.workspace_name
      }
    }
} 

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}


# Add jdbc config secret
resource null_resource create_secret {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-secret.sh '${local.namespace}' '${var.db_user}' '${var.db_password}' '${local.db_secret_name}' '${local.secret_dir}' '${local.name}-password'"
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secret]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = local.secret_dir
  dest_dir      = "${local.yaml_dir}/templates"
  kubeseal_cert = var.kubeseal_cert
  label         = local.name
} 

# Add values for charts
resource "null_resource" "setup_gitops" {
  depends_on = [module.seal_secrets]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}

# Deploy
resource gitops_module jdbcmodule {
  depends_on = [null_resource.setup_gitops]

  name        = local.name
  namespace   = local.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer       = local.layer
  type        = local.type
  branch      = local.application_branch
  config      = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}
