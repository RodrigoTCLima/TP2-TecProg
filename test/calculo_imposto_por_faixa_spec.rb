require './src/irpf'

describe 'Cálculo dos impostos das faixas de impostos' do
  let(:irpf) { IRPF.new }
  let(:salarioMensal) { 2000 }
  let(:baseImpostoPorFaixa) { [1903.98, 96.02, 0, 0, 0] }
  let(:impostosPorFaixa) { [0, 7.20, 0, 0, 0] }

  before do
    irpf.cadastroRendimento(salarioMensal, 'Salário mensal')
    irpf.calculaTaxas
  end

  it 'a base de imposto por faixa deve ser inferior ou igual a faixa de imposto' do
    for i in 0..irpf.baseImpostoPorFaixa.length-1
      expect(irpf.baseImpostoPorFaixa[i]).to be_within(0.1).of(baseImpostoPorFaixa[i])
    end
  end

  it 'o imposto por faixa deve ser calculado a partir da base de imposto da faixa' do
    for i in 0..irpf.impostosPorFaixa.length-1
      expect(irpf.impostosPorFaixa[i]).to be_within(0.01).of(impostosPorFaixa[i])
    end
  end

  it 'o total de impostos deve ser a soma de impostos por faixa' do
    expect(irpf.totalImposto).to be_within(0.01).of(impostosPorFaixa.sum)
  end
end
