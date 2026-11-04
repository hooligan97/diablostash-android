cmake_minimum_required(VERSION 3.22)
project(stash_parser_tests)

add_executable(test_parser test_parser.cpp ../app/src/main/cpp/stash_parser.cpp)
target_include_directories(test_parser PRIVATE ../app/src/main/cpp)
target_compile_features(test_parser PRIVATE cxx_std_17)
