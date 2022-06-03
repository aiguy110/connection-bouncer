# Purpose
If you have remote SSH access to a Linux host (say through a bastion host), and for whatever reason need to
forward a local port to this host in such a way that applications on the host see your connections coming from
somewhere other than the loopback IP, this repo may be useful to you.

# Usage
First, make sure docker is installed on the remote host. Then either build the container using the command below
from the project root...

    docker build -t aiguy110/connection-bouncer .

...or use the pre-built version from Docker Hub. (If you use the Docker Hub verion, you won't need to clone this
repo to the remote machine. Simply copying `./launch_bouncer.sh` should be sufficient.)

    docker pull aiguy110/connection-bouncer

Next, use the following command to launch the container, where `SPOOFED_IP` is the IP you want your host machine
to see your connection coming from, and `DST_PORT` is the port on the host machine to which you would like to connect.

    ./launch_bouncer.sh <SPOOFED_IP> <DST_PORT>

If everything is working properly, this should print out a message like "Connection bouncer is listening at: 172.17.0.8:4242".
Connections made to this IP and port will now be bounced back to the host on port `DST_PORT`, and appear to come from `SPOOFED_IP`.

### Example
Say the remote host had a webserver running on 9443. You could used the following arguments with the script above...

    ./launch_bouncer.sh 192.168.1.100 9443

...and, noting the "Connection bouncer is listening at" location, launch a new SSH connection to the remote host using a 
command like this:

    ssh remote-host -L 9443:172.17.0.8:4242

Then, as long as this SSH connection stayed open and the container stayed running, you should be able to access the webserver 
in your browser via `https://localhost:9443/some-uri`, and the webserver would see your requests coming from 192.168.1.100.
