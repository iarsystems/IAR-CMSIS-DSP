# GitHub's CMSIS-DSP Libraries in<br>IAR Embedded Workbench for Arm

[![CMSIS-DSP CI](https://github.com/IARSystems/IAR-CMSIS-DSP/actions/workflows/ci.yml/badge.svg)](https://github.com/IARSystems/IAR-CMSIS-DSP/actions/workflows/ci.yml)
[![badge](https://img.shields.io/badge/license-Apache2.0-blue)](https://github.com/iarsystems/iar-cmsis-dsp/blob/master/LICENSE)

CMSIS, or Cortex Microcontroller Software Interface Standard, consists of a vendor-independent hardware abstraction layer for Arm Cortex processors which provides consistent device support. It provides simple software interfaces to the processor and the peripherals, simplifying software re-use, reducing the learning curve for developers, and reducing the time to market for new devices.

Designed on top of CMSIS, CMSIS-DSP is a comprehensive suite of compute kernels for applications requiring compute performance on mathematics (basic, fast, real, complex, quaternion, linear algebra), filtering (DSP), transforms (FFT, MFCC, DCT), statistics, classical ML, and related functionalities, built as a library for Arm Cortex-M devices.

In general, the CMSIS-DSP Library is supposed to be delivered as a CMSISPack provided by silicon vendors. However, the library can also be used by non-CMSISPack projects. This repository offers a process for building the CMSIS-DSP Library from its latest sources, in IAR Embedded Workbench for Arm, for non-CMSISPack enabled projects.

### Current software versions
| Software component | Version
| - | - 
| IAR Embedded Workbench for Arm | [v9.60.2](https://iar.com/ewarm) (or [earlier releases](https://github.com/iarsystems/IAR-CMSIS-DSP/releases))
| CMSIS                          | [V6.1.0](https://github.com/ARM-software/CMSIS_6/releases/tag/v6.1.0)
| CMSIS-DSP                      | [V1.16.2](https://github.com/ARM-software/CMSIS-DSP/releases/tag/v1.16.2)

> [!TIP]
> For non-CMSISPack projects, IAR Embedded Workbench for Arm already ships with pre-built CMSIS-DSP Libraries based on version 1.8.0. For simplicity, if you do not need the library's bleeding edge features, consider [using a pre-built library](https://github.com/IARSystems/IAR-CMSIS-DSP/wiki/Using-the-CMSIS%E2%80%90DSP-Library-in-IAR-Embedded-Workbench-for-Arm) instead.

## How to build
The library is released in source form. It is strongly advised to build the library with optimizations for high speed to get the best performances.

### Cloning
This repository comes with 2 submodules: [CMSIS-DSP](https://github.com/arm-software/CMSIS-DSP/) and also [CMSIS_6](https://github.com/arm-software/CMSIS_6/). The reason is that the library needs the `CMSIS_6/CMSIS/Core/Include/` headers to build. 

Clone this repository alongside its submodules. For example, using the Command Prompt with [Git for Windows](https://github.com/git-for-windows/git/releases/latest):
```
set CLONE_DIR=%PROGRAMDATA%/IARSystems/github.com/IAR-CMSIS-DSP/
git clone --recurse-submodules https://github.com/IARSystems/IAR-CMSIS-DSP %CLONE_DIR%
```

### Building
In IAR Embedded Workbench for Arm:
1. Open the folder `%PROGRAMDATA%/IARSystems/github.com/IAR-CMSIS-DSP/`.
2. Open the [Library/arm_cortexM_math.eww](Library) workspace.
3. Hit <kbd>F8</kbd> and choose `   Build All   `.

In our example, static libraries for the supported core variants should now be available at your local repository (`%PROGRAMDATA%/IARSystems/github.com/IAR-CMSIS-DSP/Lib/*.a`).

> [!NOTE]
>  Unless updated, these libraries only need to be built once and can be used by any project that links against them.

## Examples
The CMSIS-DSP Library ships with a number of examples which demonstrate how to use the library functions. Please refer to [Examples](Examples) for an IAR Embedded Workbench Workspace (`CMSIS-DSP_Examples.eww`) with example projects. The examples documentation can be found [here](https://arm-software.github.io/CMSIS-DSP/latest/group__groupExamples.html).

> [!NOTE]
> These projects are configured for a generic Cortex-M4 with single-precision FPU. They are ready to run in the Simulator.

## Using the Library
The library functions are declared in the public file `/path/to/CMSIS-DSP/Include/arm_math.h`. Simply include this header file to your application.

### Windows Environment Variable
One possibility for referencing `CMSIS-DSP/Include` is to set `/path/to/IAR-CMSIS-DSP` as a user environment variable.

1. In the Windows' **Start** menu, search and execute "Edit Environment Variables for your Account"
2. Add the following to the _User variables_:

| Variable      | Value                                                |
| :------------ | :--------------------------------------------------- |
| IAR_CMSIS_DSP | `%PROGRAMDATA%/IARSystems/github.com/IAR-CMSIS-DSP/` |

That way, you can use the environment variable `%IAR_CMSIS_DSP%` from anywhere in the Windows OS to refer to where the libraries are to be found.

### Project → **Options** (<kbd>Alt</kbd> + <kbd>F7</kbd>) 
In your application project, consider the following options.

#### General Options → **Library Configuration**
Make sure your project is not using the IDE-provided CMSIS-DSP library:
> CMSIS (legacy)
> - [ ] Use CMSIS 5.7
>    - [ ] DSP library

> [!WARNING]
>  The library's API in the latest version has changed since CMSIS-DSP V1.8.0. Refer to the [online documentation](https://arm-software.github.io/CMSIS-DSP/latest) for details.

#### General Options → Target
In your application project, verify which target is selected.

> [!NOTE]
> By default, new projects in IAR Embedded Workbench for Arm will assume Core:`Cortex-M3`.

#### C/C++ Compiler → **Preprocessor**
Add these folders containing the library headers to your project's preprocessor options:
```
$_IAR_CMSIS_DSP_$/CMSIS_6/Core/Include
$_IAR_CMSIS_DSP_$/CMSIS-DSP/Include
```
> [!NOTE]
> IAR Embedded Workbench can refer to an environment variable (e.g., `%ENV_VAR%`) when expressed between `$_` and `_$` (e.g., `$_ENV_VAR_$`).

#### Linker → **Libraries**
For linking a library against an application, it is important to match the same target configuration (CPU, FPU, Endianess, ...) in both projects. 

In the application project's linker/library option, add the appropriate CMSIS-DSP library for the selected target.

To select the appropriate library, follow the naming convention:
```
$_IAR_CMSIS_DSP_$/Lib/iar_<library-selection>_math.a
```
- Mapping for `<library-section>`:

| Arm Core    | ARM architecture   | Endian  | soft float   |  [SP](https://en.wikipedia.org/wiki/Single-precision_floating-point_format) float | [DP](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) float | [HP](https://en.wikipedia.org/wiki/Half-precision_floating-point_format) float |
| ----------- | ------------------ | ------- | ------------- | -------------- | ---------------- | ---------------- |
| Cortex-M0   | ARMv6-M            | little  | `cortexM0l`   |
| Cortex-M0   | ARMv6-M            | big     | `cortexM0b`   |
| Cortex-M3   | ARMv7-M            | little  | `cortexM3l`   |
| Cortex-M3   | ARMv7-M            | big     | `cortexM3b`   |
| Cortex-M4   | ARMv7E-M           | little  | `cortexM4l`   | `cortexM4lf`   |
| Cortex-M4   | ARMv7E-M           | big     | `cortexM4b`   | `cortexM4bf`   |
| Cortex-M7   | ARMv7E-M           | little  | `cortexM7l`   | `cortexM7ls`   | `cortexM7lf`     |
| Cortex-M7   | ARMv7E-M           | big     | `cortexM7b`   | `cortexM7bs`   | `cortexM7bf`     |
| Cortex-M23  | ARMv8-M Baseline   | little  | `ARMv8MBLl`   |
| Cortex-M33  | ARMv8-M Mainline   | little  | `ARMv8MMLl`   | `ARMv8MMLlfsp` | `ARMv8MMLlfdp`   |
| Cortex-M35P | ARMv8-M Mainline   | little  | `ARMv8MMLl`   | `ARMv8MMLlfsp` | `ARMv8MMLlfdp`   |
| Cortex-M55  | ARMv8.1-M Mainline | little  | `ARMv81MMLld` |                | `ARMv81MMLldfdp` | `ARMv81MLldfdph` |
| Cortex-M85  | ARMv8.1-M Mainline | little  | `ARMv81MMLld` |                | `ARMv81MMLldfdp` | `ARMv81MLldfdph` |

> [!NOTE]
> The [Library/arm_cortexM_math.eww](Library) workspace can be inspected for further details on each target's configurations.

## Updating the CMSIS submodules
For getting the newest versions of the CMSIS submodules in your repository, use:
```
git submodule foreach git pull
```

## Support/Contact
- For IAR technical support contact [IAR Customer Support](https://iar.my.site.com/mypages/s/contactsupport).
- For problems related to the contents of this repository, please create a new issue in https://github.com/IARSystems/IAR-CMSIS-DSP/issues.
- For problems with the CMSIS-DSP Library itself, reach out to the CMSIS-DSP team. Please create a new issue in https://github.com/ARM-software/CMSIS-DSP/issues.

## Conclusion
IAR Embedded Workbench for Arm unleashes compute performance when paired with highly optimized CMSIS-DSP libraries on Cortex-M devices.
