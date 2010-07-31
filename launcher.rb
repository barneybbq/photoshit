require "settings"
require "photo_processor"

pp = PhotoProcessor.new
pp.source = $source
pp.destination = $destination
pp.watermark_text = $watermark_text
pp.process