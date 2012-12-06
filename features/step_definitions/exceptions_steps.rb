require 'aruba/api'

Then /^the aeolus command should write the stack trace to file$/ do
  /For further debugging information, see (\/tmp\/aeolus-cli-trace-\d+.log)/ =~
    all_output
  trace_filename = Regexp.last_match(1)

  # The last line in the stack trace file will look something like
  # ....../thor-cli/bin/aeolus:6:in `<main>'
  check_file_content(trace_filename, /bin\/aeolus:\d+:in `<main>/, true)
end
