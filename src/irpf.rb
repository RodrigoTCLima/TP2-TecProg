class IRPF
  attr_accessor :valorTotalRendimentos, :rendimentosDeclarados

  def initialize
    @valorTotalRendimentos = 0
    @rendimentosDeclarados = []
  end

  def cadastroRendimento(valorRendimento, descricaoRendimento)
    @valorTotalRendimentos += valorRendimento
    @rendimentosDeclarados << descricaoRendimento
  end
end
