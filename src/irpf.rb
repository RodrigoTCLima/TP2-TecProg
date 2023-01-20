require './src/exceptions'

DEDUCAO_DEPENDENTE = 189.59

class IRPF
  attr_accessor :valorTotalRendimentos, :rendimentosDeclarados
  attr_accessor :valorTotalDeducoes, :deducoesDeclaradas
  attr_accessor :listaDependentes, :totalImposto
  attr_accessor :impostosPorFaixa, :baseImpostoPorFaixa

  FAIXA_IMPOSTO = [
    { faixa: 4664.68, aliquota: 27.5 },
    { faixa: 3751.05, aliquota: 22.5 },
    { faixa: 2826.65, aliquota: 15 },
    { faixa: 1903.99, aliquota: 7.5 },
  ]

  def initialize
    @valorTotalRendimentos = 0
    @valorTotalDeducoes = 0
    @totalImposto = 0

    @rendimentosDeclarados = []
    @deducoesDeclaradas = []
    @listaDependentes = []
    @impostosPorFaixa = []
    @baseImpostoPorFaixa = []
  end

  def cadastroRendimento(valorRendimento, descricaoRendimento)
    raise DescricaoEmBrancoException if descricaoRendimento.nil? || descricaoRendimento.empty?
    raise ValorRendimentoInvalidoException if !valorRendimento.is_a?(Integer) || valorRendimento <= 0
    @valorTotalRendimentos += valorRendimento
    @rendimentosDeclarados << descricaoRendimento
  end

  def cadastroDeducao(valorDeducao, descricaoDeducao)
    raise DescricaoEmBrancoException if descricaoDeducao.nil? || descricaoDeducao.empty?
    raise ValorDeducaoInvalidoException if valorDeducao.nil? || valorDeducao <= 0 
    @valorTotalDeducoes += valorDeducao
    @deducoesDeclaradas << descricaoDeducao
  end

  def cadastroPrevidenciaOficial(valorPrevidenciaOficial, descricaoPrevidenciaOficial)
    @valorTotalDeducoes += valorPrevidenciaOficial
    @deducoesDeclaradas << descricaoPrevidenciaOficial
  end

  def cadastroPensaoAlimenticia(valorPensao)
    @valorTotalDeducoes += valorPensao
    @deducoesDeclaradas << 'Pensão Alimentícia'
  end

  def cadastroDependente(nomeDependente, dataDeNacimentoDependente)
    raise NomeEmBrancoException if nomeDependente.nil? || nomeDependente.empty?
    @valorTotalDeducoes += DEDUCAO_DEPENDENTE
    @listaDependentes << nomeDependente
  end

  def calculaTaxas
    calculoBase = @valorTotalRendimentos - @valorTotalDeducoes

    FAIXA_IMPOSTO.each do |imposto|
      calculoBase = calculaBaseImpostoFaixaN(calculoBase, imposto[:faixa])
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

  def calculaBaseImpostoFaixaN(calculoBase, impostoFaixaN)
    impostoBaseFaixaN = calculoBase - impostoFaixaN
    if impostoBaseFaixaN < 0
      impostoBaseFaixaN = 0
      impostoFaixaN = 0
    end
    @baseImpostoPorFaixa << impostoBaseFaixaN
    impostoFaixaN
  end

  def calculaImpostoFaixaN(baseImpostoFaixaN, aliquota)
    @impostosPorFaixa << baseImpostoFaixaN * aliquota / 100
    @totalImposto += @impostosPorFaixa.last
  end

  def calculaAliquotaEfetiva
    100 * @totalImposto / @valorTotalRendimentos
  end
end
