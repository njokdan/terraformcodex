locals {
  build_steps = [
    {
      task = "DotNetCoreCLI@2"
      inputs = {
        command = "build"
        projects = "$(System.DefaultWorkingDirectory)/**/*.csproj"
        arguments = "--configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)"
      }
    },
    {
      task = "PublishBuildArtifacts@1"
      inputs = {
        pathToPublish = "$(Build.ArtifactStagingDirectory)"
        artifactName = "drop"
      }
    }
  ]

  release_steps = [
    {
      task = "AzureWebApp@1"
      inputs = {
        azureSubscription = "a5e83a03-cc48-4cc8-874a-27c7c7a8bc34"
        appName = "${var.app_names[count.index]}-app"
        package = "$(System.DefaultWorkingDirectory)/**/*.zip"
      }
    }
  ]
}

resource "azuredevops_build_definition" "build_definition" {
  count = length(var.app_names)

  name        = "${var.app_names[count.index]}-build"
  repository  = azuredevops_git_repository.repository[count.index]
  project_id  = "Daniel"
  yaml_path   = "azure-pipelines.yml"
  steps       = local.build_steps
}

resource "azuredevops_release_definition" "release_definition" {
  count = length(var.app_names)

  name            = "${var.app_names[count.index]}-release"
  build_definition = azuredevops_build_definition.build_definition[count.index].id
  project_id      = "Daniel"
  environment {
    name = "prod"
    deployment_job {
      name = "Deployment"
      steps = local.release_steps
    }
  }
}

resource "azuredevops_git_repository" "repository" {
  count = length(var.app_names)

  name    = "${var.app_names[count.index]}-repo"
  project = "Daniel"
  url     = lookup(var.repos, var.app_names[count.index])
}
