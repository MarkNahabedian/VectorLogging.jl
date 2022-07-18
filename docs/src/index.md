# VectorLogging.jl

The loggers in this package create log entries of this form:

```@doc
LogEntry
```

which is conducive to automated analysis.


## VectorLogger

`VectorLogger` creates an in-memory log which can be programaticallly
analyzed.

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

*s
### JSONLogger

`JSONLogger` allows a machine readable log to be preserved across
Julia sessions.

```docs
JSONLogger
JSONLogReader
```

