cmake_minimum_required(VERSION 3.18)
project(snorvy_microfrontend C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# kissfft is included via #include "kiss_fft.c" inside kiss_fft_int16.cc, so
# only the headers/sources from kissfft/ live in the include path. The two
# `*_int16` C++ wrappers compile their kissfft .c sources inline.

set(MFE_SRC ${CMAKE_CURRENT_SOURCE_DIR}/tensorflow/lite/experimental/microfrontend/lib)
set(KISS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/kissfft)

add_library(snorvy_microfrontend SHARED
  ${CMAKE_CURRENT_SOURCE_DIR}/snorvy_microfrontend.c
  ${MFE_SRC}/fft.cc
  ${MFE_SRC}/fft_util.cc
  ${MFE_SRC}/filterbank.c
  ${MFE_SRC}/filterbank_util.c
  ${MFE_SRC}/frontend.c
  ${MFE_SRC}/frontend_util.c
  ${MFE_SRC}/kiss_fft_int16.cc
  ${MFE_SRC}/log_lut.c
  ${MFE_SRC}/log_scale.c
  ${MFE_SRC}/log_scale_util.c
  ${MFE_SRC}/noise_reduction.c
  ${MFE_SRC}/noise_reduction_util.c
  ${MFE_SRC}/pcan_gain_control.c
  ${MFE_SRC}/pcan_gain_control_util.c
  ${MFE_SRC}/window.c
  ${MFE_SRC}/window_util.c
)

target_include_directories(snorvy_microfrontend PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${KISS_DIR}
)

target_compile_definitions(snorvy_microfrontend PRIVATE
  FIXED_POINT=16
)

target_compile_options(snorvy_microfrontend PRIVATE
  -O2
  -ffast-math
  -fvisibility=hidden
  -Wno-unused-parameter
  -Wno-unused-but-set-variable
  -Wno-unused-variable
  -Wno-deprecated-declarations
)

target_link_libraries(snorvy_microfrontend PRIVATE m)
