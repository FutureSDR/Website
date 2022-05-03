+++
title = "Sync vs Async Blocks"
template = "article.html"
+++

FutureSDR supports both sync and async blocks.
Their only difference is the `work()` function, which is either a normal or an async function.
Overall, a `Block` is an enum containing a sync/async block with a sync/async kernel, implementing `work()`.
This class structure already suggests that supporting both implementations leads to complexity, bloat, and code duplication.

``` rust
pub trait AsyncKernel: Send {
    async fn work(&mut self, ...) -> Result<()> {
        Ok(())
    }
    ...
}

pub trait SyncKernel: Send {
    fn work(&mut self, ...) -> Result<()> {
        Ok(())
    }
    ...
}
```

Obviously, it would be possible to just use async blocks, since one is not forced to `.await` anything inside an async function, i.e., one could just make any sync function async.
The reason both implementations exist, is that async blocks implement the `AsyncKernel` trait, defining async functions.
This is an area where Rust is still in active development.
Out-of-the-box, it does not support async trait functions, which is why everybody refrains to the [async_trait](https://docs.rs/async-trait/latest/async_trait/) crate that enables this.
The popularity of this crate shows how desperate people want this language feature.

The reason that it is not mainline is -- according to my understanding -- that there is a performance penalty to using async trait functions.
In short, one can think of an async function as a state machine with some local variables.
If the compiler knows the concrete realization, it can build complex, nested state machines during compilation.
If the compiler doesn't know the concrete realization due to dynamic dispatch of trait functions, it has to allocate the state machine during runtime for *every* function call.

This sounded like a complete performance disaster -- at least for `work()`, which is called over and over again.
Therefore, we added support for sync blocks, which avoid this overhead.

## Performance 

Already back then, some quick tests suggested that the performance difference might not be that big.
So the question is, whether it is really worth having both block types.
Today, we conducted some experiments to have a closer look.

The code and all scripts are available [here](https://github.com/bastibl/FutureSDR/tree/358cdafc70e60656ea19a23f900b3fcb2e6ed973/perf/sync).
In short, the measurements consider three schedulers: a single-threaded scheduler (Smol-1), a multi-threaded scheduler (Smol-N), an optimized, multi-threaded schedulers (Flow) that polls blocks in their natural order (upstream to downstream).
We make six CPU cores available to the process and use six worker threads for the multi-threaded schedulers.
The flowgraph consists of six independent subflows, each with a source that streams 200e6 32-bit floats into the flowgraph and #Stages (x-axis) number of copy blocks, each copying a random number samples (uniformly distributed in [1; 512]) in each call to work.
We create a sync and an async version of the otherwise identical copy blocks.

{{ figure(images=[['sync.svg', 100, 'Execution Time of Flowgraphs', 700]]) }}

The blocks do not do any DSP and only copy small chunks of samples.
The performance is, therefore, mainly determined by the overhead of the runtime and the potential overhead of the async block.
Yet, the differences are minor.

## Conclusion

This suggests that it is not worth supporting sync implementations.
At least not for now.
And in the future, I expect that things just get better.
There are [ongoing discussions](https://smallcultfollowing.com/babysteps//blog/2022/01/07/dyn-async-traits-part-7/) how Rust should handle async trait functions.
Maybe a more efficient way is found, which would further improve the situation.

In retrospect, one could see this as a failed premature optimization.
But it is also interesting to see the effect and quantify its impact on performance.
As time permits, I will go ahead and remove sync blocks, so we get back to a more minimal runtime.
