require './src/exceptions'
require './src/impostoPorFaixa'

DEDUCAO_DEPENDENTE = 189.59

class IRPF
  attr_accessor :valorTotalRendimentos, :rendimentosDeclarados
  attr_accessor :valorTotalDeducoes, :deducoesDeclaradas
  attr_accessor :listaDependentes, :totalImposto
  attr_accessor :impostosPorFaixa, :baseImpostoPorFaixa

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
    impostoPorFaixa = ImpostoPorFaixas.new(@valorTotalRendimentos, @valorTotalDeducoes)
    impostoPorFaixa.compute
    @impostosPorFaixa = impostoPorFaixa.impostosPorFaixa
    @baseImpostoPorFaixa = impostoPorFaixa.baseImpostoPorFaixa
    @totalImposto = impostoPorFaixa.totalImposto
  end

  def calculaAliquotaEfetiva
    ImpostoPorFaixas::PORCENTAGEM_TOTAL * @totalImposto / @valorTotalRendimentos
  end
end
