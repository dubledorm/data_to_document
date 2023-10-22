# frozen_string_literal: true

require 'zip'
require 'stringio'
require 'tmpdir'

module ReportGenerators

  # Генератор для docx
  class DocxGenerator < Base
    DOCUMENT_FILE_PATH = 'word/document.xml'

    def replace_tags_in_template(template)
      zip_stream = Zip::InputStream.new(StringIO.new(template))
      Zip::OutputStream.write_buffer do |out|
        while entry = zip_stream.get_next_entry
          out.put_next_entry(entry.name)
          if [DOCUMENT_FILE_PATH].include?(entry.name)
            out.write replace_tags(entry.get_input_stream)
          else
            out.write entry.get_input_stream.read
          end
        end
      end.string
    end

    def generate_report(generated_report)
      generated_report
    end

    # Найти все тэги в документе и вернуть их в виде массива tag_and_arguments_hash
    def tag_list
      result = []
      zip_stream = Zip::InputStream.new(StringIO.new(template_source))
      while entry = zip_stream.get_next_entry
        result += parse_tags(entry.get_input_stream) if [DOCUMENT_FILE_PATH].include?(entry.name)
      end

      result
    end

    def replace_tags_in_document(xml_document)
      xml_document.xpath('descendant::w:p').each do |node|
        process_text_node(node)
      end
    end

    private

    def parse_tags(input_stream)
      result = []
      xml_doc = Nokogiri::XML(input_stream)
      xml_doc.xpath('//w:p').each do |node|
        node.text.scan(REG_EXP_FIND_TAGS) do |tag_string|
          tag_and_arguments_hash = TagParseService.parse!(clear_tag_string(tag_string))
          result << tag_and_arguments_hash
        end
      end
      result
    end

    # Заменить все теги в документе
    def replace_tags(input_stream)
      xml_doc = Nokogiri::XML(input_stream)
      xml_doc.xpath('//w:p').each do |node|
        process_text_node(node)
      end
      xml_doc.to_s.gsub("\n", '') # Отдаём изменённый документ
    end

    def process_text_node(node)
      m = REG_EXP_FIND_TAGS.match(node.text) # Находим все теги в параграфе
      return if m.nil?

      (0..m.size - 1).each do |index| # Обрабатываем их по очереди
        r_nodes = node.xpath('w:r') # Внутри параграфа ищем по тегам w:r. Внутри них находятся ещё w:t.
        # А также на одном с ними уровне есть другие теги.
        # Строка, которую мы ищем, она размазана по нескольким тегам, по частям.
        # Принцип поиска: По количеству символов найденной строки ищем первый и последний w:r теги
        start_node_index = find_node_by_offset(r_nodes, m.begin(index))
        end_node_index = find_node_by_offset(r_nodes, m.end(index) - 1)

        tag_handler(m.to_a[index], start_node_index, end_node_index, r_nodes)
      end

      # loop do
      #   m = REG_EXP_FIND_TAGS.match(remaining_str)
      #   break if m.nil?
      #   node.xpath('//w:t[text()="#["]')
      #   first_node = node.xpath('//w:t[text()="#["]')
      #   byebug
      #   result += remaining_str[0..m.begin(0) - 1] if m.begin(0).positive? # Копируем до начала тега
      #   remaining_str = replace_from_begin(result, remaining_str[m.begin(0)..], m[0])
      # end
      # node.content = result + remaining_str
    end

    def find_node_by_offset(r_nodes, offset)
      return 0 if offset.zero?

      current_offset = 0
      r_nodes.each_with_index do |node, index|
        current_offset += node.text.length

        return index if current_offset >= offset + 1
      end

      raise StandardError, "Не могу найти node для смещения #{offset}"
    end

    def tag_handler(tag_string, start_node_index, end_node_index, r_nodes)
      tag_and_arguments_hash = TagParseService.parse!(clear_tag_string(tag_string))
      docx_content = { start_node_index: start_node_index,
                       end_node_index: end_node_index,
                       r_nodes: r_nodes }
      replace_function = build_function_instance(tag_and_arguments_hash, docx_content)
      replace_function.done!
    end

    # На основании tag_string найти функцию подстановки
    # Изменить и вернуть source_string
    # def replace_from_begin(prev_string, source_string, tag_string)
    #   tag_and_arguments_hash = TagParseService.parse!(clear_tag_string(tag_string))
    #   html_content = { old_string: tag_string,
    #                    output: source_string,
    #                    prev_string: prev_string }
    #   replace_function = build_function_instance(tag_and_arguments_hash, html_content)
    #   replace_function.done!
    # end
    #
    def clear_tag_string(tag_string)
      tag_string[2..-2]
    end

    # def unpack_word_file(target_dir_name, word_file_string)
    #   zip_stream = Zip::InputStream.new(StringIO.new(word_file_string))
    #   while entry = zip_stream.get_next_entry
    #     directory_name = ::File.join(target_dir_name, File.dirname(entry.name))
    #     FileUtils.mkdir_p(directory_name) unless Dir.exist?(directory_name)
    #     entry.extract(::File.join(directory_name, File.basename(entry.name)))
    #   end
    # end
    #
    # def pack_word_file(source_dir_name)
    #   byebug
    #   tmpname = ::Dir::Tmpname.create(%w[result .docx])
    #   PackDirectoryService.new(source_dir_name, tmpname).pack
    #   byebug
    # end
  end
end

