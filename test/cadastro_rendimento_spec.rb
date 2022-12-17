require './src/irpf.rb'

describe "Cadastro de rendimento" do
  let(:irpf) { IRPF.new }

  describe 'quando é realizado o primeiro cadastro do rendimento' do
    let(:salarioMensalValor) { 1000 }
    let(:salarioMensal) { 'Salário mensal' }

    before do
      irpf.cadastroRendimento(salarioMensalValor, salarioMensal)
    end

    it 'o rendimento total deve ser igual ao valor cadastrado' do
      expect(irpf.valorTotalRendimentos).to eq salarioMensalValor
    end

    it 'a lista de rendimentos declarados deve conter o novo cadastro' do
      expect(irpf.rendimentosDeclarados).to eq [salarioMensal]
    end
  end
end
