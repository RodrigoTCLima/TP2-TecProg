require './src/irpf.rb'

describe 'Cadastro de dedução' do
  let(:irpf) { IRPF.new }

  # cadastro de dedução
  [ {descricao: 'Previdencia Privada', valor: 1000},
    {descricao: 'Funpresp', valor: 2000},
    {descricao: 'Parcela isenta de aposentadoria', valor: 4000}
  ].each do |parametros|
  describe 'quando é realizado cadastro do dedução' do
    before do
      irpf.cadastroDeducao(parametros[:valor], parametros[:descricao])
      
      @totalDeducoes ||=0
      @totalDeducoes += parametros[:valor]

      @deducoesDeclaradas ||= []
      @deducoesDeclaradas << parametros[:descricao]
      
    end

    it 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.valorTotalDeducoes).to eq @totalDeducoes
    end

    it 'a lista de deduções declaradas deve conter o novo cadastro' do
      expect(irpf.deducoesDeclaradas).to eq @deducoesDeclaradas
    end
  end

  describe 'quando é realizado um cadastro de dedução com descrição em branco' do
    let(:descricao) { '' }
    let(:valor) { 1200 }
    it 'a exceção DescricaoEmBrancoException deve ser lançada' do 
      expect {
        irpf.cadastroDeducao(valor, descricao)
      }.to raise_error(DescricaoEmBrancoException)
    end
  end

  [ {descricao: 'Previdencia Privada', valor: 0},
    {descricao: 'Funpresp', valor: -2000},
    {descricao: 'Parcela isenta de aposentadoria', valor: -150}
  ].each do |parametros|
  describe 'quando é realizado cadastro do dedução com valores inválidos' do
    it 'a exceção ValorDeducaoInvalidoException deve ser lançada' do
      expect(irpf.cadastroDeducao(parametros[:valor], parametros[:descricao])).to raise_error(ValorDeducaoInvalidoException)
    end
  end

  # cadastro de previdencia oficial
  describe 'quando é realizado um cadastro de contrinuição previdenciaria oficial' do
    let(:descricaoPrevidenciaOficial) { 'Previdêcia Oficial' }
    let(:valorPrevidenciaOficial) { 1000 }

    before do 
      irpf.cadastroPrevidenciaOficial(valorPrevidenciaOficial, descricaoPrevidenciaOficial)
    end
    
    it 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.totalDeducoes).to eq valorPrevidenciaOficial
    end

    it 'a lista de deduções declaradas deve conter o novo cadastro' do
      expect(irpf.deducoesDeclaradas).to eq [descricaoPrevidenciaOficial]
    end
  end

  # cadastro de pensão alimentícia
  describe 'quando é realizado um cadastro de pensão alimentícia' do
    let(:valorPensao) { 1000 }

    before do
      irpf.cadastroPensaoAlimenticia(valorPensao)
    end

    if 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.totalDeducoes).to eq valorPensao
    end
  end

  # cadastro de dependentes
  describe 'quando é realizado o cadastro de dependentes' do
    let(:nomeDependente) { 'Pedro Tiago e João' }
    let(:dataDeNacimentoDependente) { '01/01/2011' }

    before do
      irpf.cadastroDependente(nomeDependente, dataDeNacimentoDependente)
    end

    if 'a dedução total deve ser igual ao (número de dependentes*189,59)' do
      expect(irpf.totalDeducoes).to eq 189.59
    end

    if 'o nome do dependente deve estar na lista de dependentes' do
      expect(irpf.listaDependentes).to eq [nomeDependente]
    end
  end
  

end

