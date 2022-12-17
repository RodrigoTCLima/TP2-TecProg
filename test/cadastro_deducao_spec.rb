require './src/irpf.rb'

describe 'Cadastro de dedução' do
  let(:irpf) { IRPF.new }

  describe 'quando é realizado cadastro do dedução' do
    let(:previdenciaPrivadaValor) { 1000 }
    let(:previdenciaPrivadaDescricao) { 'Previdencia Privada' }

    before do
      irpf.cadastroDeducao(previdenciaPrivadaValor, previdenciaPrivadaDescricao)
    end

    it 'a dedução total deve ser igual ao valor cadastrado' do
      expect(irpf.valorTotalDeducoes).to eq previdenciaPrivadaValor
    end

    it 'a lista de deduções declaradas deve conter o novo cadastro' do
      expect(irpf.deducoesDeclaradas).to eq [previdenciaPrivadaDescricao]
    end
  end
end

