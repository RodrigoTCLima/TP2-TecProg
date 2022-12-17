class DescricaoEmBrancoException < StandardError
  def initialize(msg="Exceção gerada quando a descrição está vazia.")
    super
  end
end

class ValorRendimentoInvalidoException < StandardError
  def initialize(msg="Exceção gerada quando o valor do rendimento não é um valor numérico positivo.")
    super
  end
end

class NomeEmBrancoException < StandardError
  def initialize(msg="Exceção gerada quando um nome de um dependente está vazio.")
    super
  end
end

class ValorDeducaoInvalidoException < StandardError
  def initialize(msg="Exceção gerada quando uma dedução válida não é um número positivo.")
    super
  end
end
