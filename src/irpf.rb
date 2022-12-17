require './src/exceptions'

class IRPF
  attr_accessor :valorTotalRendimentos, :rendimentosDeclarados

  def initialize
    @valorTotalRendimentos = 0
    @rendimentosDeclarados = []
  end

  def cadastroRendimento(valorRendimento, descricaoRendimento)
    raise DescricaoEmBrancoException if descricaoRendimento.nil? || descricaoRendimento.empty?
    raise ValorRendimentoInvalidoException if valorRendimento.nil? || valorRendimento <= 0
    @valorTotalRendimentos += valorRendimento
    @rendimentosDeclarados << descricaoRendimento
  end
end
