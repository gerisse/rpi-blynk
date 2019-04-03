# rpi-blynk

Docker image that runs the Blynk server on Raspberry Pi.
Thanks to Hypriot team.

## How To Use It
Build:
```sh
git clone https://github.com/fr8tra1n/rpi-blynk.git
cd rpi-blynk
docker build -t rpi-blynk .
```
Launch the container:

```sh
docker run rpi-blynk
```

To forward IP ports from the host to the container, do this:

```sh
docker run -d -p 7443:7443 -p 8443:8443 -p 9443:9443 rpi-blynk 
```

After few minutes, you can admin your Blynk server : connect you to 

https://IP_of_your_Raspi:9443/admin

with this :

Admin login email : admin@blynk.cc  /  Admin password : admin


Docker image : https://hub.docker.com/r/fr8tra1n/rpi-blynk/
