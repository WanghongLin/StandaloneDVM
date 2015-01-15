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
ANDROID_SDK_ROOT	:= /home/mutter/android-sdk-linux
WORKING_PATH	:= $(LOCAL_PATH)/..
OUTPUT_DEX		:= $(WORKING_PATH)/Hello.dex
all:
	@echo -e "Dex\t\t\t\t: $(notdir $(OUTPUT_DEX))"
	@cd $(WORKING_PATH)/bin && $(ANDROID_SDK_ROOT)/build-tools/21.1.2/dx \
			--dex --output=$(OUTPUT_DEX) \
			com/mutter/standalonedvm/Hello.class
clean:
	@echo -e "Clean:\t $(notdir $(OUTPUT_DEX))"
	@rm -rf $(OUTPUT_DEX)

include $(CLEAR_VARS)
LOCAL_MODULE	:= StandaloneDVM 
LOCAL_SRC_FILES	:= StandaloneDVM.cpp
LOCAL_LDLIBS	:= -llog -ldl

include $(BUILD_EXECUTABLE)