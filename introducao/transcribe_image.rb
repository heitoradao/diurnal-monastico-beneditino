#! /usr/bin/env ruby
require 'json'
require 'ollama'
#require 'tty-markdown'
require 'base64'

ollama = Ollama::Client.new timeout: 1800

files = Dir['*.png']
already_done = Dir['*.md'].map {|f| f[0..-4]}

files_to_process = files - already_done
files_to_process.each do |f|
  puts f
  image = File.binread f
  b64 = Base64.strict_encode64 image
  resp = ollama.completion.generate( model: 'gemma3',
                                    prompt: "transcribe this image: ",
                                    images: [b64]                    )
  content = resp.result['response']
  File.write("#{f}.md", content)
end

