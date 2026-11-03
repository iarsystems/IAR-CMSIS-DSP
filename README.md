# CMSIS-DSP Libraries for IAR Embedded Workbench for Arm

[![CMSIS-DSP v1.18.0](https://github.com/IARSystems/IAR-CMSIS-DSP/actions/workflows/ci.yml/badge.svg)](https://github.com/IARSystems/IAR-CMSIS-DSP/actions/workflows/ci.yml)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache2.0-blue)](https://github.com/iarsystems/iar-cmsis-dsp/blob/master/LICENSE)

CMSIS, or Cortex Microcontroller Software Interface Standard, consists of a vendor-independent hardware abstraction layer for Arm Cortex processors which provides consistent device support. It provides simple software interfaces to the processor and the peripherals, simplifying software re-use, reducing the learning curve for developers, and reducing the time to market for new devices.

Designed on top of CMSIS, CMSIS-DSP is a comprehensive suite of compute kernels for applications requiring compute performance on mathematics (basic, fast, real, complex, quaternion, linear algebra), filtering (DSP), transforms (FFT, MFCC, DCT), statistics, classical ML, and related functionalities, built as a library for Arm Cortex-M devices.

In general, the CMSIS-DSP Library is supposed to be delivered as a CMSISPack provided by silicon vendors. However, the library can also be used by non-CMSISPack projects. This repository offers a process for building the CMSIS-DSP Library from its latest sources, in IAR Embedded Workbench for Arm, for non-CMSISPack enabled projects.

IAR Embedded Workbench for Arm unleashes compute performance when paired with highly optimized CMSIS-DSP libraries on Cortex-M devices.


## How to build CMSIS-DSP Libraries
The CMSIS-DSP Library is released in source form. It is strongly advised to build the library with optimizations for high speed to get the best performances.

### Software components
Currently this repository uses the following software:
- IAR Embedded Workbench for Arm [v10.10.2](https://iar.com/ewarm) ([previous releases](https://github.com/iarsystems/IAR-CMSIS-DSP/releases))
- CMSIS-DSP [v1.18.0](https://github.com/ARM-software/CMSIS-DSP/releases/tag/v1.18.0)
- CMSIS [v6.4.0](https://github.com/ARM-software/CMSIS_6/releases/tag/v6.4.0)

### Cloning
Set a persistent environment variable for your operating system named `CMSIS_DSP_PATH` containing the path to which you intend to clone this repository. This environment variable serve as a persistent reference for any application projects making use of one these libraries.

- **Linux** (using Bash)
```bash
# Automatically sourced at login by XDG-compliant Desktop Environments (KDE, GNOME, XFCE, etc.)
mkdir -p ~/.config/environment.d
echo "CMSIS_DSP_PATH=~/.iar/IAR-CMSIS-DSP" >> ~/.config/environment.d/xdg.conf

# For Bash and friends
echo "export CMSIS_DSP_PATH=~/.iar/IAR-CMSIS-DSP" >> ~/.profile
source ~/.profile

git clone --recurse-submodules https://github.com/IARSystems/IAR-CMSIS-DSP $CMSIS_DSP_PATH
```

- **Windows** (using Command Prompt)
```cmd
setx CMSIS_DSP_PATH "%USERPROFILE%/.iar/IAR-CMSIS-DSP"
git clone --recurse-submodules https://github.com/IARSystems/IAR-CMSIS-DSP %CMSIS_DSP_PATH%
```

### Building
We provide an Embedded Workbench Workspace to facilitate the building of static libraries for the supported core variants.

In IAR Embedded Workbench for Arm:
1. Open the `<CMSIS_DSP_PATH>/Library/arm_cortexM_math.eww` workspace.
2. Hit <kbd>F8</kbd>
3. Choose `   Build All   `.

The libraries can be found at `<CMSIS_DSP_PATH>/Lib/iar_*_math.a`. Unless there are changes in the compiler version or in the CMSIS-DSP Library sources, there is no explicit need to build them more than once. They are reusable by any applications linking against them.

The project in this workspace brings a build configuration for each supported core. Inspect the build configurations for further details.


## Examples
We provide an Embedded Workbench Workspace at [`<CMSIS_DSP_PATH>/Examples/CMSIS-DSP_Examples.eww`](Examples), with projects ready to run on a simulated Cortex-M4 target with single-precision FPU.


## Using the Library
The library functions are declared in the `arm_math.h` public header file. Simply include this header file to your application.

###
In your application project, consider the following options:

####  Project → **Options** (<kbd>Alt</kbd> + <kbd>F7</kbd>) → General Options → **Target**
In your application project, select the desired target device. By default, new projects comes with Core:`Cortex-M3`.

#### Project → **Options** (<kbd>Alt</kbd> + <kbd>F7</kbd>) → C/C++ Compiler → **Preprocessor**
IAR Embedded Workbench can map environment variables when they are expressed between `$_` and `_$` (e.g., `$_CMSIS_DSP_PATH_$`).

Add the following header directories to your compiler's preprocessor options in your project:
```
$_CMSIS_DSP_PATH_$/CMSIS_6/CMSIS/Core/Include
$_CMSIS_DSP_PATH_$/CMSIS-DSP/Include
```

#### Project → **Options** (<kbd>Alt</kbd> + <kbd>F7</kbd>) → Linker → **Libraries**
The table below maps which library to use for each supported Arm Cortex-M core:

| Cortex-M<br>core    | Architecture   | Endian  | soft float    |  [SP][wiki-fp-sp] float | [DP][wiki-fp-dp] float | [HP][wiki-fp-hp] float |
| :-----------: | ------------------ | :-------: | ------------- | ----------------------- | ---------------------- | ---------------------- |
| M0   | ARMv6-M            | little  | `cortexM0l`   |
| M0   | ARMv6-M            | big     | `cortexM0b`   |
| M3   | ARMv7-M            | little  | `cortexM3l`   |
| M3   | ARMv7-M            | big     | `cortexM3b`   |
| M4   | ARMv7E-M           | little  | `cortexM4l`   | `cortexM4lf`            |
| M4   | ARMv7E-M           | big     | `cortexM4b`   | `cortexM4bf`            |
| M7   | ARMv7E-M           | little  | `cortexM7l`   | `cortexM7ls`            | `cortexM7lf`
| M7   | ARMv7E-M           | big     | `cortexM7b`   | `cortexM7bs`            | `cortexM7bf`
| M23  | ARMv8-M Baseline   | little  | `ARMv8MBLl`   |
| M33  | ARMv8-M Mainline   | little  | `ARMv8MMLl`   | `ARMv8MMLlfsp`          | `ARMv8MMLlfdp`
| M35P | ARMv8-M Mainline   | little  | `ARMv8MMLl`   | `ARMv8MMLlfsp`          | `ARMv8MMLlfdp`
| M55  | ARMv8.1-M Mainline | little  | `ARMv81MMLld` |                         | `ARMv81MMLldfdp`       | `ARMv81MLldfdph`
| M85  | ARMv8.1-M Mainline | little  | `ARMv81MMLld` |                         | `ARMv81MMLldfdp`       | `ARMv81MLldfdph`

[wiki-fp-sp]: https://en.wikipedia.org/wiki/Single-precision_floating-point_format
[wiki-fp-dp]: https://en.wikipedia.org/wiki/Double-precision_floating-point_format
[wiki-fp-hp]: https://en.wikipedia.org/wiki/Half-precision_floating-point_format

In your application project, add the CMSIS-DSP Library matching your application's target device. Follow the naming convention `$_CMSIS_DSP_PATH_$/Lib/iar_<library-selection>_math.a`.

For example, an application developed for a Cortex-M55 with double-precision FPU should be linked against:
```
$_CMSIS_DSP_PATH_$/Lib/iar_ARMv81MMLldfdp_math.a
```

## Issues
- For IAR technical support contact [IAR Customer Support](https://iar.my.site.com/mypages/s/contactsupport).
- For problems related to the contents of this repository, please create a new issue in [here](https://github.com/IARSystems/IAR-CMSIS-DSP/issues).
- For problems with the CMSIS-DSP Library itself, reach out to the CMSIS-DSP team. Please create a new issue in [here](https://github.com/ARM-software/CMSIS-DSP/issues).
