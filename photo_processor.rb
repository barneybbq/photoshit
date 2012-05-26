require File.expand_path(File.dirname(__FILE__) + '/photo_file')

class PhotoProcessor
  attr_accessor :source
  attr_accessor :destination
  attr_accessor :watermark_text

  def process
    source_dir = Dir.new(@source)
    source_dir.each do |filename|
      if ".jpg" == File.extname(filename)
        pf = PhotoFile.new("#{@source}/#{filename}", @destination, @watermark_text)
        pf.resize
        pf.put_watermark
        pf.save_copy
      end
    end
  end
end