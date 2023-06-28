FROM ubuntu:22.04
MAINTAINER Xavier Mertens <xmertens@isc.sans.edu>

# Update & install required packages
RUN DEBIAN_FRONTEND=noninteractive apt update && apt -y upgrade && apt -y install sudo git python3-pip wget unzip

# Install main app
WORKDIR /app
COPY . .

# Stupid fix to allow non-interactive install
RUN sed -i "s/apt install/DEBIAN_FRONTEND=noninteractive apt -y install/g" setup.sh
RUN chmod a+x qu1cksc0pe.py setup.sh

# Another simple fix to avoid breaking the setup script
RUN ln -s /root /home/root
RUN ./setup.sh

# Missing dependencies
RUN pip3 install pycryptodome

# Install Radare2
WORKDIR /opt
RUN git clone https://github.com/radareorg/radare2
RUN radare2/sys/install.sh

WORKDIR /app
ENTRYPOINT ["/app/qu1cksc0pe.py"]