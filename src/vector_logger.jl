using Logging

export LogEntry, VectorLogger

"""
    LogEntry
LogEntry encapsulates the data for a single log message to VectorLogger.
"""
struct LogEntry
    level
    message
    _module
    group
    id
    file
    line
    keys
end

"""
    VectorLogger
VectorLogger is an in-memory log destination.
The logger's `log` slot is a `Vector` of `LogEntry`s.
"""
@Base.kwdef mutable struct VectorLogger <: Logging.AbstractLogger
    log::Vector{LogEntry} = Vector{LogEntry}()
end

function Logging.handle_message(logger::VectorLogger, level::LogLevel,
                                message, _module, group, id,
                                file, line; keys...)
    push!(logger.log,
          LogEntry(level, message, nameof(_module), group, id,
                   file, line, keys))
    return nothing
end

function Logging.shouldlog(logger::VectorLogger, level, _module, group, id)
    true
end

function Logging.min_enabled_level(logger::VectorLogger)
    Logging.LogLevel(0)
end

function Logging.catch_exceptions(logger::VectorLogger)
    false
end

# Implement the Indexing interface by delegating to the underlying
# Vector:

Base.length(log::VectorLogger) = length(log.log)

Base.getindex(log::VectorLogger, index) = getindex(log.log, index)

Base.firstindex(log::VectorLogger, index) = firstindex(log.log)

Base.lastindex(log::VectorLogger, index) = lastindex(log.log)

Base.iterate(logger::VectorLogger) = Base.iterate(logger.log)
Base.iterate(logger::VectorLogger, state) = Base.iterate(logger.log, state)

