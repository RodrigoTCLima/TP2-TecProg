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

    let(:descricaoPrevidenciaOficial2) { 'Previdêcia Oficial2' }
    let(:valorPrevidenciaOficial2) { 2000 }

    before do 
      irpf.cadastroPrevidenciaOficial(valorPrevidenciaOficial, descricaoPrevidenciaOficial)
      irpf.cadastroPrevidenciaOficial(valorPrevidenciaOficial2, descricaoPrevidenciaOficial2)
    end
    
    it 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.totalDeducoes).to eq valorPrevidenciaOficial+valorPrevidenciaOficial2
    end

    it 'a lista de deduções declaradas deve conter o novo cadastro' do
      expect(irpf.deducoesDeclaradas).to eq [descricaoPrevidenciaOficial, descricaoPrevidenciaOficial2]
    end
  end

  # cadastro de pensão alimentícia
  describe 'quando é realizado um cadastro de pensão alimentícia' do
    let(:valorPensao) { 1000 }
    let(:valorPensao2) { 2500 }

    before do
      irpf.cadastroPensaoAlimenticia(valorPensao)
      irpf.cadastroPensaoAlimenticia(valorPensao)
    end

    if 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.totalDeducoes).to eq valorPensao+valorPensao2
    end
  end

  # cadastro de dependentes
  describe 'quando é realizado o cadastro de dependentes' do
    let(:nomeDependente) { 'Pedro Tiago e João' }
    let(:dataDeNacimentoDependente) { '01/01/2011' }

    let(:nomeDependente2) { 'Ana Maria Marcia' }
    let(:dataDeNacimentoDependente2) { '02/02/2012' }


    before do
      irpf.cadastroDependente(nomeDependente, dataDeNacimentoDependente)
      irpf.cadastroDependente(nomeDependente2, dataDeNacimentoDependente2)
    end

    if 'a dedução total deve ser igual ao (número de dependentes*189,59)' do
      expect(irpf.totalDeducoes).to eq 189.59+189.59
    end

    if 'o nome do dependente deve estar na lista de dependentes' do
      expect(irpf.listaDependentes).to eq [nomeDependente, nomeDependente2]
    end
  end


end

