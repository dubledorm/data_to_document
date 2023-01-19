# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReplaceFunctions::Html::Barcode do
  let(:html_template) { '{{Barcode(asBarcode: true)}}<br>{{Body}}</html>' }
  let(:output_content) { { output: html_template, old_string: '{{Barcode(asBarcode: true)}}' } }
  let(:report_params) { { 'barcode' => '1234567890', 'body' => 'Тело документа' } }
  let(:barcode) { described_class.new(report_params, output_content, TagParseService.parse!('Barcode(asBarcode: true)')) }
  let(:wrong_report_params) { { 'barcode' => '123', 'body' => 'Тело документа' } }
  let(:barcode_wrong) { described_class.new(wrong_report_params, output_content, TagParseService.parse!('Barcode(asBarcode: true)')) }

  it { expect(barcode.done!).to eq('<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="119px" height="120px" viewBox="0 0 119 120" version="1.1" preserveAspectRatio="none" >
<title>1234567890</title>
<g id="canvas" >
<rect x="0" y="0" width="119px" height="120px" fill="#fff" />
<g id="barcode" fill="#000">
<rect x="10" y="10" width="1px" height="100px" />
<rect x="12" y="10" width="1px" height="100px" />
<rect x="14" y="10" width="3px" height="100px" />
<rect x="18" y="10" width="1px" height="100px" />
<rect x="22" y="10" width="1px" height="100px" />
<rect x="24" y="10" width="1px" height="100px" />
<rect x="26" y="10" width="3px" height="100px" />
<rect x="32" y="10" width="3px" height="100px" />
<rect x="36" y="10" width="3px" height="100px" />
<rect x="40" y="10" width="1px" height="100px" />
<rect x="44" y="10" width="1px" height="100px" />
<rect x="46" y="10" width="1px" height="100px" />
<rect x="50" y="10" width="3px" height="100px" />
<rect x="54" y="10" width="1px" height="100px" />
<rect x="58" y="10" width="3px" height="100px" />
<rect x="64" y="10" width="1px" height="100px" />
<rect x="66" y="10" width="1px" height="100px" />
<rect x="68" y="10" width="1px" height="100px" />
<rect x="72" y="10" width="1px" height="100px" />
<rect x="74" y="10" width="1px" height="100px" />
<rect x="76" y="10" width="3px" height="100px" />
<rect x="82" y="10" width="3px" height="100px" />
<rect x="86" y="10" width="1px" height="100px" />
<rect x="88" y="10" width="3px" height="100px" />
<rect x="92" y="10" width="1px" height="100px" />
<rect x="96" y="10" width="3px" height="100px" />
<rect x="102" y="10" width="1px" height="100px" />
<rect x="104" y="10" width="3px" height="100px" />
<rect x="108" y="10" width="1px" height="100px" />

</g></g>
</svg>
<br>{{Body}}</html>')
  }
  it { expect { barcode_wrong.done! }.to raise_error(ReplaceFunctions::ReplaceFunctionError) }
end
