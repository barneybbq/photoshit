require 'rubygems'
require 'RMagick'
#include Magick

class PhotoFile

  def initialize (file_name, destination = "", watermark_text = "test", width = 1200, height = 800)
    @watermark_text = watermark_text
    @width_horizontal = width
    @width_vertical = height
    @file_name = file_name
    @dir = Dir.pwd
    @finish_pattern = "#{destination}/_#{File.basename(@file_name)}"
    self.set_image_data
    self.set_desired_dimmensions
  end

  def horizontal?
    return @horizontal
  end

  def resize
    @file.resize!(@desired_width,@desired_height) if self.resizable?
  end

  def resizable?
    return true if (@desired_width < @width) && (@desired_height < @height)
    return false
  end

  def save_copy
    @file.write(@finish_pattern)
  end

  def put_watermark
    self.put_watermark_background
    self.put_text_watermark
  end

  protected
  def set_image_data
    files = Magick::ImageList.new(@file_name)
    @file = files.first
    @width = @file.columns
    @height = @file.rows
    if (@width > @height)
      @horizontal = true
    else
      @horizontal = false
    end
  end
  
  def set_desired_dimmensions
    if @horizontal
      @desired_height = @width_horizontal * @height / @width
      @desired_width = @width_horizontal
    else
      @desired_height = @width_vertical * @height / @width
      @desired_width = @width_vertical
    end
  end

  def put_watermark_background
    pointsize = 11
    background_length = @watermark_text.size*pointsize*0.96
    
    background = Magick::Draw.new
    background.fill("black")
    background.fill_opacity(0.6)
    background.rectangle(@desired_width-background_length, @desired_height-30, @desired_width, @desired_height)
    background.draw(@file)
  end
  def put_text_watermark
    watermark = Magick::Draw.new
    watermark.annotate(@file, 0,0,5,2, @watermark_text) {
        self.font_family = 'Tahoma'
        self.fill = '#efefef'
        self.stroke = 'transparent'
        #self.stroke = 'black'
        self.text_antialias = true
        self.pointsize = 20
        self.font_style = Magick::NormalStyle
        #self.font_weight = Magick::BoldWeight
        self.font_weight = Magick::NormalWeight
        self.gravity = Magick::SouthEastGravity
        self.interword_spacing = 3
        self.kerning = 1.5
    }
  end
end
