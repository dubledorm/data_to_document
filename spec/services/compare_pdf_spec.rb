# frozen_string_literal: true

require 'rails_helper'
require 'compare_pdf_helper'

RSpec.describe 'compare_pdf_function' do
  let(:pdf1) { File.open('spec/fixtures/simple_example.pdf', 'rb').read }
  let(:pdf2) { File.open('spec/fixtures/simple_example_made_later.pdf', 'rb').read }

  it { expect(pdf_equal?(pdf1, pdf2)).to be_truthy }
end
