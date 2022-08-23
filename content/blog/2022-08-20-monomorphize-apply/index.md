+++
title = "Monomorphized Apply-/Functional-Style Blocks"
template = "article.html"
+++

We [already discussed](https://www.futuresdr.org/blog/generic-blocks/) blocks that are generic over a function and showed how they are handy for rapid prototyping.
These apply- or functional-style blocks proved incredibly useful and are utilized in many [examples](https://github.com/FutureSDR/FutureSDR/tree/main/examples).

For example, a block that doubles every float is just `Apply::new(|i: &f32| i * 2.0)`.

However, until now, these blocks had an inherent drawback, since the function was dispatched dynamically during runtime.
To be precise, the function was a closure allocated on the heap, which resulted in a function call per item, without any chance for the compiler to optimize things.

From FutureSDR v0.0.22, we avoid this overhead, making the blocks generic over the function, instead of a heap-allocated closure.
This means, we move [from](https://docs.rs/futuresdr/0.0.21/futuresdr/blocks/struct.Apply.html)

``` rust
pub struct Apply<A, B>
where
    A: 'static,
    B: 'static,
{
    f: Box<dyn FnMut(&A) -> B + Send + 'static>,
}
```

[to](https://docs.rs/futuresdr/0.0.22/futuresdr/blocks/struct.Apply.html)

``` rust
pub struct Apply<F, A, B>
where
    F: FnMut(&A) -> B + Send + 'static,
    A: Send + 'static,
    B: Send + 'static,
{
    f: F,
}
```

With this, the compiler generates a separate implementation for each apply-style block, i.e., it is monomorphized.
This is in contrast to the old version, which was polymorphic in the sense that there was one  `Apply` implementation that could handle any function closure with a given I/O signature.

Switching to monomorphized blocks, the compiler can inline the function and apply optimizations.
There is, for example, no reason the compiler couldn't vectorize the function to benefit from SIMD instructions.

We did a quick performance comparison for a simple operation (`|x: &u8| x.wrapping_add(1)`).
To this end, we mocked the `Apply` block and processed 100M samples.
On my machine, this took ~24ms for the monomorphized version vs ~127ms for the old, dynamically dispatched version.

<script src="https://gist.github.com/bastibl/a1e68085bc0524265291e58aea23b368.js"></script>
