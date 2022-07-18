using Logging
using JSON

export JSONLogger, JSONLogReader

#=

Why is this here?

I was using VectorLogging to debug some problem, but that problem
would up crashing the Julia runtime -- making the in-memory log
unavailable.

JSONLogger is an alternative to VectorLogger that writes the log to a
file, thus outliving the Julia runtime.

=#


"""
    JSONLogger
A logger that writes log entries as JSON to a stream.
"""
struct JSONLogger <: Logging.AbstractLogger
    io::IO

    JSONLogger(io::IO) = new(io)

    function JSONLogger(file::AbstractString)
        io = open(file, "w")
        new(io)
    end
end

function JSONLogger(body, file::AbstractString)
    logger = JSONLogger(file)
    result = nothing
    try
        result = body(logger)
    finally
        close(logger)
    end
    result
end

Base.close(logger::JSONLogger) = close(logger.io)


function Logging.handle_message(logger::JSONLogger, level::LogLevel,
                                message, _module, group, id,
                                file, line; keys...)
    e = LogEntry(level, message, nameof(_module), group, id,
                 file, line, keys)
    JSON.print(logger.io, e)
    write(logger.io, "\n")
    flush(logger.io)
    return nothing
end

function Logging.shouldlog(logger::JSONLogger, level, _module, group, id)
    true
end

function Logging.min_enabled_level(logger::JSONLogger)
    Logging.LogLevel(0)
end

function Logging.catch_exceptions(logger::JSONLogger)
    false
end


"""
    JSONLogReader
Provide a simple iteration interface to a JSON log written by JSONLogger.
"""
struct JSONLogReader
    io::IO

    JSONLogReader(io::IO) = new(io)

    function JSONLogReader(file::AbstractString)
        io = open(file, "r")
        new(io)
    end
end

function Base.iterate(logger::JSONLogReader)
    try
        le_dict = JSON.parse(logger.io)
        le = LogEntry(le_dict["level"],
                      le_dict["message"],
                      le_dict["_module"],
                      le_dict["group"],
                      le_dict["id"],
                      le_dict["file"],
                      le_dict["line"],
                      le_dict["keys"])
        return le, nothing
    catch e
        msg = split(sprint(showerror, e), "\n")[1]
        if msg == JSON.Common.E_UNEXPECTED_EOF
            return nothing
        else
            rethrow()
        end
    end
end

function Base.iterate(logger::JSONLogReader, ::Nothing)
    iterate(logger)
end

