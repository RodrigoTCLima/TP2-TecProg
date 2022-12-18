require './src/exceptions'

class IRPF
  attr_accessor :valorTotalRendimentos, :rendimentosDeclarados
  attr_accessor :valorTotalDeducoes, :deducoesDeclaradas

  def initialize
    @valorTotalRendimentos = 0
    @rendimentosDeclarados = []
    @valorTotalDeducoes = 0
    @deducoesDeclaradas = []
  end

  def cadastroRendimento(valorRendimento, descricaoRendimento)
    raise DescricaoEmBrancoException if descricaoRendimento.nil? || descricaoRendimento.empty?
    raise ValorRendimentoInvalidoException if !valorRendimento.is_a?(Integer) || valorRendimento <= 0
    @valorTotalRendimentos += valorRendimento
    @rendimentosDeclarados << descricaoRendimento
  end

  def cadastroDeducao(valorDeducao, descricaoDeducao)
    raise DescricaoEmBrancoException if descricaoDeducao.nil? || descricaoDeducao.empty?
    raise ValorDeducaoInvalidoException if valorDeducao.nil? || valorDeducao >= 0 
    @valorTotalDeducoes += valorDeducao
    @deducoesDeclaradas << descricaoDeducao
  end
end
