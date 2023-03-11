# frozen_string_literal: true

CDN_REPORT_DESCRIPTION = '## Общее описание
Метод формирует отчёт на основе шаблона в БД, имя которого передаётся в параметре строки запроса,
и списка подстановки, который передаётся как template_params в теле запроса.
### Теги или функции подстановки
Для того, чтобы в отчёт можно было передавать данные, в тело шаблона вставляются специальные последовательности,
называемые тегами или функциями подстановки.
Вид такой последовательности следующий:
```
#[ИмяТега(необязательные параметры)]
```
Если параметры для тега не требуются, то круглые скобки могут быть опущены.
Например, все следующие последовательности корректны:

```
#[Title]
#[Title()]
#[SomeBarcode(asBarcode: true)]
```
### Список подстановки
Представляет собой список ключ-значение, содержащий в качестве ключей имена тегов(функция подстановки), а в качестве значений
собственно значение, которым будет заменяться ключ.
Важно, что значение может быть не только строкой. Его тип зависит от параметров функции подстановки.

### Существующие параметры функций подстановки
#### Баркод как картинка
Пример: ```#[SomeBarcode(asBarcode: true)]```
В списке подстановки должен быть передан "SomeBarcode": "1234567890". Этот код будет преобразован в картинку и вставлен в отчёт
#### Таблица
Пример:
```
#[SomeName(asTable: true)]
#[SomeName(asTable: true, addRows: true)]
#[SomeName(asTable: true, addRows: false)]
```

В списке подстановки должен быть передан
```
"SomeName": [["Строка 1, колонка 1", "Строка 1, колонка 2", "Строка 1, колонка 3"], ["Строка 2, колонка 1", "Строка 2, колонка 2", "Строка 2, колонка 3"]].
```

Т.е. массив строк.
Сама функция подстановки должна располагаться в верхнем левом углу таблицы(на первой строке с данными, не в заголовке).
Заполнение начнётся непосредственно с клетки, где расположена функция подстановки и пойдёт с лева на право и с верху вниз.
При этом, ориентироваться алгоритм будет на переданный массив, а не на шаблон.
Существует дополнительный параметр функции подстановки - addRows
Если он установлен в true (значение по умолчанию), то заполнив первую строку алгоритм будет добавлять такую же строчку для
каждой следующей строки отчёта. Т.е. таблица расширяемая.
Если установлен в false, то предполагается, что все строки уже есть в шаблоне и алгоритм будет искать их там. Т.е. таблица не расширяемая.

#### Таблица с шаблоном
Сделан на основании вышеописанной Таблицы и повторяет его по поведению.
Пример:
```
#[SomeName(asTableWithTemplate: true, Template: template_name)]
#[SomeName(asTableWithTemplate: true, Template: template_name, addRows: true)]
#[SomeName(asTableWithTemplate: true, Template: template_name, addRows: false)]
```
Паратметр Template в данном случае обязателен. Он содержит имя ещё одного шаблона, который должен находиться в базе данных.
Этот шаблон будет подставлять в каждую клетку таблицы. При этом, подставляемый шаблон может также иметь теги подстановки, которые
будут заполнены на основании данных из списка подстановки.

В списке подстановки должен быть передан
```
"SomeName": [[{row: 1, col: 1}, {row: 1, col: 2}, {row: 1, col: 3}],
             [{row: 2, col: 1}, {row: 2, col: 2}, {row: 2, col: 2}]].
```
т.е. передаётся массив строк, каждая строка представляет собой массив структур, описывающих параметры подстановки в клетке.
В данном случае предполагается, что в шаблоне, указанном в параметре Template, есть два параметра row и col. Для каждой клетки
значения будут браться из соответствующей позиции в массиве строки
'

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

def examples_body_report
  request_body_example value: {
    template_params: {
      Full_Company_name: 'Общество с ограниченной ответственностью "СИНЕРГИЯ"',
      FIOWriteContract: 'Киселева Виктория Олеговна',
      FIOWritePost: 'Директор',
      BasicWriteContract: 'Устава'
    }
  }, name: 'request_example_1', summary: 'Простой пример'
  request_body_example value: {
    template_params: {
      title: 'Какой-то заголовок',
      table_body: [['Строка 1, колонка 1', 'Строка 1, колонка 2', 'Строка 1, колонка 3'], ['Строка 2, колонка 1', 'Строка 2, колонка 2', 'Строка 2, колонка 3']]
    }
  }, name: 'request_example_2', summary: 'Пример с использованием таблицы'
  request_body_example value: {
    template_params: {
      "LoginLk": "info@l",
      "PasswordLk": "linife2016",
      "NumberContract": "9990342022",
      "ContractDate": "16.05.2022",
      "Full_Company_name": "Общество с ограниченной ответственностью \"СИНЕРГИЯ\"",
      "FIOWriteContract": "Киселева Виктория Олеговна",
      "FIOWritePost": "Директор",
      "BasicWriteContract": "Устава",
      "RetCargoPostCode": "156016",
      "RetCargoCity": "Кострома",
      "RetCargoAddress": "Давыдовский 3-й микрорайон, 32",
      "jrPostCode": "156005",
      "jrCityName": "Кострома",
      "jrAddress": "пл. Октябрьская, Дом 3",
      "Phone_Number": "79203833451",
      "INN": '4401147784/440101001',
      "CalcAccount": "40702810547100032115",
      "BankName": "ПАО АКБ \"АВАНГАРД\"",
      "CorAccount": "30101810000000000201",
      "BIK": "044525201",
      "OGRN": "1134401014813",
      "phpickpointname": "ПикПоинт",
      "phpostcode": "123456",
      "phcityname": "Москва",
      "phaddress": "Наш адрес",
      "phpickpointjuridicaladdress": "Наш юр адрес",
      "phpickpointphisicaladdress": "Наш физ адрес",
      "phpickpointphone": "1234556678",
      "phpickpointpaymentaccount": "Сюда платить",
      "phpickpointbankname": "Наш банк",
      "phpickpointcorrespondentaccount": "кор счёт",
      "phpickpointbic": "БИК",
      "phpickpointinnkpp": "ИНН",
      "phpickpointogrn": "ОГРН",
      "phpickpointshortname": "Пик",
      "phpickpointdecreenumber": "phpickpointdecreenumber",
      "phpickpointdecreedate": "phpickpointdecreedate"
    }
  }, name: 'request_example_3', summary: 'Пример для шаблона Offer'
  request_body_example value: {
    template_params: {
      "invoices": [[
                     {"PTNumber1": "770", "PTNumber2": "2-099", "ClientName": "PickPoint", "InvoiceNumber": "15971518657", "InternalNumber": "", "FIO": "Вася Пупкин", "BarcodeNumber": "202799131044"},
                     {"PTNumber1": "771", "PTNumber2": "2-099", "ClientName": "PickPoint1", "InvoiceNumber": "15971518658", "InternalNumber": "", "FIO": "Вася Пупкин1", "BarcodeNumber": "202799131045"}],
                   [
                     {"PTNumber1": "772", "PTNumber2": "2-099", "ClientName": "PickPoint", "InvoiceNumber": "15971518659", "InternalNumber": "", "FIO": "Вася Пупкин", "BarcodeNumber": "202799131046"},
                     {"PTNumber1": "773", "PTNumber2": "2-099", "ClientName": "PickPoint1", "InvoiceNumber": "15971518650", "InternalNumber": "", "FIO": "Вася Пупкин1", "BarcodeNumber": "202799131047"}]
      ]
    }
  }, name: 'request_example_4', summary: 'TableWithTemplate. (Этикетки)'
end


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
