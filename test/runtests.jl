using VectorLogging
using Logging
using Test
using InteractiveUtils: subtypes

@testset "VectorLogging.jl" begin
    logger = VectorLogger()
    with_logger(logger) do
        @info "First log message"
        @warn("Second log message, with payload", payload="foo")
    end
    @test length(logger) == 2
    # First log entry:
    @test logger[1].message == "First log message"
    @test logger[1].level == Logging.Info
    # Second log entry:
    @test logger[2].message == "Second log message, with payload"
    @test logger[2].level == Logging.Warn
    @test logger[2].keys[:payload] == "foo"
end

@testset "VectorLOgger is iterable" begin
    messages = ["foo", "bar"]
    logger = VectorLogger()
    with_logger(logger) do
        for message in messages
            @info message
        end
    end
    @test length(logger) == length(messages)
    for (log_entry, expect) in zip(logger, messages)
        @test log_entry.message == expect
    end
end


function test_log_format(format)
    @testset "Test file log format $(typeof(format))" begin
        messages = ["foo", "bar"]
        logfile = tempname()
        FileLogger(logfile, format) do logger
            with_logger(logger) do
                for message in messages
                    @info message
                end
            end
        end
        LogFileReader(logfile, format) do reader
            for (log_entry, expect) in zip(reader, messages)
                @test log_entry.message == expect
            end
        end
    end
end

let
    function test_formatters(format)
        if isabstracttype(format)
            for st in subtypes(format)
                test_formatters(st)
            end
        elseif isconcretetype(format)
            test_log_format(format())
        end
    end

    test_formatters(AbstractLogFileFormat)
end

