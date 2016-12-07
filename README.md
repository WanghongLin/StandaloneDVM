Standalone Dalvik Virtual Machine
===================================
An example to run the Android Dalvik VM in standalone mode

#### How to build and run?
```shell
$ git clone https://github.com/WanghongLin/StandaloneDVM
$ cd StandaloneDVMd
# invoke ndk-build to build
$ ndk-build
# if you have attached your device to computer also, invoke ndk-build with target "run"
# the script will push the executable and dex to your device's /data/local/tmp/ path
dfasdfasdf$ ndk-build run
dddddd
