# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagParseService do
  describe 'parse' do
    context 'when wrong source' do
      it { expect { described_class.parse!('') }.to raise_error(TagParseService::ParseError) }
      it { expect { described_class.parse!('1name') }.to raise_error(TagParseService::ParseError) }
      it { expect { described_class.parse!('name(1arg: value)') }.to raise_error(TagParseService::ParseError) }
      it { expect { described_class.parse!('name(arg1: )') }.to raise_error(TagParseService::ParseError) }
      it { expect { described_class.parse!('name(,)') }.to raise_error(TagParseService::ParseError) }
      it { expect { described_class.parse!('name(arg1,)') }.to raise_error(TagParseService::ParseError) }
    end

    context 'when right source' do
      it { expect(described_class.parse!('name')).to eq({ 'name' => 'name', 'arguments' => {} }) }
      it { expect(described_class.parse!('name()')).to eq({ 'name' => 'name', 'arguments' => {} }) }
      it { expect(described_class.parse!('name(arg1: value1)')).to eq({ 'name' => 'name', 'arguments' => { 'arg1' => 'value1'} }) }
      it { expect(described_class.parse!('  name(  arg1:   value1   )')).to eq({ 'name' => 'name', 'arguments' => { 'arg1' => 'value1'} }) }
    end

    context 'when upcase symbol exists in keys of source' do
      it { expect(described_class.parse!('Name')).to eq({ 'name' => 'name', 'arguments' => {} }) }
      it { expect(described_class.parse!('NaMe()')).to eq({ 'name' => 'name', 'arguments' => {} }) }
      it { expect(described_class.parse!('Name(ARG1: value1)')).to eq({ 'name' => 'name', 'arguments' => { 'arg1' => 'value1'} }) }
      it { expect(described_class.parse!('  nAme(  aRg1:   value1   )')).to eq({ 'name' => 'name', 'arguments' => { 'arg1' => 'value1'} }) }
    end
  end

  describe 'parse_arguments' do
    it { expect(described_class.parse_arguments!('')).to eq({}) }
    it { expect(described_class.parse_arguments!('arg1: value1')).to eq({ 'arg1' => 'value1' }) }
    it {
      expect(described_class.parse_arguments!('arg1: value1, Arg2: value2')).to eq({ 'arg1' => 'value1',
                                                                                    'arg2' => 'value2' })
    }
    it {
      expect(described_class.parse_arguments!('   arg1:  value1 , arg2:   value2  ')).to eq({ 'arg1' => 'value1',
                                                                                             'arg2' => 'value2' })
    }
    it { expect(described_class.parse_arguments!('arg1: 1.23')).to eq({ 'arg1' => '1.23' }) }
  end
end
