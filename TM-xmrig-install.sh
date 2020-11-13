
xmrigReleasesDownloadSite=https://github.com/xmrig/xmrig/releases/download/
xmrigVersionName=v6.5.1
xmrigZipedPackageName=xmrig-6.5.1-focal-x64.tar.gz
xmrigExtractedFolderName=xmrig-6.5.1
xmrigExecutableFileName=xmrig

sudo pkill -i xmrig

cd /home/$USER

rm -rf $xmrigZipedPackageName
wget $xmrigReleasesDownloadSite/$xmrigVersionName/$xmrigZipedPackageName
tar -xf $xmrigZipedPackageName

if [ ! -d "xmrig" ]
then
    mkdir xmrig
fi

\cp -f $xmrigExtractedFolderName/$xmrigExecutableFileName xmrig/xmrig

rm -rf $xmrigZipedPackageName
rm -rf $xmrigExtractedFolderName

clear

if [ -f xmrig/config.json ]
then
    echo -n "Delete old config file?(Y/N)"
    read input
    if [ "$input" = "Y" ]
    then
        rm -rf xmrig/config.json
    fi
fi

while ! [ -f xmrig/config.json ]
do
    if [ -f Desktop/config.json ]
    then
        cp Desktop/config.json xmrig/config.json
    else
        echo -n "Config file not found. Copy your new config.json file to Desktop and press ENTER"
        read input
    fi
done

rm -rf /home/$USER/TrueMining-XMRig.sh
echo #!/bin/bash >> /home/$USER/TrueMining-XMRig.sh
echo cd /home/$USER/xmrig >> /home/$USER/TrueMining-XMRig.sh
echo ./xmrig >> /home/$USER/TrueMining-XMRig.sh &

sudo rm -rf /etc/systemd/system/TrueMining-XMRig.service
sudo rm -rf xmrig/service
echo [Unit] >> xmrig/service
echo Description=True Mining Running XMRig >> xmrig/service
echo  >> xmrig/service
echo [Service] >> xmrig/service
echo Type=simple >> xmrig/service
echo ExecStart=bash /home/$USER/TrueMining-XMRig.sh >> xmrig/service
echo Restart=on-failure >> xmrig/service
echo User=$USER >> xmrig/service
echo RestartSec=10 >> xmrig/service
echo  >> xmrig/service
echo [Unit] >> xmrig/service
echo Wants=network-online.target >> xmrig/service
echo After=network-online.target >> xmrig/service
echo  >> xmrig/service
echo [Install] >> xmrig/service
echo WantedBy=graphical.target >> xmrig/service

sudo cp xmrig/service /etc/systemd/system/TrueMining-XMRig.service

sudo chmod -R 777 xmrig
sudo chmod 777 TrueMining-XMRig.sh
sudo chmod 777 xmrig/service
sudo chmod 777 /etc/systemd/system/TrueMining-XMRig.service

sudo systemctl daemon-reload
sudo systemctl enable TrueMining-XMRig
sudo systemctl start TrueMining-XMRig