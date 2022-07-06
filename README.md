Standalone Dalvik Virtual Machine
===================================
An example to run the Android Dalvik VM in standalone mode

#### How to build and run?
```shell
$ git clone https://github.com/WanghongLin/StandaloneDVM
$ cd StandaloneDVMd
# invoke ndk-build to build, but make sure ANDROID_SDK_ROOT has been added to your bash enviroment
$ ndk-build
# if you have attached your device to computer also, invoke ndk-build with target "run"
# the script will push the executable and dex to your device's /data/local/tmp/ path
$ ndk-build run
```

#### For ART support
No extra steps need to take, just invoke them from `adb shell`, e.g if you want to run `com.example.Main` and load some extra native libraries, do like following

```shell
$ adb shell
$ cd /apex/com.android.art/bin
$ ./dalvikvm64 -verbose:third-party-jni -Xjnitrace:String -cp /data/local/tmp/app-debug.apk -Djava.library.path=/data/local/tmp com.example.Main
```
