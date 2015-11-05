# Assuming we'd called this program from the command-line like this:
# $ ruby example.rb "some word from the command-line"
# SOME WORD FROM THE COMMAND-LINE
#
# Definitions:
#   Callstack:
#     The place that called (aka invoked) the current code,
#     we will return there when it we finish executing the current code.
#
#   Dependency:
#     Anything my code uses, or that is used by my code.
#     In other words, anything that affects my code.
#     This term is usually reserved for things that are painful when they affect your code,
#     like database connections, internet connections, global state, file systems,
#     side effects, randomness, singleton objects, original context, etc.


# =====  Version 1  =====
# Here, the dependencies are:
#   ARGV    - argument passed to the program
#   $stdout - global variable to the output stream

def my_upcase
  upcased_arg = ARGV[0].gsub(/[a-z]/) { |char| (char.ord - 0x20).chr }
  $stdout.puts(upcased_arg)
end

my_upcase



# =====  Version 2  =====
# Here, all the dependencies and context have been pushed higher in the callstack
#
# So this program does the same thing,
# but the my_upcase method can be invoked with any string from any source
# and we can do anything we want with the result,
# not just print it to one specific output stream

def my_upcase(string)
  string.gsub(/[a-z]/) { |char| (char.ord - 0x20).chr }
end

upcased_arg = my_upcase(ARGV[0])
$stdout.puts(upcased_arg)
