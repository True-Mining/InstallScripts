# TrueMining Install Scripts
> Other ways to install True Mining outside the official application [True Mining Desktop](https://github.com/True-Mining/TrueMiningDesktop)

## Linux x64 (amd64/64bits)

### Install 

On terminal/console put command, type ENTER and follow instructions:
```
sudo rm -rf TrueMining_XMRig-Linux_Install.sh && wget https://raw.githubusercontent.com/True-Mining/TrueMining_XMRig-Linux_Install/main/TrueMining_XMRig-Linux_Install.sh && sudo chmod 777 TrueMining_XMRig-Linux_Install.sh && ./TrueMining_XMRig-Linux_Install.sh
```

### Disable autorun at system startup
```
sudo systemctl disable TrueMining-XMRig
```

### Start True Mining - XMRig as current user
```
bash ~/TrueMining-XMRig.sh
```

### Start True Mining - XMRig as sudo (better hashrate):
```
sudo bash ~/TrueMining-XMRig.sh
```
