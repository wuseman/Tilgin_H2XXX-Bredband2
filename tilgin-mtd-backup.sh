#!/usr/bin/env bash

# - iNFO --------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: mtd-backup.sh
#  Created: 2023-12-25 (22:12:58)
# Modified: 2023-12-25 (22:14:50)
#  Version: 1.0
#  License: MIT
#
# ---------------------------------------------

# Settings
# ---------------------------------------------
tilginUser="root"
tilginPass="ahy9mee2"
tilginWebUser="root"
tilginWebPass="ahy9mee2"
tilginSource="62.220.164.156"
tilginBackupPath="/home/wuseman/tilgin/backup/mtd"
tilginMtdBlockPath="/home/wuseman/tilgin/backup/mtdblock"
tilginUBIPath="/home/wuseman/tilgin/backup/ubi"
# Source Code
# ---------------------------------------------

_ok() {
        echo -e "[\e[1;32m*\e[0m] $*"
}

_err() {
        echo -e "[\e[1;31m*\e[0m] $@" >&2
}

sw_version="$(sshpass -p $tilginPass ssh root@$tilginSource cget /system/sw_version)"
system_type"$(sshpass -p $tilginPass ssh root@$tilginSource cget /system/system_type)"

### Backup MTD

sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/0' | dd of=${tilginBackupPath}/mtd0_U-boot.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/1' | dd of=${tilginBackupPath}/mtd1_ubi.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/2' | dd of=${tilginBackupPath}/mtd2_package.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/3' | dd of=${tilginBackupPath}/mtd3_Log.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/4' | dd of=${tilginBackupPath}/mtd4_Environment.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/5' | dd of=${tilginBackupPath}/mtd5_U-Misc-A.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/6' | dd of=${tilginBackupPath}/mtd6_U-Config-C.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/7' | dd of=${tilginBackupPath}/mtd7_U-kernel.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/8' | dd of=${tilginBackupPath}/mtd8_U-rootfs.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/9' | dd of=${tilginBackupPath}/mtd9_U-appfs.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/10' | dd of=${tilginBackupPath}/mtd10_caldata.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/11' | dd of=${tilginBackupPath}/mtd11_test_data.bin
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtd/12' | dd of=${tilginBackupPath}/mtd12_Config-A.bin


### Backup MTDBLOCKS

mkdir -p $tilginMtdBlockPath
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/0' | dd of=${tilginMtdBlockPath}/U-Boot-mtdblock0.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/1' | dd of=${tilginMtdBlockPath}/ubi-mtdblock1.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/2' | dd of=${tilginMtdBlockPath}/package-mtdblock2.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/3' | dd of=${tilginMtdBlockPath}/Misc-A-mtdblock3.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/4' | dd of=${tilginMtdBlockPath}/test_data-mtdblock4.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/5' | dd of=${tilginMtdBlockPath}/Log-mtdblock5.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/6' | dd of=${tilginMtdBlockPath}/Enviroment-mtdblock6.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/7' | dd of=${tilginMtdBlockPath}/Config-C-mtdblock7.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/8' | dd of=${tilginMtdBlockPath}/kernel-mtdblock8.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/9' | dd of=${tilginMtdBlockPath}/rootfs-mtdblock9.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/10' | dd of=${tilginMtdBlockPath}/appfs-mtdblock10.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/11' | dd of=${tilginMtdBlockPath}/caldata-mtdblock11.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/mtdblock/12' | dd of=${tilginMtdBlockPath}/Config-A-mtdblock12.img


### Backup UBI

mkdir -p $tilginBackupPath
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/ubi0' | dd of=${tilginUBIBackupPath}/ubi0.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/ubi0_1' | dd of=${tilginUBIBackupPath}/ubi0_1.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/ubi0_11' | dd of=${tilginUBIBackupPath}/ubi0_11.img
sshpass -p $tilginPass ssh root@$tilginSource 'dd if=/dev/ubi0_3' | dd of=${tilginUBIBackupPath}/ubi0_3.img



