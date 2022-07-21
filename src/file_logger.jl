# Write log messages to a file using various log record
# representations.

using JSON
using Serialization

export FileLogger, LogFileReader

export AbstractLogFileFormat, JSONLogFileFormat, SerializationLogFileFormat


"""
    AbstractLogFileFormat
The supertype of all supported log file formats.
"""
abstract type AbstractLogFileFormat end

"""
    FileLogger
A logger that writes log entries to a file or stream in the specified `format`.
"""
struct FileLogger <: Logging.AbstractLogger
    io::IO
    format::AbstractLogFileFormat
end

function FileLogger(filepath::AbstractString, format)
    io = open(filepath, "w")
    FileLogger(io, format)
end

Base.close(logger::FileLogger) = close(logger.io)

function FileLogger(body, filepath::AbstractString, format)
    logger = FileLogger(filepath, format)
    result = nothing
    try
        result = body(logger)
    finally
        close(logger)
    end
    result
end

function Logging.handle_message(logger::FileLogger,
                                level::LogLevel,
                                message, _module, group, id,
                                file, line; keys...)
    e = LogEntry(level, message, nameof(_module), group, id,
                 file, line, keys)
    write_log_entry(logger.format, logger.io, e)
    flush(logger.io)
    return nothing
end

function Logging.shouldlog(logger::FileLogger, level, _module, group, id)
    true
end

function Logging.min_enabled_level(logger::FileLogger)
    Logging.LogLevel(0)
end

function Logging.catch_exceptions(logger::FileLogger)
    false
end


"""
    LogFileReader
Provide an iteration interface to a log file written by `FileLogger`.
"""
struct LogFileReader
    io::IO
    format::AbstractLogFileFormat
end
    
function LogFileReader(filepath::AbstractString, format::AbstractLogFileFormat)
    io = open(filepath, "r")
    LogFileReader(io, format)
end

Base.close(logger::LogFileReader) = close(logger.io)

function LogFileReader(body, filepath::AbstractString, format::AbstractLogFileFormat)
    logger = LogFileReader(filepath, format)
    result = nothing
    try
        result = body(logger)
    finally
        close(logger)
    end
    result
end

function Base.iterate(logger::LogFileReader)
    try
        le = read_log_entry(logger.format, logger.io)
        return le, nothing   # iteration state is held in logger.io.
    catch e
        if isEOF(logger.format, e)
            return nothing
        else
            rethrow()
        end
    end
end

function Base.iterate(logger::LogFileReader, ::Nothing)
    iterate(logger)
end

Base.IteratorSize(::Type{LogFileReader}) = Base.SizeUnknown()

Base.IteratorEltype(::Type{LogFileReader}) = Base.HasEltype()

Base.eltype(::Type{LogFileReader}) = LogEntry


# Formats

"""
    JSONLogFileFormat
A log file format that uses JSON file format.
"""
struct JSONLogFileFormat <: AbstractLogFileFormat end

function write_log_entry(::JSONLogFileFormat, io::IO, e::LogEntry)
    JSON.print(io, e)
    write(io, "\n")
    nothing
end

function isEOF(::JSONLogFileFormat, err::Exception)
    if err isa EOFError
        return true
    end
    msg = split(sprint(showerror, err), "\n")[1]
    msg == JSON.Common.E_UNEXPECTED_EOF
end

function read_log_entry(::JSONLogFileFormat, io::IO)::LogEntry
    le_dict = JSON.parse(io)
    LogEntry(le_dict["level"],
             le_dict["message"],
             le_dict["_module"],
             le_dict["group"],
             le_dict["id"],
             le_dict["file"],
             le_dict["line"],
             le_dict["keys"])
end


"""
    SerializationLogFileFormat
A log file format that uses Julia's Serialization mechanism.

Note that this format is very dependent on what version of Julia is
being used.
"""
struct SerializationLogFileFormat <: AbstractLogFileFormat end

function write_log_entry(::SerializationLogFileFormat, io::IO, e::LogEntry)
    serialize(io, e)
end

function isEOF(::SerializationLogFileFormat, err::Exception)
    err isa EOFError
end

function read_log_entry(::SerializationLogFileFormat, io::IO) # ::LogEntry
    deserialize(io)
end

