#! /usr/bin/env ruby
require 'json'
require 'ollama'
#require 'tty-markdown'
require 'base64'

ollama = Ollama::Client.new timeout: 1800

files = Dir['*.png']
#already_done = YAML.parse_file 'done.yml'
already_done = ['img-002.png',
                "img-005.png",
                'img-008.png',
                'img-011.png']


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

