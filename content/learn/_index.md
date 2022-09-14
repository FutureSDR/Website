+++
title = "Introduction"
template = "learn-section.html"
+++

{{ yt(id="G9SBruN9V-I") }}

## Installation

- Clone the FutureSDR repository:<br/>`git clone https://github.com/FutureSDR/FutureSDR.git`

### Linux (Ubuntu 22.04)

- Install [Rust](https://www.rust-lang.org/tools/install).
- Optionally, install SoapySDR drivers:<br/>`sudo apt install -y libsoapysdr-dev soapysdr-module-all soapysdr-tools`

### macOS

These instructions assume that you use [Homebrew](https://brew.sh) as package manager.
- Install [Rust](https://www.rust-lang.org/tools/install).
- Optionally, install SoapySDR: `brew install soapysdr`
- Additional drivers are available in the [Pothos Homebrew tap](https://github.com/pothosware/homebrew-pothos/wiki).

**Apple Silicon**: While rust works very well with `aarch64-apple-darwin` (Apple Silicon, i.e., M1, M1 Pro, M1 Max, etc.),
the rust compiler is not yet (as of May 2022) fully guaranteed to work, and cargo will by default compile to
`x86_64-apple-darwin` and rely on Rosetta 2. However, if you have a `x86_64-apple-darwin` machine, the packages installed
using Homebrew will by default be compiled for `aarch64-apple-darwin`, and therefore you need to compile FutureSDR for
`aarch64-apple-darwin` as well. This can be done by specifying the `--target aarch64-apple-darwin` flag to cargo, 
e.g., `cargo run --target aarch64-apple-darwin`.

### Windows

- Install [Rust](https://www.rust-lang.org/tools/install).
- [Visual Studio C++ Community Edition](https://visualstudio.microsoft.com/downloads/) (required components: Win10 SDK and VC++).

Visual Studio does not add its binaries and libraries to the PATH.
Instead, it offers various pre-configured terminals that have a given toolchain available.
Use the native toolchain for your system to build FutureSDR, e.g., *x64 Native Tools Command Prompt for VS 2022*.

For SoapySDR-based hardware drivers:
- [PothosSDR](https://downloads.myriadrf.org/builds/PothosSDR/) for pre-built SDR drivers. The installer offers to add the libraries to your `PATH`. Please do this.
- Install [bindgen dependencies](https://rust-lang.github.io/rust-bindgen/requirements.html#windows).
- Run `volk_profile` on the command line.

PothosSDR comes with many SoapySDR modules. Some of them require further software and services, which can cause issues when scanning for available devices.
If you run into this issue, either (1) use a filter to specify the driver manually or (2) move the problematic library to a backup folder outside the search path.
The libraries are, by default, at `C:\Program Files\PothosSDR\lib\SoapySDR\modules0.8`.
If, for example, SDRplay or UHD causes issues, move `sdrPlaySupport.dll` or `uhdSupport.dll` to a backup folder.

### All Platforms

To build the frontend:
* Install [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).
* Install the *wasm32* toolchain: `rustup target add wasm32-unknown-unknown`.
* Install *wasm-pack*: `cargo install wasm-pack`.
* Build: `cd frontend && npm install && make`.

