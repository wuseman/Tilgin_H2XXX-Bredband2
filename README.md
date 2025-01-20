# Tilgin_H2751-Bredband2

![20221228_005029](https://user-images.githubusercontent.com/26827453/210712060-f1172743-d3be-41d1-94b2-ab5a64a16d27.jpg)


When resetting the router to a factory reset the kernel suffers a kernel panic which means that "Config-A" is never recreated from the current installation 
so the device will reset to "Factory" settings where you can log in as `admin:admin` if you will boot the device without any WAN cable connected for the 
first boot after reset, however this is not the same as `root` and in this README I will let you login as root on ANY Tilgin H27XX router, but this 
readme will also provide the specific admin password for Alltele/Bredband2's administrator who apparently forgot to delete the original root password that 
the router has before it is sent to the supplier.

![tilgin_root](https://user-images.githubusercontent.com/26827453/210668138-14a36a10-d9ac-4be6-9ccd-14f6b27c7cf5.gif)

## Serial Console

```
Login: N/A
Password: N/A
Baudrate: 115200
```

## Login: User 1 (Default password for all Tilgin devices, be nice)

```
Username: root
Password: ahy9mee2
Password_def: v6+i1-Q5-E5_e1$F0
Password_rev: 04_01_00_36
```

1) Browse to: http://192.168.1.1/tools/ssh
2) Login with: root: ah9mee2
3) Now ssh to your router: `ssh -oHostKeyAlgorithms=+ssh-dss root@192.168.1.1`

## Secure your router

* Copy and paste

```bash
userName="changeme"
userPassword="changeme"

for users in 1 2 3; do 
  cset ${userName} /webui/user/${users}/name 
  cset ${userPassword} /webui/user/${users}/password
done
```

Now login with your new user/password as you chose in the example above.


Enjoy!

## Login: User 2 (alltele/bredband2 default password for admin)

Before you connect your device to internet, default login is: admin:admin and depening what you have set to /etc/trol.conf you will get the ISP password for the config you have set, as default: `trol.conf.bb2` on this device from Bredband2

```
Username: admin
Password: a3_Banankontakt!
Password_def: b7,T7-I7/i3/E3+i0
Password_rev: 04_01_00_36
```

## Login: User 3 (you probably know this already)

```
Username: user
Password: user
Password_def: T8,b1=l9,G0
Password_rev: 04_01_00_36
```

### /proc/version

```
Linux version 4.9.218 (helen@builserver01) (gcc version 6.3.0 (GCC) ) #3 SMP Sat Oct 16 15:53:20 BST 2021
```

### /proc/mtd

```
dev:    size   erasesize  name
mtd0: 00100000 00020000 "U-Boot"
mtd1: 07f00000 00020000 "ubi"
mtd2: 01e08000 0001f000 "package"
mtd3: 00008000 0001f000 "Log"
mtd4: 00001f00 0001f000 "Environment"
mtd6: 00002000 0001f000 "Misc-A"
mtd7: 00002000 0001f000 "Config-C"
mtd8: 00307000 0001f000 "kernel"
mtd9: 0273c000 0001f000 "rootfs"
mtd10: 0001f000 0001f000 "appfs"
mtd11: 0001f000 0001f000 "caldata"
mtd12: 000000aa 0001f000 "test_data"
mtd13: 0000d000 0001f000 "Config-A"
```

### Dump all settings

```
cdump / 
```

### Change root password via shell

```
echo 'root:password' \
  |chpasswd
```

### Iptables

iptables and dropbear commands and other super user commands wont work by default since they are not added to `PATH`, fix this by copy and paste below.

```
echo 'export PATH=${PATH}:/usr/sbin' >> /etc/profile
. /etc/profile
```

### Create your own dropbear keys and wipe your providers one


```bash
#! /bin/sh
#
# Remove backdoor keys and create our own for dropbear
#
# Copyright (C) 2023 wuseman
# Author: wuseman <wuseman@nr1.nu>
#
# $Id: create-dropbearkeys.sh 2023-01-05 01:24:00+0100 wuseman $
#

function dropbearServer() {
rm /var/miscA/dropbear_rsa_host_key
rm /var/miscA/dropbear_dss_host_key
mkdir -p /etc/dropbear
mknod -m 644 /dev/random c 1 8
mknod -m 644 /dev/urandom c 1 9

/usr/bin/dropbearkey -t rsa -s 2048 -f /etc/dropbear/dropbear_rsa_host_key
/usr/bin/dropbearkey -t dss -s 1024 -f /etc/dropbear/dropbear_rsa_host_key
/usr/bin/dropbearkey -t ecdsa -s 521 -f /etc/dropbear/dropbear_ecdsa_host_key

ln -s /etc/dropbear/dropbear_rsa_host_key /var/miscA/dropbear_rsa_host_key
ln -s  /etc/dropbear/dropbear_rsa_host_key /var/misc/dropbear_dss_host_key
ln -s  /etc/dropbear/dropbear_ecdsa_host_key /var/miscA/dropbear_ecdsa_host_kAey

/usr/sbin/dropbear \
  -F \
  -r /var/miscA/dropbear_rsa_host_key \
  -d /var/miscA/dropbear_dss_host_key -p 22
}

[[ -d "/etc/dropbear" ]] && dropbearServer

# Launch dropbear server Cancel
Footer


 /usr/sbin/dropbear \
  -F \
   -r /etc/dropbear/dropbear_rsa_host_key \
   -d /var/miscA/dropbear_dss_host_key \
   -p 22
```

# cget

* Root is path: `/` 

### Remote host to connect to (your ISP can run commands remotely to your device)

```bash
cget -c ipaddress:port /
```

### Transaction access

```bash
cget -a      
```

### Transaction principal

```bash
cget -u      
```

### Transaction timeout

```bash
cget -t      
```

### Use property `<prop>` view

```bash
cget -v   

```
  
### Print value as default

```bash
cget /km
("insmod", "rmmod", "module")
```
  
### Print value without type-specific symbols

```bash
cget -r /km
insmod rmmod module
```
  
### Print value type

```bash
cget -l      
```
  
  
# cset

### Set settings over remote

```bash
cset -c ipaddress:port /some/setting <value> 
```

### Transaction access

```bash
cset -a      
```
### Transaction principal

```bash
cset -u      
```

### Transaction timeout

```bash
cset -t <seconds>      
```

### Use property <prop> view

```bash
cset -v       
```

# Create backup for all mtd devices over ssh

* First enable ssh as described earlier in this readme

```bash
ssh root@192.168.1.1 'dd if=/dev/mtd/0' | dd of=mtd0_U-boot.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/1' | dd of=mtd1_ubi.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/2' | dd of=mtd2_package.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/3' | dd of=mtd3_Log.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/4' | dd of=mtd4_Environment.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/5' | dd of=mtd5_U-Misc-A.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/6' | dd of=mtd6_U-Config-C.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/7' | dd of=mtd7_U-kernel.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/8' | dd of=mtd8_U-rootfs.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/9' | dd of=mtd9_U-appfs.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/10' | dd of=mtd10_caldata.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/11' | dd of=mtd11_test_data.bin
ssh root@192.168.1.1 'dd if=/dev/mtd/12' | dd of=mtd12_Config-A.bin
```

# Advanced users only

Don't touch these settings if you are not 100% sure what all commands does, I bricked my own router with 1 wrong command so you have been warned!

# Serial Boot

```
ROM VER: 2.1.0
CFG 0a
B
.
.


Tilgin UBI HG26xx/27xx_800 U-Boot 2016.07 (Oct 16 2021 - 18:08:38) 04_01_00_36

interAptiv
cps cpu/ddr run in 800/666 Mhz
Total RAM: 256 MiB
DRAM:  224 MiB
NAND:  Creating 1 MTD partitions on "nand0":
0x000000000000-0x000000100000 : "U-Boot"
Creating 1 MTD partitions on "nand0":
0x000000100000-0x000008000000 : "ubi"
ubi0: attaching mtd2
ubi0: scanning is finished
ubi0: attached mtd2 (name "ubi", size 127 MiB)
ubi0: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
ubi0: min./max. I/O unit sizes: 2048/2048, sub-page size 2048
ubi0: VID header offset: 2048 (aligned 2048), data offset: 4096
ubi0: good PEBs: 1016, bad PEBs: 0, corrupted PEBs: 0
ubi0: user volume: 11, internal volumes: 1, max. volumes count: 128A
ubi0: max/mean erase counter: 14/5, WL threshold: 256, image sequence number: 291043803
ubi0: available PEBs: 387, total reserved PEBs: 629, PEBs reserved for bad PEB handling: 20
In:    serial
Out:   serial
Err:   serial
Reset cause: POR RESET
Net:   multi type
Internal phy firmware version: 0x8548
GRX500-Switch

Type run flash_nfs to mount root filesystem over NFS

Hit any key to stop autoboot:  0 
GRX500 #
```

```
GRX500 # printenv
ID_FLASHSZ=0x08000000
ID_MAC_0=64:20:9F:23:82:B0
ID_MAC_1=64:20:9F:23:82:B1
ID_MAC_2=64:20:9F:23:82:B2
ID_MAC_3=64:20:9F:23:82:B3
ID_MAC_4=64:20:9F:23:82:B4
ID_MAC_5=64:20:9F:23:82:B5
ID_MAC_6=64:20:9F:23:82:B6
ID_MAC_7=64:20:9F:23:82:B7
ID_MEMSZ=0x10000000
ID_PCBA_Rev=P01B
ID_PW1=GGV9rKSjbxzqci9EToY739XXXXXXXXXXX
ID_PW2=NyxjKCP6ACh4TAUAzkhVv9XXXXXXXXXXX
ID_PW3=fRpRnfuTzUcnCFyrCGuMTe9XXXXXXXXXXX
ID_ProductClass=Home Gateway
ID_ProductFamily=HG2XXX
ID_ProductID=HG2XXX
ID_SSID=Tilgin-VYQLe6mXXXX
ID_SerialNumber=V84100000000-XXXXXXX
ID_USB_MAN=Tilgin
ID_USB_PID=0x4000
ID_USB_PROD=Tilgin USB RNDIS Device Driver
ID_USB_VID=0x6933
PBOOT_TIMEOUT=6
_preserve_uboot_data=echo
add_vood_ng=setenv bootargs ${bootargs} ${slram} ${mem_used} UBOOT_VERSION="U-Boot 2016.07" UBOOT_DATETIME="Oct 16 2021 - 18:08:51" RESET_CAUSE=${reset_cause} boot_cond=${boot_cond} silent=${silent}
addip=setenv bootargs ${bootargs} ip=${ipaddr}:${serverip}:${gatewayip}:${netmask}:${hostname}:${netdev}:on
addmisc=setenv bootargs ${bootargs} console=${default_console},${baudrate} ethaddr=${ethaddr} ID_SerialNumber=${ID_SerialNumber} ID_ProductID=${ID_ProductID} ID_MAC_0=${ID_MAC_0} ID_MAC_1=${ID_MAC_1} ID_MAC_2=${ID_MAC_2} ID_MAC_3=${ID_MAC_3} ID_MAC_4=${ID_MAC_4} ID_MAC_5=${ID_MAC_5} ID_MAC_6=${ID_MAC_6} ID_MAC_7=${ID_MAC_7} panic=1 loglevel=${loglevel}
addmtdram_appfs=tftpboot ${loadaddr} ${appfs};addmtdram appfs-ram ${loadaddr} ${filesize}
addmtdram_rootfs=tftpboot ${loadaddr} ${rootfs};addmtdram rootfs-ram ${loadaddr} ${filesize}
appfs=appfs.img
appfs_vol=new.appfs
baudrate=115200
boot=run flash_flash
bootcmd=run flash_flash
bootdelay=1
bootfile=uImage
cpuclk=800000000
data_block0=uboot
data_block1=ubi
default_console=ttyS0
do_update_appfs=tftpboot ${loadaddr} ${appfs} && upgrade ${loadaddr} ${filesize}
do_update_kernel=tftpboot ${loadaddr} ${bootfile} && upgrade ${loadaddr} ${filesize}
do_update_rootfs=tftpboot ${loadaddr} ${rootfs} && upgrade ${loadaddr} ${filesize}
ethact=GRX500-Switch
ethaddr=00:E0:92:00:01:40
f_ddrconfig_addr=0x00003fe8
f_ddrconfig_size=24
f_ubi_addr=0xb0100000
f_ubi_name=ubi
f_ubi_size=0xff00000
f_uboot_addr=0xb0000000
f_uboot_name=U-Boot
f_uboot_size=0x100000
flash_end=0xc0000000
flash_flash=ubi_sw_update;run flashargs addip addmisc add_vood_ng;ubi read ${kernel_addr} kernel;bootm ${kernel_addr}
flashargs=setenv bootargs ${mtdparts} ubi.mtd=${ubi_device} root=${root_mtdblock}
gatewayip=192.162.1.1
ipaddr=192.168.1.1
kernel_addr=0x80800000
kernel_vol=new.kernel
loadaddr=0x80500000
loglevel=7
mtdparts=mtdparts=ifx_nand:0x100000@0x0(U-Boot),-@0x100000(ubi)
nab=run addmtdram_appfs net_kernel
nand_spl=nand read 0xbe220200 0 0xA000;go 0xa0001000
nb=run addmtdram_appfs addmtdram_rootfs net_kernel
net_kernel=run flashargs addip addmisc add_vood_ng;tftpboot ${kernel_addr} linux.kernel;bootm ${kernel_addr}
netdev=eth0
netmask=255.255.255.0
nrb=run addmtdram_rootfs net_kernel
part0_begin=0xb0000000
part1_begin=0xb0100000
preboot=echo;echo Type "run flash_nfs" to mount root filesystem over NFS;echo
prepare_update=ubi_sw_update;ubi remove old.kernel;ubi remove old.rootfs;ubi remove old.appfs
reset_config=ubi remove Config-A && ubi create Config-A 4 s
reset_ddr_config=mw.b ${loadaddr} 0xff ${f_ddrconfig_size};nand write.partial ${loadaddr} ${f_ddrconfig_addr} ${f_ddrconfig_size}
root_mtdblock=mtd:rootfs
rootfs=rootfs.img
rootfs_vol=new.rootfs
rst_cause=POR_RESET
run2core=echo TODO;run flash_flash
serverip=192.168.1.3
silent=0
stderr=serial
stdin=serial
stdout=serial
total_db=2
total_part=2
try_uboot=tftpboot ${uboot_ram_addr} uboot-ram.bin && go ${uboot_ram_addr}
uab=run update_appfs && run flash_flash
ub=run update && run flash_flash
ubi_device=ubi
uboot_ram_addr=0x80200000
uboot_total_size=0x100000
ukb=run update_kernel && run flash_flash
update=run prepare_update && run do_update_kernel && run do_update_rootfs && run do_update_appfs
update_all=run update && run update_factory_config && reset
update_appfs=run prepare_update do_update_appfs
update_factory_config=tftpboot ${loadaddr} config.img && ubi remove Config-C && ubi create Config-C ${filesize} s && ubi write ${loadaddr} Config-C ${filesize} && run reset_config
update_factory_config_cust=tftpboot ${loadaddr} config-cust.img && ubi remove Config-D && ubi create Config-D ${filesize} s && ubi write ${loadaddr} Config-D ${filesize} && run reset_config
update_flash=run update_uboot && run update_ubi;
update_kernel=run prepare_update do_update_kernel
update_rootfs=run prepare_update do_update_rootfs
update_ubi=tftpboot ${loadaddr} ubi.img && ubi detach && nand erase.part ubi && nand write ${loadaddr} ubi ${filesize} && ubi part ${ubi_device} && env reload
update_uboot=mw.b ${loadaddr} ff 0x40000;tftpboot ${loadaddr} uboot-nand.bin && nand erase.part U-Boot && nand write ${loadaddr} U-Boot 0x40000
update_uboot_env=tftpboot ${loadaddr} uboot-env.bin && ubi remove Environment && ubi create Environment ${filesize} s && ubi write ${loadaddr} Environment ${filesize} && env reload
urb=run update_rootfs && run flash_flash

Environment size: 5251/7932 bytes
```

### Base

```
GRX500 # base
Base Address: 0x00000000
```

### BDInfo

```
GRX500 # bdinfo
boot_params = 0x8CBF6678
memstart    = 0x80000000
memsize     = 0x0E000000
flashstart  = 0x00000000
flashsize   = 0x00000000
flashoffset = 0x00000000
ethaddr     = 00:E0:92:00:01:42
ip_addr     = 192.168.1.1
baudrate    = 115200 bps
relocaddr   = 0x8CF97000
reloc off   = 0xECB97000
```


### coninfo

```
GRX500 # coninfo
List of available devices:
serial   00000003 IO stdin stdout stderr 
nulldev  00000003 IO 
lq_serial 00000003 IO 
```


### mii device

```md
GRX500 # mii device
MII devices: 'GRX500 SWITCH' 
Current device: 'GRX500 SWITCH'
```

### showvar

```
GRX500 # showvar
HUSH_VERSION=0.01
```

### ubi info

```
GRX500 # ubi info
UBI: MTD device name:            "ubi"
UBI: MTD device size:            127 MiB
UBI: physical eraseblock size:   131072 bytes (128 KiB)
UBI: logical eraseblock size:    126976 bytes
UBI: number of good PEBs:        1016
UBI: number of bad PEBs:         0
UBI: smallest flash I/O unit:    2048
UBI: VID header offset:          2048 (aligned 2048)
UBI: data offset:                4096
UBI: max. allowed volumes:       128
UBI: wear-leveling threshold:    256
UBI: number of internal volumes: 1
UBI: number of user volumes:     11
UBI: available PEBs:             387
UBI: total number of reserved PEBs: 629
UBI: number of PEBs reserved for bad PEB handling: 20
UBI: max/mean erase counter: 14/5
```

### version

```
GRX500 # version 

Tilgin UBI HG26xx/27xx_800 U-Boot 2016.07 (Oct 16 2021 - 18:08:38) 04_01_00_36
mips-linux-gcc (GCC) 6.3.0
GNU ld (GNU Binutils) 2.29.1
```

### Decrypt Configuration file

```
aespipe -d -e aes256 -H sha512 -p 5 5</home/wuseman/downloads/password-file.txt < /home/wuseman/downloads/vood_19700101_004208.cfg | tar -xz -C /home/wuseman/downloads/restore_directory
```



## Author

```
© 2023 - wuseman <wuseman@nr1.nu>
```

### Contact Page

  * Gentoo: https://wiki.gentoo.org/wiki/User:Wuseman
  * LibeaChat: https://web.libera.chat/



