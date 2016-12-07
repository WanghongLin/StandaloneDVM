# Copyright 2015 Android Open Source Project
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
LOCAL_PATH	:= $(call my-dir)

# use sdk tool dex to create dex file
# change variable ANDROID_SDK_ROOT to the directory of your Android SDK
ANDROID_SDK_ROOT_	:= $(ANDROID_SDK_ROOT)
WORKING_PATH	:= $(LOCAL_PATH)/..
OUTPUT_DEX		:= $(shell pwd)/Hello.dex

ifeq ($(strip $(ANDROID_SDK_ROOT_)),)
$(error ANDROID_SDK_ROOT not set)
endif

ADB_EXE := $(ANDROID_SDK_ROOT_)/platform-tools/adb

default: run

all:
	@printf "Dex\t\t\t\t: $(notdir $(OUTPUT_DEX))\n"
	@javac $(WORKING_PATH)/src/com/mutter/standalonedvm/Hello.java
	@cd $(WORKING_PATH)/src && $(ANDROID_SDK_ROOT_)/build-tools/22.0.1/dx \
			--dex --output=$(OUTPUT_DEX) \
			com/mutter/standalonedvm/Hello.class
	@printf "\e[32mWrite to dex file $(OUTPUT_DEX)\e[30m\n"

# We need to remove the trailing carriage return from the output of ADB
run: all
	@[ `$(ADB_EXE) get-state` ] || { printf '\e[31mNo device attached, please attach your Android device and run again.\e[30m\n'; exit 1; }
	@[ `$(ADB_EXE) shell "[ -f /system/lib/libdvm.so ] && echo 0 || echo 1" |tr -d '\r'` == 0 ] && exit 0 || { printf "\e[31mThe device has newer ART, not Dalvik virtual machine\e[30m\n"; exit 1; }
	@$(ADB_EXE) push $(shell pwd)/libs/armeabi-v7a/StandaloneDVM /data/local/tmp/
	@$(ADB_EXE) push $(OUTPUT_DEX) /data/local/tmp/
	@$(ADB_EXE) shell /data/local/tmp/StandaloneDVM

clean:
	@printf "Clean:\t $(notdir $(OUTPUT_DEX)) libs obj\n"
	@rm -rfv $(OUTPUT_DEX)
	@rm -rfv libs obj
	@{ find . -name "*.class" -delete; exit 0; }

include $(CLEAR_VARS)
LOCAL_MODULE	:= StandaloneDVM 
LOCAL_SRC_FILES	:= StandaloneDVM.cpp
LOCAL_LDLIBS	:= -llog -ldl

include $(BUILD_EXECUTABLE)
