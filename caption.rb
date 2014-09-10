require 'rubygems'
require 'bundler/setup'

# require your gems as usual
require 'yaml'

# Borrowed from the Rails source
def word_wrap(text, line_width: 80)
  text.split("\n").collect do |line|
    line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
  end * "\n"
end

def process_image config
  caption = word_wrap config['caption']
  options = [
    '-size 2500x200 xc:none',
    '-gravity center',
    '-stroke black',
    '-strokewidth 10',
    '-pointsize 60',
    '-font helvetica',
    '-annotate', "0 \"#{caption}\"",
    '-background none',
    '-shadow 300x10+0+0',
    '+repage',
    '-stroke none',
    '-fill', 'white',
    '-annotate', "0 \"#{caption}\"",
    "\"#{File.join("images", config['image'])}\"",
    '+swap',
    '-gravity south',
    '-geometry +0-3',
    '-composite', File.join('out', "#{config['index']}.png")
  ].join ' '

  `convert #{options}`
end

config = YAML.load_file 'config.yml'
FileUtils.rm_r 'out'
FileUtils.mkdir_p 'out'

config['media'].each_with_index do |config, i|
  config['index'] = i 
  process_image(config) if config.has_key? 'image'
end