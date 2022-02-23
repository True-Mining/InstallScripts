xmrigReleasesDownloadSite=https://github.com/xmrig/xmrig/releases/download/
xmrigVersionName=v6.16.2
xmrigZipedPackageName=xmrig-6.16.2-linux-static-x64.tar.gz
xmrigExtractedFolderName=xmrig-6.16.2
xmrigExecutableFileName=xmrig

bashStartFile=~/TrueMining-XMRig.sh
instaledXmrigFolder=~/truemining-xmrig

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

sudo pkill -i xmrig

cd ~/

rm -rf "$xmrigZipedPackageName"
rm -rf "$xmrigExtractedFolderName"

clear

while ! [ -f $xmrigZipedPackageName ]
do
    rm -rf $xmrigZipedPackageName
    wget -T 15 -c "$xmrigReleasesDownloadSite/$xmrigVersionName/$xmrigZipedPackageName" -O $xmrigZipedPackageName && break
done

tar -xf "$xmrigZipedPackageName"

if [ ! -d "$instaledXmrigFolder" ]
then
    mkdir $instaledXmrigFolder
fi

cp -f "$xmrigExtractedFolderName/$xmrigExecutableFileName" $instaledXmrigFolder/xmrig

rm -rf "$xmrigZipedPackageName"
rm -rf "$xmrigExtractedFolderName"

clear

if [ -f $instaledXmrigFolder/config.json ]
then
    echo -n "Delete old config file? (Y/N): "
    read input
    if [ "$input" = "Y" ]
    then
        rm -rf $instaledXmrigFolder/config.json
    fi
fi

if [ ! -f $instaledXmrigFolder/config.json ]
then
    while ! [ -f $instaledXmrigFolder/config.json ]
    do
        rm -rf $instaledXmrigFolder/config.json
        wget -T 15 -c https://truemining.online/docs/example-xmrig-config.json -O $instaledXmrigFolder/config.json && break
    done
    clear
    while grep -q "coinTicker" "$instaledXmrigFolder/config.json"
    do
        echo "Select coin to receive payment:"
        echo "(1) Dogecoin - DOGE"
        echo "(2) Digibyte - DGB"
        echo "(3) Ravencoin - RVN"
        echo ""
        echo -n "Type a number: "
        read input
        if [ "$input" = "1" ]
        then
            sed -i 's/coinTicker/doge/g' $instaledXmrigFolder/config.json
        elif [ "$input" = "2" ]
        then
            sed -i 's/coinTicker/dgb/g' $instaledXmrigFolder/config.json
        elif [ "$input" = "3" ]
        then
            sed -i 's/coinTicker/rvn/g' $instaledXmrigFolder/config.json
        else
            clear
            echo "Invalid number, try again"
        fi
    done
    clear
    while grep -q "paymentAddress" $instaledXmrigFolder/config.json
    do
        echo "Type your payment address."
        echo -e "${YELLOW}ATENTION, INVALID/WRONG ADDRESSES CAN'T RECEIVE PAYMENTS.${NC}"
        echo 
        echo -n "Payment address: "
        read input
        sed -i "s/paymentAddress/$input/g" $instaledXmrigFolder/config.json
    done
fi

rm -rf $bashStartFile
echo #!/bin/bash >> $bashStartFile
echo pkill -i xmrig >> $bashStartFile
echo cd $instaledXmrigFolder >> $bashStartFile
echo ./xmrig >> $bashStartFile &

test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs

if [ ! -z "{$XDG_DESKTOP_DIR}" ]
then
    desktopFolderName=$"$XDG_DESKTOP_DIR"
elif [ ! -d "~/Desktop" ]
then
    desktopFolderName="~/Desktop"
elif [ ! -d "~/Área de Trabalho" ]
then
    desktopFolderName="~/Área de Trabalho"
else
    desktopFolderName="~/Desktop"
fi

rm -rf "$desktopFolderName"/TrueMining-xmrig.desktop

echo > "$desktopFolderName"/TrueMining-xmrig.desktop

echo '#!/usr/bin/env xdg-open' >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo [Desktop Entry] >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo Version=1.0 >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo Type=Application >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo Terminal=true >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo Exec=sudo bash "$bashStartFile" >> "$desktopFolderName"/TrueMining-xmrig.desktop
echo Name=XMRig with True Mining >> "$desktopFolderName"/TrueMining-xmrig.desktop

clear

echo "Start hidden mining at system startup? (Y/N): "
read input
if [ "$input" = "Y" ]
then
    RodarQuandoLigar="yes"
    sudo rm -rf /etc/systemd/system/TrueMining-XMRig.service
    sudo rm -rf $instaledXmrigFolder/service
    echo [Unit] >> $instaledXmrigFolder/service
    echo Description=True Mining Running XMRig >> $instaledXmrigFolder/service
    echo  >> $instaledXmrigFolder/service
    echo [Service] >> $instaledXmrigFolder/service
    echo Type=idle >> $instaledXmrigFolder/service
    echo ExecStart=bash "$bashStartFile" >> $instaledXmrigFolder/service
    echo Terminal=true >> $instaledXmrigFolder/service
    echo Restart=on-failure >> $instaledXmrigFolder/service
    echo User="$USER" >> $instaledXmrigFolder/service
    echo RestartSec=10 >> $instaledXmrigFolder/service
    echo  >> $instaledXmrigFolder/service
    echo [Unit] >> $instaledXmrigFolder/service
    echo Wants=network-online.target >> $instaledXmrigFolder/service
    echo After=network-online.target >> $instaledXmrigFolder/service
    echo  >> $instaledXmrigFolder/service
    echo [Install] >> $instaledXmrigFolder/service
    echo WantedBy=multi-user.target >> $instaledXmrigFolder/service
    sudo cp $instaledXmrigFolder/service /etc/systemd/system/TrueMining-XMRig.service
    sudo chmod -R 755 $instaledXmrigFolder
    sudo chmod 755 $bashStartFile
    sudo chmod 755 $instaledXmrigFolder/service
    sudo chmod 755 /etc/systemd/system/TrueMining-XMRig.service
    sudo systemctl daemon-reload
    sudo systemctl enable TrueMining-XMRig
else
    RodarQuandoLigar="no"
    sudo systemctl disable TrueMining-XMRig
fi

clear

echo -e "${YELLOW}Instaltion done!!!${NC}"
echo
echo "Start True Mining - XMRig with the command bellow:"
echo -e "${GREEN}bash $bashStartFile${NC}"
echo
echo "or with sudo (better hashrate):"
echo -e "${GREEN}sudo bash $bashStartFile${NC}"
if [ $RodarQuandoLigar="yes" ]
then
    echo
    echo -e "${YELLOW}True Mining will start mining hiden as soon as the computer starts${NC}"
    echo "Disable True Mining at startup with:"
    echo -e "${GREEN}sudo systemctl disable TrueMining-XMRig${NC}"
fi
