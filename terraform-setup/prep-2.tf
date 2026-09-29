resource "libvirt_volume" "vm-master-cluster-2" {
  name   = "vm-master-cluster-2.qcow2"
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

resource "libvirt_cloudinit_disk" "vm-master-cluster-2" {
  name = "vm-master-cluster-2-spec"

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
    instance-id: vm-master-cluster-2
    local-hostname: master-cluster-2
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

resource "libvirt_volume" "vm-master-cluster-2-cloudinit" {
  name = "vm-master-cluster-2-cloudinit.iso"
  pool = libvirt_pool.k8s_pool.name

  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-master-cluster-2.path
    }
  }
}

resource "libvirt_volume" "vm-worker1-cluster-2" {
  name   = "vm-worker1-cluster-2.qcow2"
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



resource "libvirt_cloudinit_disk" "vm-worker1-cluster-2" {
  name = "vm-worker1-cluster-2-spec"

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
    instance-id: vm-worker1-cluster-2
    local-hostname: worker-cluster-2
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

resource "libvirt_volume" "vm-worker1-cluster-2-cloudinit" {
  name = "vm-worker1-cloudinit-cluster-2.iso"
  pool = libvirt_pool.k8s_pool.name


  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-worker1-cluster-2.path
    }
  }
}

resource "libvirt_volume" "vm-worker2-cluster-2" {
  name   = "vm-worker2-cluster-2.qcow2"
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

resource "libvirt_cloudinit_disk" "vm-worker2-cluster-2" {
  name = "vm-worker2-cluster-2spec"

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
    instance-id: vm-worker2-cluster-2
    local-hostname: worker2-cluster-2
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

resource "libvirt_volume" "vm-worker2-cluster-2-cloudinit" {
  name = "vm-worker2-cloudinit-cluster-2.iso"
  pool = libvirt_pool.k8s_pool.name


  create = {
    content = {
      url = libvirt_cloudinit_disk.vm-worker2-cluster-2.path
    }
  }
}
