# Execute `cspybat` via `ctest`

# Enable CTest
enable_testing()

function(iar_cspy_test TARGET RESULT)
  find_program(CSPY_BAT
    NAMES cspybat CSpyBat
    PATHS ${TOOLKIT_DIR}/../common
    PATH_SUFFIXES bin
    REQUIRED)
  find_program(CSPY_DRV_PROC
    NAMES    ${CMAKE_SYSTEM_PROCESSOR}proc.dll    ${CMAKE_SYSTEM_PROCESSOR}PROC.dll
          lib${CMAKE_SYSTEM_PROCESSOR}proc.so  lib${CMAKE_SYSTEM_PROCESSOR}PROC.so
    PATHS ${TOOLKIT_DIR}/bin
    REQUIRED)
  find_program(CSPY_DRV_SIM
    NAMES    ${CMAKE_SYSTEM_PROCESSOR}sim2.dll    ${CMAKE_SYSTEM_PROCESSOR}SIM2.dll
          lib${CMAKE_SYSTEM_PROCESSOR}sim2.so  lib${CMAKE_SYSTEM_PROCESSOR}SIM2.so
    PATHS ${TOOLKIT_DIR}/bin
    REQUIRED)
  find_program(CSPY_DRV_BAT
    NAMES    ${CMAKE_SYSTEM_PROCESSOR}bat.dll    ${CMAKE_SYSTEM_PROCESSOR}Bat.dll
          lib${CMAKE_SYSTEM_PROCESSOR}bat.so  lib${CMAKE_SYSTEM_PROCESSOR}Bat.so
    PATHS ${TOOLKIT_DIR}/bin
    REQUIRED)

  # Add a test for CTest
  add_test(NAME ${TARGET}
           COMMAND ${CSPY_BAT} --silent
             # C-SPY drivers
             ${CSPY_DRV_PROC}
             ${CSPY_DRV_SIM}
             --plugin=${CSPY_DRV_BAT}
             # Debuggable ELF
             --debug_file=$<TARGET_FILE:${TARGET}>
             # C-SPY backend setup
             --backend
             --semihosting
             $<IF:$<STREQUAL:$<TARGET_PROPERTY:${TARGET},CPU_$<CONFIG>>,Cortex-M55.no_se.no_mve>,--cpu=Cortex-M55.no_se,--cpu=$<TARGET_PROPERTY:${TARGET},CPU_$<CONFIG>>>
             --fpu=$<TARGET_PROPERTY:${TARGET},FPU_$<CONFIG>>
             --endian=$<TARGET_PROPERTY:${TARGET},END_$<CONFIG>>
             $<IF:$<STREQUAL:$<TARGET_PROPERTY:${TARGET},END_$<CONFIG>>,big>,--BE8,>)

  # Set the test to interpret a C-SPY's message containing `SUCCESS`
  set_tests_properties(${TARGET} PROPERTIES PASS_REGULAR_EXPRESSION "${RESULT}")

endfunction()
