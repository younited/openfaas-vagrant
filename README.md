# openfaas-vagrant

OpenFaaS in your local environment.

## Prerequisites

- [Virtualbox](https://www.virtualbox.org) - A a free and open-source hosted hypervisor for x86 virtualization.
- [Vagrant](https://github.com/hashicorp/vagrant) - A tool for building and distributing development environments.
- [faas-cli](https://github.com/openfaas/faas-cli) - Official CLI for OpenFaaS.

## Overview

The Vagrantfile will create a virtual machine running Ubuntu 18.04 LTS (Bionic Beaver) in Virtualbox. It will install OpenFaaS using the [faasd](https://github.com/openfaas/faasd) provider for a single node.

## Usage

Run the following command to deploy openfaas:
```sh
$ vagrant up
```

You will be prompted with a message asking to select a Docker container registry (optional):
```sh
Choose a Container Registry Server:
1) Docker (docker.io)
2) GitHub (ghcr.io)
3) Quay   (quay.io)
4) Other registry # <- provide your own url
5) Skip # <- skip if you want to keep your docker images locally
0) Quit # <- exit the script, you will have to destroy the VM afterwards
Enter selection [0-5]: 
```

If you haven't selected `Skip` or `Quit`, you will be asked for your credentials:
```
Virtual machine needs your credentials for the container registry ghcr.io
Username: dysonfrost
Password:
```

When the VM is ready, vagrant will display some information:
```
### Vagrant Box provisioned! ###
------------------------------------------------------
Local OpenFaas is ready

URLS:
 * OpenFaaS - http://192.168.50.2:8080

OpenFaaS credentials:
 * username: admin
 * password: <generated_password>

Login with faas-cli:
 $ export OPENFAAS_URL=http://192.168.50.2:8080 # From Host
 $ faas-cli login -u admin --password <generated_password>

------------------------------------------------------
```

If somehow you need to retrieve your generated password:
```sh
$ vagrant ssh
vagrant@openfaas:~$ sudo cat /var/lib/faasd/secrets/basic-auth-password
```

## CLI

OpenFaas can be accessed from both the host and the guest VM, once logged in (see information above) you can build a new function.

### List templates from store
```sh
$ faas-cli template store ls
```

### Pull templates from store
```sh
# faas-cli template store pull <template>
$ faas-cli template store pull dockerfile
```
### Download templates from specified git repo

```sh
$ faas-cli template pull <repository_url>
```

### Create a new function
```sh
# faas-cli new <function> --lang=<template>
$ faas-cli new hello-world --lang=dockerfile
```

### Checkout the YAML file
```yml
version: 1.0
provider:
  name: openfaas
  gateway: http://192.168.50.2:8080
functions:
  hello-world:
    lang: dockerfile
    handler: ./hello-world
    image: hello-world:latest
```

- `gateway` - URL of the gateway (set to localhost if running from VM guest)
- `lang` - Template associated with the function
- `handler` - The folder / path to your handler / Dockerfile and any other source code you need
- `image` - The Docker image name. If you are going to push to a container registry change the prefix of your image - i.e. ghcr.io/dysonfrost/hello-world:latest

### Build a function
```sh
# faas-cli build -f <function>.yml
$ faas-cli build -f hello-world.yml
```
_Skip the following steps if you do not intend to use a remote registery to invoke a function._
### Push a function
```sh
# faas-cli push -f <function>.yml
$ faas-cli push -f hello-world.yml
```

### Deploy a function
```sh
# faas-cli deploy -f <function>.yml
$ faas-cli deploy -f hello-world.yml
```

### Build, push and deploy a function
```sh
# faas-cli up -f <function>.yml
$ faas-cli up -f hello-world.yml
```

### Invoke a function
```sh
# faas-cli invoke <function>
$ faas-cli invoke hello-world

# Using cURL
curl http://192.168.50.2:8080/function/hello-world
```

### Invoke a function with some data
```sh
# echo "<some-data>" | faas-cli invoke <function>
$ echo "Hi there!" | faas-cli invoke hello-world

# Using cURL
curl http://192.168.50.2:8080/function/hello-world -d "Hi there!"
```

## UI

A user interface is available at `http://192.168.50.2:8080/ui/`  
You can Deploy and Invoke new functions from there.

## Uninstall

To delete the virtual machine, run the following command:
```sh
$ vagrant destroy -f
```

## References
- https://github.com/openfaas/faas
- https://github.com/openfaas/faasd
- https://docs.openfaas.com
- https://blog.alexellis.io/tag/openfaas
