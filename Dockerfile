FROM ubuntu:latest

# Install required packages
RUN apt update && apt install \
    -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg \
        jq \
        make \
        nano \
        net-tools \
        nodejs \
        npm \
        openssh-server \
        software-properties-common \
        sudo \
        unzip \
        wget

# Install Python 3
RUN apt update && apt install \
    -y --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        virtualenv \
        python3-setuptools

# Install terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# Install Packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Install GOOGLE CLOUD CLI
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN apt update && apt-get install -y \
    ansible \
    google-cloud-cli \
    packer \
    terraform

# Configure git alias
RUN git config --global alias.br branch \
    && git config --global alias.co checkout \
    && git config --global alias.cm commit \
    && git config --global alias.cne "commit -a --amend --no-edit" \
    && git config --global alias.cp "cherry-pick" \
    && git config --global alias.fe "fetch origin" \
    && git config --global alias.p "pull --prune" \
    && git config --global alias.pf "push -f" \
    && git config --global alias.re "rebase -i" \
    && git config --global alias.st status


# Create a user “dev” and group “devops”
RUN groupadd devops && useradd -ms /bin/bash -g devops developer
RUN echo "%devops ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/devops

# change root password and setup user password
RUN echo "developer:1" | chpasswd && echo "root:devtools" | chpasswd

# Create dev directory in home
# RUN mkdir -p /home/dev/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
# COPY idkey.pub /home/dev/.ssh/authorized_keys

# change ownership of the key file. 
# RUN chown dev:devops /home/dev/.ssh/authorized_keys && chmod 600 /home/dev/.ssh/authorized_keys

# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]