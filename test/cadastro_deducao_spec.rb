require './src/irpf'

describe 'Cadastro de dedução' do
  let(:irpf) { IRPF.new }

  # cadastro de dedução
  [{ descricao: 'Previdencia Privada', valor: 1000 },
   { descricao: 'Funpresp', valor: 2000 },
   { descricao: 'Parcela isenta de aposentadoria', valor: 4000 }].each do |parametros|
    describe 'quando é realizado com valores válidos' do
      before do
        irpf.cadastroDeducao(parametros[:valor], parametros[:descricao])

        @totalDeducoes ||= 0
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

  describe 'quando é realizado com descrição em branco' do
    let(:descricao) { '' }
    let(:valor) { 1200 }
    it 'a exceção DescricaoEmBrancoException deve ser lançada' do
      expect do
        irpf.cadastroDeducao(valor, descricao)
      end.to raise_error(DescricaoEmBrancoException)
    end
  end

  [{ descricao: 'Previdencia Privada', valor: 0 },
   { descricao: 'Funpresp', valor: -2000 },
   { descricao: 'Parcela isenta de aposentadoria', valor: -150 }].each do |parametros|
    describe 'quando é realizado com valores inválidos' do
      it 'a exceção ValorDeducaoInvalidoException deve ser lançada' do
        expect do
          irpf.cadastroDeducao(parametros[:valor], parametros[:descricao])
        end.to raise_error(ValorDeducaoInvalidoException)
      end
    end
  end

  [{ descricao: 'Previdencia Oficial', valor: 1000 },
   { descricao: 'Previdencia Oficial2', valor: 2000 },
   { descricao: 'Previdencia Oficial3', valor: 4000 }].each do |parametros|
    describe 'quando é de previdências oficiais' do
      before do
        irpf.cadastroPrevidenciaOficial(parametros[:valor], parametros[:descricao])

        @totalDeducoes ||= 0
        @totalDeducoes += parametros[:valor]

        @deducoesDeclaradas ||= []
        @deducoesDeclaradas << parametros[:descricao]
      end

      it 'a dedução total deve ser igual ao valor cadastrado das previdências' do
        expect(irpf.valorTotalDeducoes).to eq @totalDeducoes
      end

      it 'a lista de deduções declaradas das previdências deve conter o novo cadastro' do
        expect(irpf.deducoesDeclaradas).to eq @deducoesDeclaradas
      end
    end
  end

  [{ valor: 1000 },
   { valor: 2000 },
   { valor: 4000 }].each do |parametros|
    describe 'quando é de pensões alimentícias' do
      before do
        irpf.cadastroPensaoAlimenticia(parametros[:valor])

        @totalDeducoes ||= 0
        @totalDeducoes += parametros[:valor]
      end

      it 'a dedução total deve ser igual a soma dos valores cadastrados' do
        expect(irpf.valorTotalDeducoes).to eq @totalDeducoes
      end
    end
  end

  [{ nomeDependente: 'Pedro Tiago e João', dataDeNacimentoDependente: '01/01/2015' },
   { nomeDependente: 'Ana Tiago e João', dataDeNacimentoDependente: '02/02/2016' },
   { nomeDependente: 'Marcos Tiago e João', dataDeNacimentoDependente: '03/03/2017' }].each do |parametros|
    describe 'quando é realizado de dependentes' do
      before do
        irpf.cadastroDependente(parametros[:nomeDependente], parametros[:dataDeNacimentoDependente])

        @totalDeducoes ||= 0
        @totalDeducoes += DEDUCAO_DEPENDENTE

        @listaDependentes ||= []
        @listaDependentes << parametros[:nomeDependente]
      end

      it "a dedução total deve ser igual ao (número de dependentes*#{DEDUCAO_DEPENDENTE})" do
        expect(irpf.valorTotalDeducoes).to eq @totalDeducoes
      end

      it 'o nome do dependente deve estar na lista de dependentes' do
        expect(irpf.listaDependentes).to eq @listaDependentes
      end
    end
  end

  describe 'quando é realizado de dependentes com nome em branco' do
    it 'a exceção NomeEmBrancoException deve ser lançada' do
      expect { irpf.cadastroDependente('', '01/01/2015') }.to raise_error(NomeEmBrancoException)
    end
  end
end
