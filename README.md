# igel-ums
## Some Words
This repository contains a docker implementation of Igels "Universal Management Suite" to manage Thin Clients.
Ubuntu 18.04LTS with IGEL UMS 6.06.100 as a Docker container. The Docker Container is Unofficial and not supported by Igel Technology!

## Usage

### RUN
To run a Contain use following docker command:
```
docker run -ti -p 2022:22 -p 30001:30001 -p 9080:9080 -p 8443:8443 --name igelums6 malli88/igel-ums:latest
```

### Interact with shell
To connect to the shell of the container use following command
```bash
ssh -X -p2022 igel@localhost
```

### Run the UMS Console
To Manage Igel Clients you need to start the Igel UMS Console 
```
ssh -X -p2022 igel@localhost /opt/IGEL/RemoteManager/RemoteManager.sh
```

### Run the UMS Admin Console
If you like to change the Database or just to change Igel UMS login password use the Admin Console
```
ssh -X -p2022 igel@localhost /opt/IGEL/RemoteManager/RMAdmin.sh
```


