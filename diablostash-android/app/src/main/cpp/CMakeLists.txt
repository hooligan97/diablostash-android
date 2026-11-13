cmake_minimum_required(VERSION 3.22.1)
project("stash_native")

add_library(${CMAKE_PROJECT_NAME} SHARED
    jni_bridge.cpp
    stash_parser.cpp
)

find_library(log-lib log)

target_link_libraries(${CMAKE_PROJECT_NAME}
    ${log-lib}
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_features(${CMAKE_PROJECT_NAME} PRIVATE cxx_std_17)
