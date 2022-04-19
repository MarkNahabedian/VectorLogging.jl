# VectorLogging.jl

VectorLOgging provides an in-memory logging destination.

```@docs
LogEntry
VectorLogger
```


```@example
using Logging
using VectorLogging

logger = VectorLogger()

with_logger(logger) do
    @info "Message 1"
    @info "Message 2"
end

logger.log

```
