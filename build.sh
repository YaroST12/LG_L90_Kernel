#!/bin/bash
kernel_dir=$PWD
export CONFIG_FILE="w7ds_lineageos_defconfig"
export LOCALVERSION="-D405"
export KBUILD_BUILD_USER="ST12"
export KBUILD_BUILD_HOST="BLR"
export ARCH_arm="arm"
NC='\033[0m'
RED='\033[0;31m'
LGR='\033[1;32m'

export GCC_PREFIX="arm-linux-gnueabi-"
export TC_PATH="${HOME}/build/gcc7.2-32/bin"
export objdir="${kernel_dir}/out"
export builddir="${kernel_dir}/build"
cd $kernel_dir
make_a_fucking_defconfig() 
{
	# I FUCKING HATE YOU ALL
	echo -e ${LGR} "############# Generating Defconfig ##############${NC}"
	make ARCH=${ARCH_arm} O=$objdir $CONFIG_FILE -j8
}
compile() 
{
	echo -e ${LGR} "############### Compiling kernel ################${NC}"
	make ARCH=${ARCH_arm} CROSS_COMPILE=${TC_PATH}/${GCC_PREFIX} O=$objdir -j8 \
	zImage
}
ramdisk() 
{
	cd ${objdir}
	COMPILED_IMAGE=arch/arm/boot/zImage
	if [[ -f ${COMPILED_IMAGE} ]]; then
		mv -f ${COMPILED_IMAGE} $builddir/zImage
		echo -e ${LGR} "#################################################"
		echo -e ${LGR} "############### Build competed! #################"
		echo -e ${LGR} "#################################################${NC}"
	else
		echo -e ${RED} "#################################################"
		echo -e ${RED} "# Build fuckedup, check warnings/errors faggot! #"
		echo -e ${RED} "#################################################${NC}"
	fi
}
make_a_fucking_defconfig
compile 
ramdisk
cd ${kernel_dir}