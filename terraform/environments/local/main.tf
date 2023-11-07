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
  name    = "ja-network"
  driver  = "bridge"
}

/**
 * DATABASE
 */
data "docker_image" "database_image" {
  name = "mongo:6-jammy"
}

resource "docker_volume" "database_volume" {
  name = "ja-database-volume"
}

resource "docker_container" "database" {
  name  = "ja-database"
  image = data.docker_image.database_image.id
  command = ["--replSet", "rs0", "--bind_ip_all"]
  restart = "always"
  
  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "27017"
    external = "27017"
  }

  volumes {
    volume_name = docker_volume.database_volume.name
    container_path = "/data/db"
  }
}

resource "docker_container" "mongoinit" {
  name = "ja-database-mongoinit"
  image = data.docker_image.database_image.id
  restart = "no"
  must_run = false

  depends_on = [docker_container.database]

  command = [
    "mongosh",
    "--host",
    docker_container.database.name,
    "--eval",
    "'rs.initiate({_id: 'rs0', members: [{_id: 0, host: '${docker_container.database.name}:27017'}] });'"
  ]

  networks_advanced {
    name = docker_network.network.id
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

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(var.service_folder[var.service_type], "/*") : filesha1("${var.service_folder[var.service_type]}/${f}")]))
  }
}

resource "docker_container" "service" {
  name = "ja-service"
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
    context = var.web_demo_folder
    tag     = ["web-demo:dev"]
  }

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(var.web_demo_folder, "/*") : filesha1("${var.web_demo_folder}/${f}")]))
  }
}

resource "docker_container" "web_demo" {
  name = "ja-web-demo"
  image = docker_image.web_demo.image_id

  env  = [
    "REACT_APP_SERVICE_URL=http://localhost:${docker_container.service.ports[0].external}",
    "REACT_APP_POLLING_TIME=${var.web_demo_polling_time}"
  ]

  networks_advanced {
    name = docker_network.network.id
  }

  ports {
    internal = "3000"
    external = "3001"
  }
}
