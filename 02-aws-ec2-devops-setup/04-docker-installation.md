# Docker Installation on Ubuntu EC2

## Introduction
To install Docker on an Ubuntu EC2 instance.

----------------------

**Step 1: Add Docker’s Official GPG Key**

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

**Step 2: Add Docker Repository to APT Sources**

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

**Step 3: Install Docker**

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Step 4: Verify Docker Installation**

```bash
sudo docker run hello-world
```

If you run docker run hello-world without sudo, you may get the following error **unable to get image 'ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.133.0': permission denied while trying to connect to the Docker API at unix:///var/run/docker.sock** 

To avoid using sudo every time, add the ubuntu user to the docker group:

```bash
sudo usermod -aG docker ubuntu
```

Then restart Docker service or log out and log back in for the changes to take effect.
