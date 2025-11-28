# Tela "Monte seu Treino" - Documentação

## Funcionalidades Implementadas

### 1. **Tela Principal Monte seu Treino**

- Interface moderna com tema escuro
- Busca exercícios de uma API externa (API Ninjas)
- Sistema de backup com exercícios pré-definidos caso a API falhe
- Filtro por grupo muscular (Peito, Costas, Ombros, Bíceps, Tríceps, Pernas, Abdômen, Cardio)
- Lista de exercícios com informações detalhadas

### 2. **Seleção de Exercícios**

- Adicionar/remover exercícios do treino personalizado
- Contador visual de exercícios selecionados
- Modal com exercícios selecionados
- Funcionalidade para limpar toda a seleção

### 3. **Detalhes dos Exercícios**

- Modal com informações completas:
  - Nome do exercício
  - Grupo muscular trabalhado
  - Equipamento necessário
  - Nível de dificuldade
  - Instruções detalhadas

### 4. **Integração com o App**

- Novo botão "MONTE SEU TREINO" na tela inicial
- Navegação integrada ao sistema de rotas
- Controller registrado no sistema de injeção de dependências

## Arquivos Criados/Modificados

### Novos Arquivos:

1. `lib/model/exercicio_model.dart` - Modelo de dados dos exercícios
2. `lib/controller/montetreino_controller.dart` - Lógica de negócio
3. `lib/view/montetreino_view.dart` - Interface da tela

### Arquivos Modificados:

1. `pubspec.yaml` - Adicionado pacote `http: ^1.1.0`
2. `lib/main.dart` - Registrado controller e nova rota
3. `lib/view/home_view.dart` - Adicionado botão "Monte seu Treino"

## API Utilizada

**API Ninjas - Exercises API**

- Endpoint: `https://api.api-ninjas.com/v1/exercises`
- Retorna exercícios variados com informações detalhadas
- Sistema de backup com 8 exercícios pré-definidos

## Funcionalidades Técnicas

### Controller (MontetreinoController)

- **Gerenciamento de Estado**: Usando ChangeNotifier para reatividade
- **Filtros**: Por grupo muscular com tradução para português
- **Seleção**: Lista de exercícios selecionados para o treino
- **API**: Integração com HTTP requests e tratamento de erros

### View (MonteTreinoView)

- **UI Responsiva**: Adaptada ao design do app
- **Animações**: FloatingActionButton animado, loaders
- **Modals**: Bottom sheets para detalhes e exercícios selecionados
- **Filtros Visuais**: Chips horizontais para seleção de músculo

### Model (ExercicioModel)

- **Serialização JSON**: fromJson e toJson implementados
- **Validações**: Tratamento de campos nulos
- **Equalidade**: Comparação por ID para evitar duplicatas

## Como Usar

1. **Acesso**: Na tela inicial, clique em "MONTE SEU TREINO"
2. **Filtrar**: Use os chips horizontais para filtrar por grupo muscular
3. **Explorar**: Toque em um exercício para ver detalhes completos
4. **Selecionar**: Use os botões + para adicionar exercícios ao treino
5. **Gerenciar**: Use o ícone de lista para ver exercícios selecionados
6. **Finalizar**: Confirme o treino com o botão "Finalizar"

## Próximas Melhorias Sugeridas

1. **Persistência**: Salvar treinos criados no dispositivo
2. **Séries/Repetições**: Permitir definir séries e repetições para cada exercício
3. **Imagens**: Adicionar imagens dos exercícios
4. **Histórico**: Manter histórico de treinos criados
5. **Compartilhamento**: Compartilhar treinos criados
6. **Favoritos**: Marcar exercícios como favoritos
7. **Busca**: Campo de busca por nome do exercício
8. **Cronômetro**: Integrar cronômetro para intervalos entre exercícios
