
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

/*variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}*/

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "appid" {
  type        = string
  description = "MAS AppID to deploy.  Expects: manage"
  default     = "manage"
}

variable "workspace_id" {
  type = string
  description = "MAS workspace id"
  
}

variable "db_user" {
  type = string
  sensitive = true
  description = "database connection username"

}

variable "db_password" {
  type = string
  sensitive = true
  description = "database connection password"
  
}

variable "db_cert" {
  type = string
  sensitive = true
  description = "database connection public cert"
  
}

variable "db_url" {
  type = string
  sensitive = true
  description = "database connection url"
  
} 