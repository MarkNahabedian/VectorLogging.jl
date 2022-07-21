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


## FileLogger and LogFileReader

Sometimes one needs a machine readable log that outlives a Julia
session.

```@docs
FileLogger
LogFileReader
AbstractLogFileFormat
```

```@example
using Logging
using VectorLogging

FileLogger("foo.log", JSONLogFileFormat()) do logger
    with_logger(logger) do
        @info "Message 1"
        @info "Message 2"
    end
end

LogFileReader(("foo.log", JSONLogFileFormat()) do reader
    collect(reader)
end
```
