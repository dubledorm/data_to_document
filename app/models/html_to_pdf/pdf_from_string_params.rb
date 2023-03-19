# frozen_string_literal: true

module HtmlToPdf

  # Параметры для функции pdf_from_string
  class PdfFromStringParams < BaseModel

    ORIENTATION_VALUES = %w[Portrait Landscape].freeze
    PAGE_SIZE_VALUES = %w[Custom Letter LetterSmall Tabloid Ledger Legal Statement Executive A3 A4 A4Small A5 B4
                          B5 Folio Quarto Standard10x14 Standard11x17 Note Number9Envelope Number10Envelope
                          Number11Envelope Number12Envelope Number14Envelope CSheet DSheet ESheet DLEnvelope C5Envelope
                          C3Envelope C4Envelope C6Envelope C65Envelope B4Envelope B5Envelope B6Envelope ItalyEnvelope
                          MonarchEnvelope PersonalEnvelope USStandardFanfold GermanStandardFanfold GermanLegalFanfold
                          IsoB4 JapanesePostcard Standard9x11 Standard10x11 Standard15x11 InviteEnvelope LetterExtra
                          LegalExtra TabloidExtra A4Extra LetterTransverse A4Transverse LetterExtraTransverse
                          APlus BPlus LetterPlus A4Plus A5Transverse B5Transverse A3Extra A5Extra B5Extra A2
                          A3Transverse A3ExtraTransverse JapaneseDoublePostcard A6 JapaneseEnvelopeKakuNumber2
                          JapaneseEnvelopeKakuNumber3 JapaneseEnvelopeChouNumber3 JapaneseEnvelopeChouNumber4
                          LetterRotated A3Rotated A4Rotated A5Rotated B4JisRotated B5JisRotated JapanesePostcardRotated
                          JapaneseDoublePostcardRotated A6Rotated JapaneseEnvelopeKakuNumber2Rotated
                          JapaneseEnvelopeKakuNumber3Rotated JapaneseEnvelopeChouNumber3Rotated
                          JapaneseEnvelopeChouNumber4Rotated B6Jis B6JisRotated Standard12x11
                          JapaneseEnvelopeYouNumber4 JapaneseEnvelopeYouNumber4Rotated
                          Prc16K Prc32K Prc32KBig PrcEnvelopeNumber1 PrcEnvelopeNumber2 PrcEnvelopeNumber3
                          PrcEnvelopeNumber4 PrcEnvelopeNumber5 PrcEnvelopeNumber6 PrcEnvelopeNumber7
                          PrcEnvelopeNumber8 PrcEnvelopeNumber9 PrcEnvelopeNumber10 Prc16KRotated Prc32KRotated
                          Prc32KBigRotated PrcEnvelopeNumber1Rotated PrcEnvelopeNumber2Rotated
                          PrcEnvelopeNumber3Rotated PrcEnvelopeNumber4Rotated PrcEnvelopeNumber5Rotated
                          PrcEnvelopeNumber6Rotated PrcEnvelopeNumber7Rotated PrcEnvelopeNumber8Rotated
                          PrcEnvelopeNumber9Rotated PrcEnvelopeNumber10Rotated].freeze

    attr_accessor :html_text, :header_html, :footer_html, :orientation, :page_height, :page_width, :page_size, :margin

    validates :html_text, presence: true
    validates :page_height, :page_width, numericality: { only_integer: true }, allow_nil: true
    validates :orientation, inclusion: { in: ORIENTATION_VALUES }, allow_nil: true
    validates :page_size, inclusion: { in: PAGE_SIZE_VALUES }, allow_nil: true

    def attributes=(hash)
      return unless hash

      hash.each do |key, value|
        if key == 'margin'
          send("#{key}=", HtmlToPdf::Margin.new(value))
          next
        end

        send("#{key}=", value)
      end
    end

    def attributes
      result = {}
      %i[html_text header_html footer_html orientation page_height page_width page_size].each do |key|
        result[key] = send(key) unless send(key).blank?
      end

      result['margin'] = margin.as_json unless margin.blank?
      result
    end
  end
end
