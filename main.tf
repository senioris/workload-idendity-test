terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.8.0"
    }
  }
  required_version = "~> 1.9.7"

  backend "gcs" {
    bucket                      = "terrafom-backend-1259452"
    impersonate_service_account = "terraform@ageless-domain-442510-j3.iam.gserviceaccount.com"
  }  
}

locals {
  project_id = "ageless-domain-442510-j3"
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = "terraform@ageless-domain-442510-j3.iam.gserviceaccount.com"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3600s"
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

provider "google" {
  project         = local.project_id
  region          = "asia-northeast2"
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

resource "google_storage_bucket" "default" {
  name                        = "terraform-test-2138401367091"
  location                    = "asia-northeast1"
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}