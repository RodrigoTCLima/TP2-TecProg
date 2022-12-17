require './src/irpf.rb'

describe 'Cadastro de rendimento' do
  let(:irpf) { IRPF.new }

  [
    { descricao: 'Salário mensal', valor: 1000 },
    { descricao: 'Receita aluguel', valor: 2000 },
    { descricao: 'Venda de ações', valor: 3000 }
  ].each do |parametros|
    describe 'quando é realizado com valores válidos' do
      before do
        irpf.cadastroRendimento(parametros[:valor], parametros[:descricao])

        @totalRendimentos ||= 0
        @totalRendimentos += parametros[:valor]

        @rendimentosDeclarados ||= []
        @rendimentosDeclarados << parametros[:descricao]
      end

      it 'o rendimento total deve ser igual ao valor cadastrado' do
        expect(irpf.valorTotalRendimentos).to eq @totalRendimentos
      end

      it 'a lista de rendimentos declarados deve conter o novo cadastro' do
        expect(irpf.rendimentosDeclarados).to eq @rendimentosDeclarados
      end
    end
  end

  describe 'quando é realizado com valores inválidos' do
    it 'a exceção DescricaoEmBrancoException deve ser lançada caso a descrição seja vazia' do
      expect {
        irpf.cadastroRendimento(1000, '')
      }.to raise_error(DescricaoEmBrancoException)
    end

    [
      { descricao: 'Salário mensal', valor: nil, categoria: 'vazio' },
      { descricao: 'Receita aluguel', valor: -1, categoria: 'negativo' },
      { descricao: 'Venda de ações', valor: 0, categoria: 'nulo' }
    ].each do |parametros|
      context 'a exceção ValorRendimentoInvalidoException deve ser lançada caso o valor seja' do
        it "#{parametros[:categoria]}" do
          expect {
            irpf.cadastroRendimento(parametros[:valor], parametros[:descricao])
          }.to raise_error(ValorRendimentoInvalidoException)
        end
      end
    end
  end
end


