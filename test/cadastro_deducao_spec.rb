require './src/irpf.rb'

describe 'Cadastro de dedução' do
  let(:irpf) { IRPF.new }

  describe 'quando é realizado cadastro do dedução' do
    let(:previdenciaPrivadaValor) { 1000 }
    let(:previdenciaPrivadaDescricao) { 'Previdencia Privada' }

    let(:funprespValor) { 2000 }
    let(:funprespDescricao) { 'Funpresp' }
    
    before do
      irpf.cadastroDeducao(previdenciaPrivadaValor, previdenciaPrivadaDescricao)
      irpf.cadastroDeducao(funprespValor, funprespDescricao)
    end

    it 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.valorTotalDeducoes).to eq previdenciaPrivadaValor + funprespValor
    end

    it 'a lista de deduções declaradas deve conter o novo cadastro' do
      expect(irpf.deducoesDeclaradas).to eq [previdenciaPrivadaDescricao, funprespDescricao]
    end
  end
end

