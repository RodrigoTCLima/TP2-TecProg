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
end

