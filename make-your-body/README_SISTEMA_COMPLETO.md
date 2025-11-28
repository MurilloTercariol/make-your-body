# 💪 Make Your Body - Sistema Completo de Treinos

## 🎯 Funcionalidades Implementadas

### 1. **Monte seu Treino** 🏗️

- **API Integration**: Conecta com a API Ninjas para buscar exercícios reais
- **Novo Token**: Utiliza o token `FKdtPSPnKdsgizlyPhcMfw==sdSlYZVhhP4JpoLZ`
- **Filtros Avançados**: Por grupo muscular (Bíceps, Tríceps, Peito, Costas, etc.)
- **Seleção Intuitiva**: Adicione/remova exercícios facilmente
- **Detalhes Completos**: Instruções, equipamentos, dificuldade
- **Nomeação Personalizada**: Dê nomes únicos aos seus treinos

### 2. **Meus Treinos** 📚

- **Persistência Local**: Treinos salvos no dispositivo com SharedPreferences
- **Gerenciamento Completo**:
  - ✏️ Editar nome do treino
  - 📋 Duplicar treinos existentes
  - 🗑️ Excluir treinos
- **Visualização Rica**: Preview dos exercícios em cards horizontais
- **Histórico**: Data de criação e última execução
- **Navegação Direta**: Acesso rápido para iniciar treinos

### 3. **Executar Treino** ⏱️

- **Interface Imersiva**: Tela dedicada para cada exercício
- **Timer de Descanso**: Sistema completo de cronômetro
- **Configurações Personalizáveis**:
  - ⏰ 1:30 minutos
  - ⏰ 2:00 minutos
  - ⏰ 3:00 minutos
  - ⏰ 5:00 minutos
- **Controles do Timer**:
  - ➕ Adicionar 30s
  - ➖ Remover 30s
  - ⏭️ Pular descanso
- **Progresso Visual**: Barra de progresso do treino
- **Navegação Flexível**: Avançar/voltar exercícios

### 4. **Sistema de Perfil** ⚙️

- **Configurações Persistentes**: Tempo de descanso preferido salvo
- **Interface Amigável**: Seleção via radio buttons
- **Aplicação Automática**: Configurações aplicadas em todos os treinos

## 🏗️ **Arquitetura do Sistema**

### **Controllers (MVC Pattern)**

1. **`MontetreinoController`** - Gerencia busca e seleção de exercícios
2. **`MeusTreinosController`** - CRUD completo de treinos salvos
3. **`ExecutarTreinoController`** - Lógica de execução e timer

### **Models**

1. **`ExercicioModel`** - Dados dos exercícios da API
2. **`TreinoSalvoModel`** - Estrutura dos treinos salvos

### **Views**

1. **`MonteTreinoView`** - Interface para criar treinos
2. **`MeusTreinosView`** - Gerenciar treinos salvos
3. **`ExecutarTreinoView`** - Executar treinos com timer

### **Persistência**

- **SharedPreferences** para treinos e configurações
- **Serialização JSON** para estruturas complexas

## 🚀 **Navegação e Integração**

### **Rotas Implementadas**

```dart
'/montetreino'    → MonteTreinoView
'/meustreinos'    → MeusTreinosView
'/executartreino' → ExecutarTreinoView
```

### **Integração na Home**

- **Botão "Monte seu Treino"** → Criar novos treinos
- **Ícone de Fitness** (bottom nav) → Acessar treinos salvos

## 🔧 **Tecnologias Utilizadas**

- **Flutter** - Framework principal
- **HTTP Package** - Requisições para API
- **SharedPreferences** - Persistência local
- **GetIt** - Injeção de dependências
- **ChangeNotifier** - Gerenciamento de estado

## 📱 **Fluxo de Uso**

1. **Criar Treino**:

   - Home → "Monte seu Treino"
   - Filtrar exercícios por músculo
   - Selecionar exercícios desejados
   - Dar nome ao treino
   - Salvar

2. **Gerenciar Treinos**:

   - Home → Ícone Fitness (bottom)
   - Ver todos os treinos salvos
   - Editar, duplicar ou excluir
   - Iniciar execução

3. **Executar Treino**:
   - Meus Treinos → "Iniciar Treino"
   - Seguir exercícios sequencialmente
   - Usar timer de descanso
   - Configurar tempos no perfil

## 🎨 **Design System**

- **Cor Principal**: `#F9C22E` (Amarelo/Dourado)
- **Fundo**: Preto para contraste
- **Tipografia**: LeagueGothic para títulos
- **Componentes**: Cards, modals, bottom sheets
- **Feedback Visual**: SnackBars, indicadores de progresso

## 🔄 **Estado Atual vs Implementado**

### ✅ **Concluído**

- ✅ API Integration com novo token
- ✅ Sistema completo de treinos salvos
- ✅ Execução de treinos com timer
- ✅ Configurações de perfil para tempos
- ✅ Persistência local completa
- ✅ Navegação integrada
- ✅ Interface responsiva e moderna

### 🎯 **Funcionalidades Futuras**

- 📊 Estatísticas de treinos
- 📈 Histórico de progresso
- 🔄 Sincronização em nuvem
- 📸 Fotos dos exercícios
- 💪 Sistema de metas

---

## 🚀 **Como Testar**

1. **Execute**: `flutter run`
2. **Acesse**: Tela inicial → "Monte seu Treino"
3. **Crie**: Selecione exercícios e salve um treino
4. **Gerencie**: Home → Ícone Fitness → Veja seus treinos
5. **Execute**: Inicie um treino e teste o timer
6. **Configure**: Use o ícone de configurações para ajustar tempos

**Sistema 100% funcional e integrado!** 🎉
