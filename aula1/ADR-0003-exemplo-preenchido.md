# ADR-0003: Uso de mensageria assíncrona para notificações de pagamento

## Status
Aceito

## Contexto
O envio de notificações (e-mail, SMS, push) após uma transação não pode bloquear
a resposta da API de pagamentos ao cliente — o cliente precisa de confirmação
rápida de que o pagamento foi processado. Em horários de pico, o sistema pode
precisar enviar centenas de notificações por segundo, e uma eventual falha ou
lentidão no serviço de envio (ex.: provedor de e-mail fora do ar) não pode
derrubar ou atrasar o fluxo principal de pagamento.

## Decisão
Vamos publicar um evento de "pagamento confirmado" em uma fila de mensagens
(RabbitMQ) sempre que uma transação for concluída com sucesso. Um serviço
consumidor separado, dedicado a notificações, processa essa fila de forma
assíncrona e dispara os envios (e-mail, SMS, push) conforme a preferência
de cada cliente.

## Alternativas Consideradas
- **Chamada síncrona direta ao serviço de notificação**: descartada porque
  acoplaria o tempo de resposta da API de pagamentos à disponibilidade e
  velocidade do serviço de notificação, algo inaceitável para a experiência
  do cliente.
- **Job agendado (polling) verificando pagamentos pendentes de notificação**:
  descartada por introduzir atraso desnecessário (o job rodaria em intervalos
  fixos) e maior complexidade de controle de estado.

## Consequências
- A API de pagamentos responde ao cliente sem esperar o envio da notificação,
  reduzindo a latência percebida na confirmação do pagamento.
- Introduz uma dependência de infraestrutura nova (broker de mensagens), que
  passa a exigir monitoramento e alertas próprios.
- Notificações podem ser processadas com poucos segundos de atraso em picos
  de carga — avaliado como aceitável para este caso de uso.
- Facilita adicionar novos canais de notificação no futuro (ex.: WhatsApp)
  sem qualquer alteração na API de pagamentos — basta o consumidor da fila
  passar a tratar o novo canal.

---
*Autor(es): Equipe de Arquitetura*
*Data: 15/09/2026*
