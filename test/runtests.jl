using VectorLogging
using Logging
using Test

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

@testset "JSONLogger" begin
    messages = ["foo", "bar"]
    log = tempname()
    JSONLogger(log) do logger
        with_logger(logger) do
            for message in messages
                @info message
            end
        end
    end
    for (log_entry, expect) in zip(JSONLogReader(log), messages)
        @test log_entry.message == expect
    end
end

