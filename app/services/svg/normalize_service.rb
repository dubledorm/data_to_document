# frozen_string_literal: true

module Svg
  # Приводит Svg к виду, когда её можно масштабировать
  class NormalizeService

    FIND_WIDTH_HEIGHT_REGEXP = /<svg(?<prefix>[^>]*)width="(?<width>\d+)"\s*height="(?<height>\d+)"/
    VIEW_BOX_REGEXP = /viewBox="\d+ \d+ \d+ \d+"/
    def self.call(svg_string, width, height)
      m = FIND_WIDTH_HEIGHT_REGEXP.match(svg_string)
      return svg_string unless m

      # Получаем префикс
      prefix = m[:prefix]
      svg_width = m[:width]
      svg_height = m[:height]

      # Проверяем, что есть viewBox и удаляем его
      result = svg_string.gsub(VIEW_BOX_REGEXP, '')

      # Заменяем ширину и высоту на 100% и пишем новый viewBox
      result.gsub(FIND_WIDTH_HEIGHT_REGEXP, "<svg#{prefix}width=\"#{width}px\" height=\"#{height}px\" viewBox=\"0 0 #{svg_width} #{svg_height}\"")
    end
  end
end
