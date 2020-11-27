# igel-ums
## Some Words
This repository contains a docker implementation of Igels "Universal Management Suite" to manage Thin Clients.
Ubuntu 18.04LTS with IGEL UMS 6.06.100 as a Docker container. The Docker Container is Unofficial and not supported by Igel Technology!

## Usage

To run a Contain use following docker command:
```
docker run -ti -p 2022:22 -p 30001:30001 -p 9080:9080 -p 8443:8443 --name igelums6 malli88/igel-ums
```