os ?= $(shell lsb_release -cs)
port-portainer ?= 9000:9000

# Target to install Docker
install-docker:;: '$(os)'
	@echo "Updating package index..."
	@sudo apt-get update
	@echo "Installing prerequisites..."
	@sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release
	@echo "Adding Docker’s official GPG key..."
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	@echo "Adding Docker repository..."
	@echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(os) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	@echo "Updating package index again..."
	@sudo apt-get update
	@echo "Installing Docker..."
	@sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	@echo "Verifying Docker installation..."
	@sudo docker run hello-world
	@echo "============Docker has been Installed==============="

# Target to install Portainer
install-portainer:;: '$(port-portainer)'
	@echo "Creating Portainer volume..."
	@sudo docker volume create vol-portainer
	@echo "Running Portainer container..."
	@sudo docker run -d --name Portainer --restart=always -p $(port-portainer) -v /var/run/docker.sock:/var/run/docker.sock -v vol-portainer:/data portainer/portainer-ce
	@echo "============Portainer has been Installed=============="
