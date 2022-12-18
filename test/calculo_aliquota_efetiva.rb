require './src/irpf'

describe 'Calculo aliquota efetiva'
    let!(:irpf) { IRPF.new }

    [{descricaoRend: 'Salário', rendimento: 10000, descricaoDedu: 'Funpresp', deducao: 1000, resultado:16.05},
     {descricaoRend: 'Salário', rendimento: 7000,  descricaoDedu: 'Funpresp', deducao: 1000, resultado:11.15},
     {descricaoRend: 'Salário', rendimento: 3000,  descricaoDedu: 'Funpresp', deducao: 500,  resultado:1.49}
    ].each do |parametros|
        describe 'quando feito corretamente' do
            before do
                irpf.cadastroRendimento(parametros[:descricaoRend], parametros[:rendimento])
                irpf.cadastroDeducao(parametros[:descricaoDedu], parametros[:deducao])
                irpf.calculaTaxas()
            end
            it 'a aliquota efetiva deve ser a porcentagem do imposto sobre o rendimento total' do
                expect(irpf.calculaAliquotaEfetiva()).to be_within(0.1).of(parametros[:resultado])
            end
        end
    end
end