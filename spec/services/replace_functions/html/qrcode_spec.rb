# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Html::QrCode do
  let(:html_template) { '{{Qrcode(asQrCode: true)}}<br>{{Body}}</html>' }
  let(:output_content) { { output: html_template, old_string: '{{Qrcode(asQrCode: true)}}' } }
  let(:report_params) { { 'qrcode' => '1234567890', 'body' => 'Тело документа' } }
  let(:qrcode) { described_class.new(report_params, output_content, TagParseService.parse!('Qrcode(asQrCode: true)')) }
  # let(:wrong_report_params) { { 'qrcode' => '123', 'body' => 'Тело документа' } }
  # let(:qrcode_wrong) { described_class.new(wrong_report_params, output_content, TagParseService.parse!('Qrcode(asQrCode: true)')) }

  it { expect(qrcode.done!).to eq('"<?xml version=\"1.0\" standalone=\"yes\"?><svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:ev=\"http://www.w3.org/2001/xml-events\" width=\"231\" height=\"231\" shape-rendering=\"crispEdges\"><path d=\"M0 0h7v7h-7zM8 0h2v1h-1v2h-1zM11 0h1v3h1v2h-1v-1h-1zM14 0h7v7h-7zM1 1v5h5v-5zM15 1v5h5v-5zM2 2h3v3h-3zM16 2h3v3h-3zM9 3h1v2h-1zM8 5h1v2h1v-1h1v1h-1v1h1v-1h1v-1h1v2h-1v1h1v-1h3v1h-1v1h1v1h-2v1h2v2h-1v-1h-2v-2h-1v-1h-2v-1h-1v2h-1v1h1v-1h1v3h-2v-1h-3v-1h-2v-1h-2v-2h1v-1h3v2h-2v-1h-1v1h1v1h2v-1h3zM6 8h1v1h-1zM18 8h3v4h-1v1h-1v-1h-1v-1h-1v-2h1zM13 9v1h1v-1zM18 10v1h2v-1zM0 11h1v1h-1zM6 11v1h1v-1zM11 11h1v2h-1zM1 12h2v1h-2zM12 13h1v1h2v1h-3zM18 13h1v1h-1zM0 14h7v7h-7zM16 14h2v1h-1v1h1v-1h1v4h1v1h-1v1h-1v-2h-1v-2h-1v-1h-1v-1h1zM20 14h1v2h-1zM1 15v5h5v-5zM10 15h1v1h-1zM2 16h3v3h-3zM8 16h1v2h1v-1h1v-1h2v1h-1v1h-2v1h-2zM13 17h1v1h-1zM15 17h1v4h-3v-1h-1v1h-1v-2h3v1h1zM9 20h1v1h-1z\" fill=\"#000\" transform=\"translate(0,0) scale(11)\"/></svg><br>{{Body}}</html>"') }
  # it { expect { qrcode_wrong.done! }.to raise_error(ReplaceFunctions::ReplaceFunctionError) }
end
