# frozen_string_literal: true

# Функция для сравнения двух pdf файлов. Файлы сравниваются побайтно. Предварительно у обоих выравнивается дата создания
# CreationDate (D:20230316132022-04'00')
# Ищем CreateionDate, а затем заполняем пробелами дату.

def pdf_equal?(pdf_body1, pdf_body2)
  pdf_body1.gsub(/CreationDate \([^)]+\)/, '') == pdf_body2.gsub(/CreationDate \([^)]+\)/, '')
end
