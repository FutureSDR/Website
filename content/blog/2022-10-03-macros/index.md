+++
title = "Macros"
template = "article.html"
+++

We finally entered the
[`proc_macro`](https://doc.rust-lang.org/reference/procedural-macros.html) game
for some advanced syntactic sugaring :-) The macros are still experimental but
already fun to use.

At the moment, we support two macros; one for connecting the flowgraph and one
for implementing message handlers.

## Connect Macro

The `connect!` macro serves two purposes. It adds blocks to the flowgraph and it
allows to connect them.

This makes the code quite a bit cleaner. Compare, for example:

``` rust
fn main() -> Result<()> {
    let mut fg = Flowgraph::new();

    let src = NullSource::<u8>::new();
    let head = Head::<u8>::new(123);
    let snk = NullSink::<u8>::new();

    let src = fg.add_block(src);
    let head = fg.add_block(head);
    let snk = fg.add_block(snk);

    fg.connect_stream(src, "out", head, "in")?;
    fg.connect_stream(head, "out", snk, "in")?;

    Runtime::new().run(fg)?;

    Ok(())
}
```

with

``` rust
fn main() -> Result<()> {
    let mut fg = Flowgraph::new();

    let src = NullSource::<u8>::new();
    let head = Head::<u8>::new(123);
    let snk = NullSink::<u8>::new();

    connect!(fg, src > head > snk);

    Runtime::new().run(fg)?;

    Ok(())
}
```

The macro uses `>` to indicate stream connections and `|` to indicate message
connections.

``` rust
connect!(fg, stream_source > stream_sink);
connect!(fg, message_source | message_sink);
```

If the port connections are not the default `"in"` and `"out"`, they can be put
explicitly.

``` rust
connect!(fg, src.out > snk.in);
```

While it is uncommon, a port might have a space in its name. This can be solved
by quoting the port name.

``` rust
connect!(fg, src."output port" > snk.in);
```

If a port has no input or output ports that have to be connected, it can just be
put on a line on its own, which just adds it to the flowgraph.

``` rust
connect!(fg, dummy_block);
```

As shown in the example, blocks can also be chained.

``` rust
connect!(fg, src > head > snk);
```

And, finally, more complex topologies can be set up with multiple lines.

``` rust
connect!(fg, 
    src > fwd;
    fwd > snk;
    msg_src | msg_snk;
);
```

The idea and initial implementation of the `connect!` macro was by [Loïc
Fejoz](https://twitter.com/loic_fejoz). Thank you!

## Message Handlers

Handlers for message ports are, at the moment, quite ugly. This is mainly due to
current limitations of Rust's `async` functions that will hopefully be overcome
in the future.

Assume you want to implement a block with a handler `my_handler`.

``` rust
pub fn new() -> Block {
    Block::new(
        BlockMetaBuilder::new("MyBlock").build(),
        StreamIoBuilder::new().build(),
        MessageIoBuilder::new()
            .add_input("handler", Self::my_handler)
            .build(),
        Self,
    )
}
```

Using the `#[message_handler]` attribute macro, one can implement the handler
with:

``` rust
#[message_handler]
async fn my_handler(
    &mut self,
    _mio: &mut MessageIo<Self>,
    _meta: &mut BlockMeta,
    _p: Pmt,
) -> Result<Pmt> {
    Ok(Pmt::Null)
}
```

Which is much more what one would expect, compared to the dynamically generated
and boxed-up async block that it actually is under the hood.

All of this is still experimental, but it's amazing what is possible with proc macros.

If you want to see a complete example, we [added
one](https://github.com/FutureSDR/FutureSDR/blob/main/examples/macros/src/main.rs)
to the project.

Please give it a try and let us know what you think :-)

