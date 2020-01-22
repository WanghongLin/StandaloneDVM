project(StandaloneDVM)

cmake_minimum_required(VERSION 3.10)

include(FindJNI)
if (JNI_FOUND)
    include_directories(${JNI_INCLUDE_DIRS})
endif (JNI_FOUND)

add_executable(StandaloneDVM StandaloneDVM.cpp)