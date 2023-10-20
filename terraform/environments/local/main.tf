terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

/**
 * NETWORK
 */
resource "docker_network" "network" {
  name    = "jobs-aggregator-network"
  driver  = "bridge"
}

/**
 * DATABASE
 */
resource "docker_container" "database" {
  name  = "database"
  image = "mongo:6-jammy"
  
  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "27017"
    external = "27017"
  }
}

/**
 * SERVICE
 */
resource "docker_image" "service" {
  name = "service"

  build {
    context = var.service_folder[var.service_type]
    tag     = ["service:dev"]
  }
}

resource "docker_container" "service" {
  name = "service"
  image = docker_image.service.image_id
  
  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "3000"
    external = "3000"
  }
}

/**
 * WEB DEMO
 */
resource "docker_image" "web_demo" {
  name = "web-demo"

  build {
    context = "../../../../jobs-aggregator-web-demo"
    tag     = ["web-demo:dev"]
  }
}

resource "docker_container" "web_demo" {
  name = "web-demo"
  image = docker_image.web_demo.image_id

  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "3000"
    external = "3001"
  }
}
