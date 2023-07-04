+++
title = "FutureSDR Demo at 6G Platform Germany"
template = "article.html"
+++

[David Volz](https://www.esa.informatik.tu-darmstadt.de/team/dv) and I presented our demo *FutureSDR meets IPEC* at the [Berlin 6G Conference](https://www.6g-plattform.de/berlin-6g-conference/), a meeting of all 6G-related projects, funded by the Federal Ministry of Education and Research (BMBF).
Our demo showed how [FutureSDR](https://www.futuresdr.org/) can be used to implement platform-independent real-time signal processing applications that can be reconfigured during runtime.

We had the same FutureSDR receiver running on a [Xilinx RFSoC FPGA board](https://www.xilinx.com/products/boards-and-kits/zcu111.html), a normal laptop with an [Aaronia Spectran V6](https://aaronia.com/de/spectran-v6-rsa-2000x) SDR, an in the web, using a [HackRF](https://greatscottgadgets.com/hackrf/one/).
We, furthermore, had the same receiver implemented on the FPGA of the RFSoC, using David's [IPEC](https://git.esa.informatik.tu-darmstadt.de/ipec/ipec) framework for Inter-Processing Element Communication.
Since the FPGA and the CPU implementations had the same structure, we could dynamically decide where to make the cut between FPGA and CPU processing, which was reflected in the CPU load of the RFSoC's ARM processor.

<blockquote class="twitter-tweet tw-align-center"><p lang="en" dir="ltr">Happy to demonstrate our <a href="https://twitter.com/FutureSDR?ref_src=twsrc%5Etfw">@FutureSDR</a> setup, using the <a href="https://twitter.com/Aaronia_AG?ref_src=twsrc%5Etfw">@Aaronia_AG</a> Spectran V6 and the Xilinx RFSoC at the 6G Platform Germany Meeting of <a href="https://twitter.com/BMBF_Bund?ref_src=twsrc%5Etfw">@BMBF_Bund</a> <a href="https://t.co/9CTmwfFihU">pic.twitter.com/9CTmwfFihU</a></p>&mdash; Bastian Bloessl (@bastibl) <a href="https://twitter.com/bastibl/status/1673743433767190528?ref_src=twsrc%5Etfw">June 27, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
