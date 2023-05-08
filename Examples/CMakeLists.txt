cmake_minimum_required(VERSION 3.26)

project(arm-cmsis-dsp 
  DESCRIPTION "Examples for CMSIS-DSP"
  VERSION 1.14.4
  LANGUAGES C)

# Provides: `iar_cspy_test()`
include(cspybat.cmake)
  
set(CMAKE_CONFIGURATION_TYPES "")

list(APPEND CMAKE_CONFIGURATION_TYPES cortexM0l cortexM0b 
                                      cortexM3l cortexM3b
                                      cortexM4l cortexM4b cortexM4lf cortexM4bf
                                      cortexM7l cortexM7b cortexM7ls cortexM7bs cortexM7lf cortexM7bf
                                      ARMv8MBLl)

foreach(cfg ${CMAKE_CONFIGURATION_TYPES})
  find_library("lib_${cfg}"
    NAMES iar_${cfg}_math.a
    PATHS "${CMAKE_CURRENT_SOURCE_DIR}/../Lib" "${CMAKE_CURRENT_SOURCE_DIR}/../lib"
    REQUIRED)
endforeach()

set(TARGETS
  arm_convolution_test
  arm_dotproduct_test
  arm_fft_bin_test
  arm_fir_test
  arm_graphic_equalizer_test
  arm_linear_interp_test
  arm_matrix_test
  arm_signal_converge_test
  arm_sin_cos_test
  arm_variance_test)
  
foreach(TGT ${TARGETS})
  string(REGEX REPLACE "_test" "_example" tgt_example "${TGT}")

  file(GLOB c-sources ${CMAKE_CURRENT_SOURCE_DIR}/../CMSIS-DSP/Examples/ARM/${tgt_example}/*.c)

  add_executable(${TGT} ${c-sources})

  iar_cspy_test(${TGT} "SUCCESS")

  target_include_directories(${TGT} PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/../CMSIS_5/CMSIS/Core/Include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../CMSIS-DSP/Include"
    "${CMAKE_CURRENT_SOURCE_DIR}")

  set_target_properties(${TGT} PROPERTIES
    CPU_cortexM0l  Cortex-M0
    FPU_cortexM0l  None
    END_cortexM0l  little
    CPU_cortexM0b  Cortex-M0
    FPU_cortexM0b  None
    END_cortexM0b  big
    CPU_cortexM3l  Cortex-M3
    FPU_cortexM3l  None
    END_cortexM3l  little
    CPU_cortexM3b  Cortex-M3
    FPU_cortexM3b  None
    END_cortexM3b  big
    CPU_cortexM4l  Cortex-M4
    FPU_cortexM4l  None
    END_cortexM4l  little
    CPU_cortexM4lf Cortex-M4
    FPU_cortexM4lf vfpv4_sp
    END_cortexM4lf little
    CPU_cortexM4b  Cortex-M4
    FPU_cortexM4b  None
    END_cortexM4b  big
    CPU_cortexM4bf Cortex-M4
    FPU_cortexM4bf vfpv4_sp
    END_cortexM4bf big
    CPU_cortexM7l  Cortex-M7
    FPU_cortexM7l  None
    END_cortexM7l  little
    CPU_cortexM7b  Cortex-M7
    FPU_cortexM7b  None
    END_cortexM7b  big
    CPU_cortexM7ls Cortex-M7
    FPU_cortexM7ls vfpv5_sp
    END_cortexM7ls little
    CPU_cortexM7bs Cortex-M7
    FPU_cortexM7bs vfpv5_sp
    END_cortexM7bs big
    CPU_cortexM7lf Cortex-M7
    FPU_cortexM7lf vfpv5_d16
    END_cortexM7lf little
    CPU_cortexM7bf Cortex-M7
    FPU_cortexM7bf vfpv5_d16
    END_cortexM7bf big
    CPU_ARMv8MBLl  Cortex-M23.no_se
    FPU_ARMv8MBLl  None
    END_ARMv8MBLl  little)

  target_compile_definitions(${TGT} PRIVATE
    SEMIHOSTING)

  target_compile_options(${TGT} PRIVATE
    --debug
    --cpu=$<TARGET_PROPERTY:CPU_$<CONFIG>>
    --fpu=$<TARGET_PROPERTY:FPU_$<CONFIG>>
    --endian=$<TARGET_PROPERTY:END_$<CONFIG>>)

  target_link_options(${TGT} PRIVATE
    --semihosting
    --map ./$<CONFIG>/)

  target_link_libraries(${TGT} PRIVATE
    $<$<CONFIG:cortexM0l>:  ${lib_cortexM0l}>
    $<$<CONFIG:cortexM0b>:  ${lib_cortexM0b}>
    $<$<CONFIG:cortexM3l>:  ${lib_cortexM3l}>
    $<$<CONFIG:cortexM3b>:  ${lib_cortexM3b}>
    $<$<CONFIG:cortexM4l>:  ${lib_cortexM4l}>
    $<$<CONFIG:cortexM4b>:  ${lib_cortexM4b}>
    $<$<CONFIG:cortexM4lf>: ${lib_cortexM4lf}>
    $<$<CONFIG:cortexM4bf>: ${lib_cortexM4bf}>
    $<$<CONFIG:cortexM7l>:  ${lib_cortexM7l}>
    $<$<CONFIG:cortexM7b>:  ${lib_cortexM7b}>
    $<$<CONFIG:cortexM7ls>: ${lib_cortexM7ls}>
    $<$<CONFIG:cortexM7bs>: ${lib_cortexM7bs}>
    $<$<CONFIG:cortexM7lf>: ${lib_cortexM7lf}>
    $<$<CONFIG:cortexM7bf>: ${lib_cortexM7bf}>
    $<$<CONFIG:ARMv8MBLl>:  ${lib_ARMv8MBLl}>)
endforeach()
