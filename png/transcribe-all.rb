#! /usr/bin/env ruby
# Extract text from all pngs in current directory.

require 'ollama'
require 'benchmark'

custom_prompt = ARGV.shift

files = Dir.glob('*.png')
files.each do |filename|
  if File.exist?("ocr-#{filename}.md") || File.exist?("#{filename}.md")
    $stderr.puts "Skipping #{filename}"
    next
  end

  realtime = Benchmark.realtime do
    $stderr.print("Processing #{filename}")
    Ollama::ocr(filename)
  end
  $stderr.puts " (#{realtime})s"
rescue => e
  $stderr.puts "=== Ocorreu RuntimeError ==="
  $stderr.puts e.inspect
  $stderr.puts e.backtrace.join("\n")
end
