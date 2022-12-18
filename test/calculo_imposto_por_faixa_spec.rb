require './src/irpf'

describe 'Cálculo dos impostos das faixas de impostos' do
  let(:irpf) { IRPF.new }
  let(:baseImpostoPorFaixa) { [1903.98, 922.67, 924.40, 913.63, 335.32] }
  let(:impostosPorFaixa) { [0, 69.2, 138.66, 205.5, 92.2] }

  before do
    [
      { descricao: 'Salário mensal', valor: 1000 },
      { descricao: 'Receita aluguel', valor: 2000 },
    ].each do |parametros|
      irpf.cadastroRendimento(parametros[:valor], parametros[:descricao])
      irpf.calculaTaxas
    end
  end

  it 'a base de imposto por faixa deve ser inferior ou igual a faixa de imposto' do
    for i in 0..irpf.baseImpostoPorFaixa.length-1
      expect(irpf.baseImpostoPorFaixa[i]).to be_within(0.1).of(baseImpostoPorFaixa[i])
    end
  end

  it 'o imposto por faixa deve ser calculado a partir da base de imposto da faixa' do
    for i in 0..irpf.impostosPorFaixa.length-1
      expect(irpf.impostosPorFaixa[i]).to be_within(0.1).of(impostosPorFaixa[i])
    end
  end

  it 'o total de impostos deve ser a soma de impostos por faixa' do
    expect(irpf.totalImposto).to be_within(0.1).of(impostosPorFaixa.sum)
  end
end
