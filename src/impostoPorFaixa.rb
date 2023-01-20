class ImpostoPorFaixas
  attr_accessor :impostosPorFaixa, :baseImpostoPorFaixa, :calculoBase

  FAIXA_IMPOSTO = [
    { faixa: 4664.68, aliquota: 27.5 },
    { faixa: 3751.05, aliquota: 22.5 },
    { faixa: 2826.65, aliquota: 15 },
    { faixa: 1903.99, aliquota: 7.5 },
  ]
  PORCENTAGEM_TOTAL = 100

  def initialize(valorTotalRendimentos, valorTotalDeducoes)
    @impostosPorFaixa = []
    @baseImpostoPorFaixa = []
    @calculoBase = valorTotalRendimentos - valorTotalDeducoes
  end

  def compute
    FAIXA_IMPOSTO.each do |imposto|
      calculaBaseImpostoFaixaN(imposto[:faixa])
      calculaImpostoFaixaN(@baseImpostoPorFaixa.last, imposto[:aliquota])
    end

    @baseImpostoPorFaixa << FAIXA_IMPOSTO.last[:faixa]
    @impostosPorFaixa << 0

    ordenaFaixas
  end

  def ordenaFaixas
    @impostosPorFaixa.reverse!
    @baseImpostoPorFaixa.reverse!
  end

  def calculaBaseImpostoFaixaN(impostoFaixaN)
    impostoBaseFaixaN = @calculoBase - impostoFaixaN
    if impostoBaseFaixaN < 0
      impostoBaseFaixaN = 0
      impostoFaixaN = 0
    end
    @baseImpostoPorFaixa << impostoBaseFaixaN
    @calculoBase = impostoFaixaN
  end

  def calculaImpostoFaixaN(baseImpostoFaixaN, aliquota)
    @impostosPorFaixa << baseImpostoFaixaN * aliquota / PORCENTAGEM_TOTAL
  end

  def totalImposto
    @impostosPorFaixa.sum
  end
end
