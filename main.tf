provider "google" {
  credentials = file("/home/username/resolute-tracer-xxxxx.json")
  project     = "resolute-tracer-xxxxx"
  
}

resource "google_compute_instance" "test-instance-2" {
  boot_disk {
    auto_delete = true
    device_name = "test-instance-2"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240426"
      size  = 20
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  #2 is 2vCPU, 5632/1024=5.5GB Memory
  machine_type = "e2-custom-2-5632"

  metadata = {
    ssh-keys = ""
  }

  name = "test-instance"

  network_interface {
    access_config {
      #network_tier = "PREMIUM"  #Traffic traverses Google's high quality global backbone, entering and exiting at Google edge peering points closest to the user
      network_tier = "STANDARD" #200 GB / mo free in every region
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/resolute-tracer-xxxxx/regions/asia-east2/subnetworks/lfclass"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "779554249180-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "asia-east2-a"
}
