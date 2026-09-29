resource "libvirt_pool" "k8s_pool" {
  name = "k8s-cluster-pool"
  type = "dir"
  target = {
    path = "/var/lib/libvirt/images/k8s-cluster"
  }
}


resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-jammy-base.qcow2"
  pool   = libvirt_pool.k8s_pool.name
  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    }
  }
}

resource "libvirt_volume" "vm-master" {
  name   = "vm-master.qcow2"
  pool   = libvirt_pool.k8s_pool.name
  target = {
    format = {
      type = "qcow2"
    }
  }


  capacity = 10737418240

  backing_store = {
    path   = libvirt_volume.ubuntu_base.path
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_cloudinit_disk" "vm-master" {
  name = "vm-master-spec"

  user_data = <<-EOF
  #cloud-config
  users:
    - name: ubuntu
      sudo: ALL=(ALL) NOPASSWD:ALL
      lock_passwd: false
      shell: /bin/bash
  chpasswd:
    list: |
      ubuntu:$your-password
    expire: false
  ssh_pwauth: true
  packages:
    - openssh-server
  timezone: UTC
  EOF

  meta_data = <<-EOF
    instance-id: vm-master
    local-hostname: master
  EOF

  network_config = <<-EOF
    version: 2
    ethernets:
      interfaces:
        match:
          name: enp1s0
        dhcp4: true
  EOF
}

resource "libvirt_volume" "vm-master-cloudinit" {
  name = "vm-master-cloudinit.iso"
  pool = libvirt_pool.k8s_pool.name

  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-master.path
    }
  }
}

resource "libvirt_volume" "vm-worker1" {
  name   = "vm-worker1.qcow2"
  pool   = libvirt_pool.k8s_pool.name
  target = {
    format = {
      type = "qcow2"
    }
  }


  capacity = 10737418240

  backing_store = {
    path   = libvirt_volume.ubuntu_base.path
    format = {
      type = "qcow2"
    }
  }
}



resource "libvirt_cloudinit_disk" "vm-worker1" {
  name = "vm-worker1-spec"

  user_data = <<-EOF
  #cloud-config
  users:
    - name: ubuntu
      sudo: ALL=(ALL) NOPASSWD:ALL
      lock_passwd: false
      shell: /bin/bash
  chpasswd:
    list: |
      ubuntu:$your-password
    expire: false
  ssh_pwauth: true
  packages:
    - openssh-server
  timezone: UTC
  EOF

  meta_data = <<-EOF
    instance-id: vm-worker1
    local-hostname: worker
  EOF


  network_config = <<-EOF
    version: 2
    ethernets:
      interfaces:
        match:
          name: enp1s0
        dhcp4: true
  EOF
}

resource "libvirt_volume" "vm-worker1-cloudinit" {
  name = "vm-worker1-cloudinit.iso"
  pool = libvirt_pool.k8s_pool.name


  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-worker1.path
    }
  }
}

resource "libvirt_volume" "vm-worker2" {
  name   = "vm-worker2.qcow2"
  pool   = libvirt_pool.k8s_pool.name
  target = {
    format = {
      type = "qcow2"
    }
  }


  capacity = 10737418240

  backing_store = {
    path   = libvirt_volume.ubuntu_base.path
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_cloudinit_disk" "vm-worker2" {
  name = "vm-worker2-spec"

  user_data = <<-EOF
  #cloud-config
  users:
    - name: ubuntu
      sudo: ALL=(ALL) NOPASSWD:ALL
      lock_passwd: false
      shell: /bin/bash
  chpasswd:
    list: |
      ubuntu:$your-password
    expire: false
  ssh_pwauth: true
  packages:
    - openssh-server
  timezone: UTC
  EOF

  meta_data = <<-EOF
    instance-id: vm-worker2
    local-hostname: worker2
  EOF


  network_config = <<-EOF
    version: 2
    ethernets:
      interfaces:
        match:
          name: enp1s0
        dhcp4: true
  EOF
}

resource "libvirt_volume" "vm-worker2-cloudinit" {
  name = "vm-worker2-cloudinit.iso"
  pool = libvirt_pool.k8s_pool.name


  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-worker2.path
    }
  }
}
