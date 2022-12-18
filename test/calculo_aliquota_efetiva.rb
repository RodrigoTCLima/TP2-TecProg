require './src/irpf'

describe 'Calculo aliquota efetiva'
    let(:irpf) { IRPF.new }

    describe 'quando feito corretamente' do
        before do
            irpf.cadastroRendimento('Salario', 10000)
            irpf.cadastroDeducao('Previdência Privada', 1000)
            irpf.calculaTaxas()
        end
        it 'a aliquota efetiva deve ser a porcentagem do imposto sobre o rendimento total' do
            expect(irpf.calculaAliquotaEfetiva()).to eq 16.05
        end
    end

end