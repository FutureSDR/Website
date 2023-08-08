+++
title = "FutureSDR MobiCom Demo Accepted"
template = "article.html"
+++

Our [FutureSDR](https://www.futuresdr.org/) + [IPEC](https://git.esa.informatik.tu-darmstadt.de/ipec/ipec) demo is accepted at [ACM MobiCom 2023](https://sigmobile.org/mobicom/2023/). Yay!

In the demo, we show the same FutureSDR receiver running on three very different platforms:
- a normal laptop, interfacing an Aaronia Spectran v6 SDR
- a web browser, compiled to WebAssembly and interfacing a HackRF SDR through WebUSB
- an AMD/Xilinx RFSoC ZCU111 evaluation board

On the ZCU111, the same decoder is implemented both in software (using FutureSDR) and in hardware (using IPEC).
Since both implementations have the same structure, we can configure during runtime after which decoding stage to switch from FPGA to CPU processing.

With regard to FutureSDR, this highlights two important features:

- We show the portability of FutureSDR, having the same receiver running on three very different platforms.
- We show that the software implementation is capable of offloading different parts of the decoding dynamically during runtime.

Please checkout the paper for further information or visit our booth at the conference.

{{ bib(keys = ["volz2023software"]) }}

