require './src/irpf.rb'

describe "Cadastro de rendimento" do
  let(:irpf) { IRPF.new }

  describe 'quando é realizado o primeiro cadastro do rendimento' do
    let(:salarioMensalValor) { 1000 }
    let(:salarioMensal) { 'Salário mensal' }

    let(:receitaAluguelValor) { 2000 }
    let(:receitaAluguel) { 'Receita aluguel' }

    before do
      irpf.cadastroRendimento(salarioMensalValor, salarioMensal)
      irpf.cadastroRendimento(receitaAluguelValor, receitaAluguel)
    end

    it 'o rendimento total deve ser igual ao valor cadastrado' do
      expect(irpf.valorTotalRendimentos).to eq salarioMensalValor + receitaAluguelValor
    end

    it 'a lista de rendimentos declarados deve conter o novo cadastro' do
      expect(irpf.rendimentosDeclarados).to eq [salarioMensal, receitaAluguel]
    end
  end
end
