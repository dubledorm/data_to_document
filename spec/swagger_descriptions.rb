# frozen_string_literal: true

HTML_TO_PDF_DESCRIPTION = '## Общее описание
В теле запроса передаётся объект options, содержащий исходные данные и настроечные параметры
для формирования pdf документа. Описание параметров приведено в схеме запроса.
### Особенности заполнения полей header_html и footer_html:
* В полях передаётся Html документ который будет использоваться для заголовка или подвала каждой страницы
* Пример заполнения

```<!DOCTYPE html><html>This is header</html>```
* Обязателен тег !DOCTYPE html в начале строки

### Использование переменных в header_html и footer_html
Для того,чтобы была возможность выводить номера страниц в header и footer предусмотрена возможность включать специальные переменные в html код. Список возможных имён переменных:
>page, frompage, topage, webpage, section, subsection, date, isodate, time, title, doctitle, sitepage, sitepages

Для использования переменных, необходимо передать их в качестве имени класса любого элемента. Тогда этот элемент будет заменён на значение переменной.

Например:

```<!DOCTYPE html><html>Page <span class="page"></span> of <span class="topage"></span></html>```

Передача такого документа в качестве footer даст результат:
>Page 2 of 10
## Использование кириллицы
Предполагается, что все HTML передаются в кодировке UTF-8.

Также, если требуется другая, то это можно указать в секции head. Например:

```<head><meta charset="windows-1251 /></head>```

Но для header и footer кодировку нужно указывать всегда, непосредственно в передаваемом заголовке HTML
'

MANY_HTML_TO_PDF_DESCRIPTION = '## Общее описание
В теле запроса передаётся массив объектов options, аналогичных тем, что передаются в меиоде html_to_pdf.

Для каждого из таких options формируется pdf документ. После создания, pdf документ приклеивается к предыдущему.'

BARCODE_TO_IMAGE_DESCRIPTION_API = '
## Общее описание
Метод, для преобразования переданного штрих кода в картинку.

Уммеет возвращать svg и png. Основной рабочий вариант svg.
### Ограничения
Метод рассчитан на использование кода Interleave 2 of 5. Поэтому на вход принимаем только цифры и их должно быть \
чётное количество.
'

BARCODE_TO_IMAGE_DESCRIPTION_CDN = '
## Общее описание
Метод, для преобразования переданного штрих кода в картинку.

Возвращает сформированный файл в формате png. Полученное изображение можно непосредственно включать в тег <img> \
html документа, где в качестве src указывается ссылка на данный метод.

Например:

```<img src="http:server_name:port/cdn/barcodes/1234567890">```
### Ограничения
Метод рассчитан на использование кода Interleave 2 of 5. Поэтому на вход принимаем только цифры и их должно быть \
чётное количество.'

def examples_body_html_to_pdf
  request_body_example value: {
    "options": {
      "html_text": "<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>",
      "header_html": "<!DOCTYPE html><html><head></head><body>This is header</body></html>",
      "footer_html": "<!DOCTYPE html><html><head></head><body>This is footer</body></html>",
      "orientation": "Landscape",
      "page_size": "Letter",
      "margin": { "top": 50 }
    }
  }, name: 'request_example_1', summary: 'Простой пример'
  request_body_example value: {
    "options": {
      "html_text": "<!DOCTYPE html><html><head></head><body>Hellow world!</body></html>",
      "header_html": "<!DOCTYPE html><html><head></head><body>Date <span class=\"date\"></span> Time <span class=\"time\"></span> Sitepage <span class=\"sitepage\"></span></body></html>",
      "footer_html": "<!DOCTYPE html><html><head></head><body>Page <span class=\"page\"></span> of <span class=\"topage\"></span> Webpage <span class=\"webpage\"></span></body></html>"
    }
  }, name: 'request_example_2', summary: 'Переменные в header и footer'
  request_body_example value: {
    "options": {
      "html_text": "<!DOCTYPE html><html><head></head><body> Русский текст!</body></html>",
      "header_html": "<!DOCTYPE html><html><head></head><body>Это русский заголовок - Because charset dose not exist</body></html>",
      "footer_html": "<!DOCTYPE html><html><head><meta charset=\"UTF-8\" /></head><body>Это русский подвал</body></html>"
    }
  }, name: 'request_example_3', summary: 'Кириллица во всех местах'
end