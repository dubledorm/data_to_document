# frozen_string_literal: true

module HtmlToPdf
  # Декоратор
  class PdfFromStringParamsDecorator < Draper::Decorator
    delegate_all

    def as_json(options = nil)
      result = super
      result['header'] = { 'content' => add_script_to_html(result['header_html']) } if result.key?('header_html')
      result['footer'] = { 'content' => add_script_to_html(result['footer_html']) } if result.key?('footer_html')
      result
    end

    SCRIPT = '<script>
    function subst() {
        var vars = {};
        var query_strings_from_url = document.location.search.substring(1).split(\'&\');
        for (var query_string in query_strings_from_url) {
            if (query_strings_from_url.hasOwnProperty(query_string)) {
                var temp_var = query_strings_from_url[query_string].split(\'=\', 2);
                vars[temp_var[0]] = decodeURI(temp_var[1]);
            }
        }
        var css_selector_classes = [\'page\', \'frompage\', \'topage\', \'webpage\', \'section\', \'subsection\', \'date\', \'isodate\', \'time\', \'title\', \'doctitle\', \'sitepage\', \'sitepages\'];
        for (var css_class in css_selector_classes) {
            if (css_selector_classes.hasOwnProperty(css_class)) {
                var element = document.getElementsByClassName(css_selector_classes[css_class]);
                for (var j = 0; j < element.length; ++j) {
                    element[j].textContent = vars[css_selector_classes[css_class]];
                }
            }
        }
    }
</script>'

    CALL_THE_SCRIPT = ' onload="subst()"'

    protected

    def add_script_to_html(source_html)
      add_script_call(add_script(source_html))
    end

    private

    def add_script(source_html)
      finish = false
      # Ищем сначала секцию <head>
      result = source_html.sub(/(?i)<head>/) do |head_tag|
        finish = true
        "#{head_tag}#{SCRIPT}"
      end

      return result if finish

      # <head> не нашли, вставляем сразу после html
      source_html.sub(/(?i)<html>/) do |html_tag|
        "#{html_tag}<head>#{SCRIPT}</head>"
      end
    end

    def add_script_call(source_html)
      finish = false
      # Ищем сначала секцию <body>
      result = source_html.sub(/(?i)<body/) do |body_tag|
        finish = true
        "#{body_tag}#{CALL_THE_SCRIPT}"
      end

      return result if finish

      # Не нашли
      # Сначала ставим закрывающую </body>
      result = source_html.sub(/(?i)<\/html>/) do |html_tag|
        "</body>#{html_tag}"
      end

      # Проверяем есть ли </head>
      result = result.sub(/(?i)<\/head>/) do |head_tag|
        finish = true
        "#{head_tag}<body#{CALL_THE_SCRIPT}>"
      end

      return result if finish

      # </head> не нашли, значит вставляем body после <html>
      result.sub(/(?i)<html>/) do |html_tag|
        "#{html_tag}<body#{CALL_THE_SCRIPT}>"
      end
    end
  end
end
