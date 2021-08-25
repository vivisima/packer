
source "amazon-ebs" "basic-example" {
  region =  "us-west-2"
  source_ami_filter {
    filters = {
        virtualization-type = "hvm"
        name = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
        root-device-type = "ebs"
    }
    owners = ["099720109477"]
    most_recent = true
  }
  instance_type =  "t2.micro"
  ssh_username =  "ubuntu"
  ami_name =  "packer_AWS {{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.basic-example"
  ]

    provisioner "shell" {    
      inline = [
              "echo provisioning all the things",
              //"echo the value of 'foo' is '${var.foo}'",
      ]
    }
    provisioner "ansible" {
        playbook_file = "./playbook.yml"
        user = "ubuntu"
        extra_arguments = [
          "--extra-vars", "ansible_python_interpreter=/usr/bin/python3"
        ]
        ansible_env_vars = [
          "ANSIBLE_HOST_KEY_CHECKING=False"
        ]
    }
}
