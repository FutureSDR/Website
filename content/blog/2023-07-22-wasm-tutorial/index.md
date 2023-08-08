+++
title = "WebAssembly Tutorial"
template = "article.html"
+++

With all the cool Software Defined Radio (SDR) WebAssembly projects popping up, it seems like 2023 is the year of SDR in the browser :-)

We recently worked on improving the WebAssembly support for [FutureSDR](https://www.futuresdr.org/) and are pretty happy with the result.
It no longer requires pulling a lot of tricks to cross-compile the native driver with emscripten but enables a complete Rust workflow.

The current user experience is shown in a tutorial-style live coding video, where we port a native FutureSDR ZigBee receiver to WebAssembly.

{{ yt(id="I-g8N0CR_rk") }}
