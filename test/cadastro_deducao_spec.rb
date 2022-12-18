require './src/irpf.rb'

describe 'Cadastro de dedução' do
  let(:irpf) { IRPF.new }

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


end

