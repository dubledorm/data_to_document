# README

## Установка wkhtmltopdf
Важно: Должна быть установлена версия не ниже 0.12.6
Проверить версию можно командой:

```sh
$ wkhtmltopdf -V
wkhtmltopdf 0.12.6 (with patched qt)
```
Для начала можно попробовать посмотреть версии этого пакета в apt
```sh
ubuntu@ubuntu2004:~/WickedPdf$ apt-cache madison wkhtmltopdf
wkhtmltopdf | 0.12.5-1build1 | http://us.archive.ubuntu.com/ubuntu focal/universe amd64 Packages
```
На момент установки её там не было.
Поэтому, смотрим на официальном сайте для скачивания: https://wkhtmltopdf.org/downloads.html нужный нам пакет.
Ниже приводится порядок на примере Ubuntu 20.04

### Порядок установки на чистую систему (Ubuntu 20.04)
* Скачиваем пакет 
```sh
ubuntu@ubuntu2004:~/WickedPdf$ wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
```
* В процессе установки выяснилось, что ему требуется библиотека  xfonts-75dpi.
Поэтому, перед дальнейшими действиями устанавливаем её:
```sh
ubuntu@ubuntu2004:~/WickedPdf$ sudo apt install xfonts-75dpi
```
* Теперь разворачиваем и устанавливаем пакет
```shell
sudo dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -f
```

Всё, можно проверить версию, должно быть вот так:
```shell
ubuntu@ubuntu2004:~/WickedPdf$ wkhtmltopdf -V
wkhtmltopdf 0.12.6 (with patched qt)
```

## Использование
### Добавление Header и Footer
Для добавления используются параметры header_html и footer_html. В них передаётся html код.
При этом важно наличие в начале кода тега <!DOCTYPE html>.
Если его не будет, то весь html будет пропущен. Ошибки не будет выдаваться.

Пример правильного использования:
```shell
"header_html": "<!DOCTYPE html><html><head></head><body>This is header</body></html>",
"footer_html": "<!DOCTYPE html><html><head></head><body>This is footer</body></html>",
```