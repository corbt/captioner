# require 'rubygems'
# require 'bundler/setup'

require 'yaml'
require 'fileutils'
require_relative 'deep_merge'

# Borrowed from the Rails source
def word_wrap(text, line_width: 80)
  text.split("\n").collect do |line|
    line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
  end * "\n"
end

def copy_file name, index
  extension = name.split('.').last
  FileUtils.cp File.join($config['in_dir'], name),
               File.join($config['out_dir'], index.to_s + "." + extension)
end

def process_image img_data
  in_file = '"'+File.join($config['in_dir'], img_data['image'])+'"'
  out_file = '"'+File.join($config['out_dir'], "#{img_data['index']}.#{$config['format']['image']}")+'"'
  options = [in_file, out_file]

  if img_data['caption']
    caption = word_wrap img_data['caption']
    options = [
      '-size 2500x200 xc:none',
      '-gravity center',
      '-stroke black',
      '-strokewidth 10',
      '-pointsize 60',
      '-font AvenirLTStd-Medium-1',
      '-annotate', "0 \"#{caption}\"",
      '-background none',
      '-shadow 300x20+0+0',
      '+repage',
      '-stroke none',
      '-fill', 'white',
      '-annotate', "0 \"#{caption}\"",
      in_file,
      '+swap',
      '-gravity south',
      '-geometry +0-3',
      '-composite', out_file
    ]
  end

  `convert #{options.join ' '}`
end

def process_video video_data
  copy_file video_data['video'], video_data['index']
end

def process_text text_data
  text = word_wrap(text_data['text'], line_width: 40)
  out_file = File.join($config['out_dir'], "#{text_data['index']}.#{$config['format']['image']}")
  `convert -size 2560x1600 xc:white -gravity center -pointsize 120 -fill '#333333' -font AvenirLTStd-Medium-1 -annotate 0 "#{text}" #{out_file}`
end

$config = {
  'in_dir' => '_media',
  'out_dir' => '_media_out',
  'format' => {
    'image' => 'png',
    'video' => 'mp4'
  }
}

begin
  $config = $config.deep_merge(YAML.load_file ARGF.argv.first)
rescue TypeError => e
  puts "Error: invalid config file"
  raise e
end

FileUtils.rm_rf $config['out_dir']
FileUtils.mkdir_p $config['out_dir']

$config['media'].each_with_index do |media_data, i|
  puts "Writing file #{i}"
  media_data['index'] = i 
  process_image(media_data) if media_data.has_key? 'image'
  process_video(media_data) if media_data.has_key? 'video'
  process_text(media_data) if media_data.has_key? 'text'
end