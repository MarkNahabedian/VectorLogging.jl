using Logging

export LogEntry, VectorLogger_

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

@Base.kwdef mutable struct VectorLogger_ <: Logging.AbstractLogger
    log::Vector{LogEntry} = Vector{LogEntry}()
end

function Logging.handle_message(logger::VectorLogger_, level::LogLevel,
                                message, _module, group, id,
                                file, line; keys...)
    push!(logger.log,
          LogEntry(level, message, _module, group, id,
                   file, line, keys))
    return nothing
end

function Logging.shouldlog(logger, level, _module, group, id)
    true
end

function Logging.min_enabled_level(logger::VectorLogger_)
    Logging.LogLevel(0)
end

function Logging.catch_exceptions(logger::VectorLogger_)
    false
end

