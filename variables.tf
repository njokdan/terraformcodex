variable "app_names" {
  type = list(string)
  default = ["app1", "app2", "app3", "app4"]
}

variable "repos" {
  type = list(string)
  default = {
    app1 = "https://dev.azure.com/oluseunismaila/Daniel/_git/dotnetapp1",
    app2 = "https://dev.azure.com/oluseunismaila/Daniel/_git/dotnetapp2",
    app3 = "https://dev.azure.com/oluseunismaila/Daniel/_git/dotnetapp3",
    app4 = "https://dev.azure.com/oluseunismaila/Daniel/_git/dotnetapp4"
  }
}
