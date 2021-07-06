using VectorLogger
using Logging
using Test

@testset "VectorLogger.jl" begin
    logger = VectorLogger_()
    with_logger(logger) do
        @info "First log message"
        @warn("Second log message, with payload", payload="foo")
    end
    # Firsdt log entry:
    @test logger.log[1].message == "First log message"
    @test logger.log[1].level == Logging.Info
    # Second log entry:
    @test logger.log[2].message == "Second log message, with payload"
    @test logger.log[2].level == Logging.Warn
    @test logger.log[2].keys[:payload] == "foo"
end
