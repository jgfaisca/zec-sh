#!/bin/bash

# variables
AMD_APP_SDK_SH="AMD-APP-SDK-v3.0.130.136-GA-linux64.sh" # URN
AMD_APP_SDK_VERSION="3.0"
URL1="" # URL to AMD-APP-SDK installation script 
AMD_GPU_PRO="amdgpu-pro-16.40-348864.tar.xz"
URL2="https://www2.ati.com/drivers/linux/ubuntu"

# install AMD APP SDK
function installAMD-APP-SDK(){
  	# remove opensource opencl-dev
  	#OPENCL="ocl-icd-opencl-dev xserver-xorg-video-ati"
  	#sudo apt-get -y purge $OPENCL
  if 	[ ! -d "/opt/AMDAPPSDK-$AMD_APP_SDK_VERSION" ]; then
  		[ -f ./URL1.txt ] && URL=$(cat ./URL1.txt)
  		[ -f ./$AMD_APP_SDK_SH ] || curl -O -k "$URL1/$AMD_APP_SDK_SH"
		  sudo ./$AMD_APP_SDK_SH
  		ln -s /opt/AMDAPPSDK-$AMD_APP_SDK_VERSION /opt/AMDAPP
  		ln -s /opt/AMDAPP/include/CL /usr/include
  		ln -s /opt/AMDAPP/lib/x86_64/* /usr/lib/
  		ldconfig
  fi
}

# install AMD GPU PRO driver
function installAMD-GPU-PRO(){
  if 	[ ! -d "/tmp/$AMD_GPU_PRO" ]; then
      		cd /tmp 
  		[ -f ./$AMD_GPU_PRO ] || curl -O -k "$URL2/$AMD_GPU_PRO"
      		tar -Jxvf $AMD_GPU_PRO
		amdgpu-pro-driver/amdgpu-pro-install
  fi
}

cd $HOME

# dependencies
sudo apt-get install git ocl-icd-opencl-dev libsodium-dev 

# install AMD APP SDK
installAMD-APP-SDK

# install AMDGPU-PRO Driver 
installAMD-GPU-PRO

# if for any reason you wish to remove the AMDGPU-PRO graphics stack 
# amdgpu-pro-uninstall

#The following command will provide the version of the AMDGPU-Pro 
# stack or inform that there are no packages found
dpkg -l amdgpu-pro

# install silentarmy
git clone https://github.com/mbevand/silentarmy.git
cd silentarmy
make

# add user to the video group 
sudo usermod -a -G video $LOGNAME

echo "You will need to log out and in again.
echo "You will need to restart your machine to launch using the new graphics stack.
shutdown -r -v +1
