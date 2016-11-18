### Manter contas
* Adicionar conta
    * Conta em banco, conta para pagamento: Nome ✔, ícone
    * Cartão de crédito: Nome ✔, ícone, data de fechamento ✔,
    data de vencimento ✔, taxa de juros ✔
* Editar conta (Mesma coisa)
* Visualizar contas
    * Contas em banco ✔, contas para pagamento ✔, cartões de crédito ✔
    * Ícones das contas
    * "Nenhuma conta encontrada"
* Atributo virtual "saldo"
    * Soma dos recebimentos menos a soma dos gastos não pagos

### Manter recebimentos

### Manter gastos
* Atributo virtual "pago"
    * Só fará sentido se a conta for de pagamentos
    * Condição: o gasto que refere a este deve ter um valor igual
      ao valor desse gasto na data do gasto referido.
        * Também é validação para o gasto referido caso esteja
          presente
* Adicionar gasto
    * Nome, conta, valor, data
    * Opcional: vencimento, multa, taxa de juros
    * Opcional: gasto que esse gasto paga
        * Valor desse gasto ficará atrelado ao valor do gasto
          na data de pagamento. Não poderá ser recorrente
    * Para transformar em recorrente: número de meses 

### Manter gastos recorrentes

### Manter recebimentos recorrentes

### Manter transferências
* Adicionar transferência
    * Conta de fonte, conta de destino, valor, data, descrição,
    anexo

### Manter categorias

### Manter usuários
* Cadastrar usuário
    * Formulário básico ✔
    * Envio de email
* Esqueci minha senha
    * Formulário básico
    * Envio de email
* Login ✔
    * Formulário básico ✔
* Edição de perfil
    * Formulário básico

### Manter transações
* Visualizar transações
    * Lista em ordem cronológica reversa ✔
    * Filtragem por período
    * Link para editar transação
    * Diferenciar transações passadas de futuras
    * Exibir saldo das contas
    * Exibir link para gasto/recebimento recorrente
* Adicionar transação (popup)
    * Link para Recebimento ✔
    * Link para Gasto ✔
    * Link para Transferência ✔
    * Ícones
* Editar transação (popup)
    * Descrição, Data, Valor, Conta
    * Caso o gasto ou recebimento faça parte de uma transferência,
    editar a transação e propagar as alterações
* Exibir anexo da transferência
        
