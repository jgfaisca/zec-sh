#!/bin/bash

# Download the AMD APP SDK (as of 27 Oct 2016, the latest version is 3.0) from
# http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/
# and extract it to /opt directory:

# variables
AMD_APP_SDK="AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2"
AMD_APP_SDK_SH="AMD-APP-SDK-v3.0.130.136-GA-linux64.sh"
AMD_APP_SDK_VERSION="3.0"
AMD_GPU_PRO="amdgpu-pro-16.40-348864.tar.xz"
URL="https://www2.ati.com/drivers/linux/ubuntu"

# install AMD APP SDK
function installAMD-APP-SDK(){
  	# remove opensource opencl-dev
  	#OPENCL="ocl-icd-opencl-dev xserver-xorg-video-ati"
  	#sudo apt-get -y purge $OPENCL
  if 	[ ! -d "/opt/AMDAPPSDK-$AMD_APP_SDK_VERSION" ]; then
  		cd /opt
		tar -xvf $AMD_APP_SDK
		sudo ./$AMD_APP_SDK_SH
  		ln -s /opt/AMDAPPSDK-$AMD_APP_SDK_VERSION /opt/AMDAPP
  		ln -s /opt/AMDAPP/include/CL /usr/include
  		ln -s /opt/AMDAPP/lib/x86_64/* /usr/lib/
  		ldconfig
  else
  		echo "/opt/AMDAPPSDK-$AMD_APP_SDK_VERSION not found"
		echo "Download the AMD APP SDK and extract it to /opt directory"
		exit 1
  fi
}

# install AMD GPU PRO driver
function installAMD-GPU-PRO(){
  if 	[ ! -d "/tmp/$AMD_GPU_PRO" ]; then
      		cd /tmp 
  		[ -f ./$AMD_GPU_PRO ] || curl -O -k "$URL/$AMD_GPU_PRO"
      		tar -xvf $AMD_GPU_PRO
		amdgpu-pro-driver/amdgpu-pro-install
		rm tmp/$AMD_GPU_PRO
  fi
}


# install dependencies
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

cd $HOME

# install silentarmy
git clone https://github.com/mbevand/silentarmy.git
cd silentarmy
make

# add user to the video group 
sudo usermod -a -G video $LOGNAME

echo "Restart your machine to launch using the new graphics stack.
shutdown -r -v +1
