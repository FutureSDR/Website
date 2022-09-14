+++
title = "Better Flowgraph Interaction"
template = "article.html"
+++

A `FlowgraphHandle` is the main struct to interact with a flowgraph, once it is
started and ownership is passed to the runtime. In essence, the handle wraps the
sending part of a multi-producer-single-consumer channel to send
`FlowgraphMessage`s, which define the protocol between the flowgraph and the
outside world.

``` rust
pub struct FlowgraphHandle {
    inbox: Sender<FlowgraphMessage>,
}
```

Recently, we extended the interface, allowing the user to get a
`FlowgraphDescritpion` or `BlockDescription` from the handle. This information
can be used, for example, with GUI components to plot the flowgraph topology.

``` rust
pub struct FlowgraphDescription {
    pub blocks: Vec<BlockDescription>,
    pub stream_edges: Vec<(usize, usize, usize, usize)>,
    pub message_edges: Vec<(usize, usize, usize, usize)>,
}
```

The interaction with the flowgraph is pretty elegant. We send it a message,
asking for a `FlowgraphDescription` and provide a channel, where we `await` the
result. This is sometimes referred to as the *Actor Pattern*.

``` rust
pub async fn description(&mut self) -> Result<FlowgraphDescription> {
    let (tx, rx) = oneshot::channel::<FlowgraphDescription>();
    self.inbox
        .send(FlowgraphMessage::FlowgraphDescription { tx })
        .await?;
    let d = rx.await?;
    Ok(d)
}
```

## Control Port

Apart from extending the flowgraph handle, we refactored the control port
interface of the flowgraph (i.e., the REST API) to use the `FlowgraphHandle`.
Prior to that, there was a disconnect, which resulted in code duplication. Now,
the web application server just uses the handle and exposes a web interface for
it.

Both `FlowgraphDescription` and `BlockDescription` are serializable structs that
are exposed at `localhost:1337/api/fg/` and `localhost:1337/api/block/<n>/`.

{{ figure(images=[['fg-json.png', 100, 'Querying the new API w/ Curl.', 400]]) }}

Using the `FlowgraphHandle` with control port, the whole web server endpoint is
just:

``` rust
async fn flowgraph_description(
    Extension(mut flowgraph): Extension<FlowgraphHandle>,
) -> Result<Json<FlowgraphDescription>, StatusCode> {
    if let Ok(d) = flowgraph.description().await {
        Ok(Json::from(d))
    } else {
        Err(StatusCode::BAD_REQUEST)
    }
}
```

API endpoints like these can be used easily with tools like curl or any web library.

{{ figure(images=[['curl.png', 100, 'Querying the API with Curl.', 700]]) }}

To demonstrate how this can be used, we made the control port front page a
[Mermaid](https://mermaid-js.github.io/mermaid/#/) diagram of the flowgraph.

{{ figure(images=[['fg.png', 100, 'New control port frontpage.', 700]]) }}

These concepts, in particular the Mermaid representation of the flowgraph, were
thought of and pushed forward by [Loïc Fejoz](https://twitter.com/loic_fejoz).
Thank you!
