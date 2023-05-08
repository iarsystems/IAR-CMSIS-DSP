# Toolchain File for the IAR C/C++ Compiler for Arm V9.40.1

# Action: Set the `TOOLKIT` variable
set(TOOLKIT arm)

# Get the toolchain target from the TOOLKIT
get_filename_component(CMAKE_SYSTEM_PROCESSOR ${TOOLKIT} NAME)

# Set CMake for cross-compiling
set(CMAKE_SYSTEM_NAME Generic)

# IAR C Compiler
find_program(CMAKE_C_COMPILER
  NAMES icc${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{ProgramFiles}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# IAR C++ Compiler
find_program(CMAKE_CXX_COMPILER
  NAMES icc${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{PROGRAMFILES}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# IAR Assembler
find_program(CMAKE_ASM_COMPILER
  NAMES iasm${CMAKE_SYSTEM_PROCESSOR} a${CMAKE_SYSTEM_PROCESSOR}
  PATHS ${TOOLKIT}
        "$ENV{PROGRAMFILES}/IAR Systems/*"
        /opt/iarsystems/bx${CMAKE_SYSTEM_PROCESSOR}
  PATH_SUFFIXES bin ${CMAKE_SYSTEM_PROCESSOR}/bin
  REQUIRED )

# Avoids running the linker during try_compile()
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Set the TOOLKIT_DIR variable for the CMakeLists
get_filename_component(BIN_DIR ${CMAKE_C_COMPILER} DIRECTORY)
get_filename_component(TOOLKIT_DIR ${BIN_DIR} PATH)
unset(BIN_DIR)
