var documenterSearchIndex = {"docs":
[{"location":"#VectorLogging.jl","page":"Home","title":"VectorLogging.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The loggers in this package create log entries of this form:","category":"page"},{"location":"","page":"Home","title":"Home","text":"LogEntry","category":"page"},{"location":"","page":"Home","title":"Home","text":"which is conducive to automated analysis.","category":"page"},{"location":"#VectorLogger","page":"Home","title":"VectorLogger","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"VectorLogger creates an in-memory log which can be programaticallly analyzed.","category":"page"},{"location":"","page":"Home","title":"Home","text":"LogEntry\nVectorLogger","category":"page"},{"location":"#VectorLogging.LogEntry","page":"Home","title":"VectorLogging.LogEntry","text":"LogEntry\n\nLogEntry encapsulates the data for a single log message to VectorLogger.\n\n\n\n\n\n","category":"type"},{"location":"#VectorLogging.VectorLogger","page":"Home","title":"VectorLogging.VectorLogger","text":"VectorLogger\n\nVectorLogger is an in-memory log destination. The logger's log slot is a Vector of LogEntrys.\n\n\n\n\n\n","category":"type"},{"location":"","page":"Home","title":"Home","text":"using Logging\nusing VectorLogging\n\nlogger = VectorLogger()\n\nwith_logger(logger) do\n    @info \"Message 1\"\n    @info \"Message 2\"\nend\n\nlogger.log\n","category":"page"},{"location":"","page":"Home","title":"Home","text":"*s","category":"page"},{"location":"#JSONLogger","page":"Home","title":"JSONLogger","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"JSONLogger allows a machine readable log to be preserved across Julia sessions.","category":"page"},{"location":"","page":"Home","title":"Home","text":"JSONLogger\nJSONLogReader","category":"page"},{"location":"#VectorLogging.JSONLogger","page":"Home","title":"VectorLogging.JSONLogger","text":"JSONLogger\n\nA logger that writes log entries as JSON to a stream.\n\n\n\n\n\n","category":"type"},{"location":"#VectorLogging.JSONLogReader","page":"Home","title":"VectorLogging.JSONLogReader","text":"JSONLogReader\n\nProvide a simple iteration interface to a JSON log written by JSONLogger.\n\n\n\n\n\n","category":"type"}]
}
