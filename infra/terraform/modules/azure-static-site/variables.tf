variable "project_name" {
  description = "Project name prefix used in resource naming."
  type        = string
}

variable "suffix" {
  description = "Random suffix to ensure globally unique names."
  type        = string
}

variable "location" {
  description = "Azure region where resources are deployed."
  type        = string
}

variable "index_html" {
  description = "HTML content uploaded to index.html."
  type        = string
}

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
}
