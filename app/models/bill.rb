require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/svg_outputter'

class Bill < ApplicationRecord
  belongs_to :billing_account
  belongs_to :credit, optional: true
  validates :name, presence: true

  mount_uploader :attachment, AttachmentUploader

  before_validation do
    self.barcode = barcode.strip if barcode.present?
  end

  def pay(account)
    self.credit = account.credits.build(value: value, name: name)
    self.credit.save
    save
  end

  def rendered_barcode
    return '' unless barcode.present?
    if barcode.length == 47 # banco
      "#{barcode[0..4]}.#{barcode[5..9]} #{barcode[10..14]}.#{barcode[15..20]} #{barcode[21..25]}.#{barcode[26..31]} #{barcode[32]} #{barcode[33..46]}"
    elsif barcode.length == 48 # concessionária
      "#{barcode[0..10]}-#{barcode[11]} #{barcode[12..22]}-#{barcode[23]} #{barcode[24..34]}-#{barcode[35]} #{barcode[36..46]}-#{barcode[47]}"
    end
  end

  def svg_barcode(height = 120)
    return '' unless barcode.present?
    code = Barby::Code25Interleaved.new(barcode)
    code.include_checksum = barcode.length == 47
    out = Barby::SvgOutputter.new(code)
    out.height = height
    out.to_svg
  end

  def validate_barcode
    if barcode.length == 47
      #errors.add(:barcode, 'Não é possível validar boletos de cobrança.')
    elsif barcode.length == 48 && barcode[0] == '8'
     #
    else
      errors.add(:barcode, 'O código de barras está inválido.')
    end
  end

end
