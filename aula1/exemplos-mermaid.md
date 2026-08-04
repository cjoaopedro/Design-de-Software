# Exemplos de Diagramas em Mermaid

Mermaid é uma linguagem de diagramas em texto puro. Diferente do draw.io (que é
majoritariamente visual/manual), o Mermaid é escrito como código — o que significa
que pode ser versionado no Git junto com o resto do projeto, e renderiza
automaticamente no GitHub, GitLab, Notion e em várias IDEs (com extensão).

O draw.io continua útil quando você quer arrastar e soltar livremente, ou importar
formas prontas (ícones de nuvem, redes, etc.) — os dois se complementam.

Para visualizar qualquer um dos exemplos abaixo sem instalar nada, cole o bloco de
código (sem os ```mermaid) em https://mermaid.live


## 1. Diagrama C4 (nível Contexto) — mesmo exemplo da NimbusPay

```mermaid
C4Context
    title Diagrama de Contexto - NimbusPay

    Person(cliente, "Cliente", "Usuário que realiza pagamentos")
    System(nimbuspay, "NimbusPay", "Plataforma de pagamentos digitais")
    System_Ext(bandeira, "Bandeira de Cartão", "Autorização externa de pagamentos")

    Rel(cliente, nimbuspay, "Realiza pagamentos via app")
    Rel(nimbuspay, bandeira, "Solicita autorização via API")
```


## 2. Fluxograma de processo — fluxo de uma transação

```mermaid
flowchart TD
    A[Cliente inicia pagamento] --> B(API de Pagamentos)
    B --> C{Dados válidos?}
    C -->|Sim| D[Solicita autorização à bandeira]
    C -->|Não| E[Retorna erro ao cliente]
    D --> F{Autorizado?}
    F -->|Sim| G[(Grava transação no banco)]
    F -->|Não| E
    G --> H[[Publica evento na fila de notificações]]
```


## 3. Diagrama de sequência — comunicação entre componentes

```mermaid
sequenceDiagram
    participant Cliente
    participant API as API de Pagamentos
    participant Banco as Banco de Dados
    participant Bandeira as Bandeira de Cartão

    Cliente->>API: POST /pagamentos
    API->>Bandeira: Solicita autorização
    Bandeira-->>API: Autorizado
    API->>Banco: Grava transação
    Banco-->>API: OK
    API-->>Cliente: 201 Created
```


## 4. Diagrama de classes — modelagem de baixo nível

```mermaid
classDiagram
    class Pagamento {
        +String id
        +BigDecimal valor
        +StatusPagamento status
        +processar()
        +cancelar()
    }
    class Cliente {
        +String id
        +String nome
        +listarPagamentos()
    }
    class NotificacaoStrategy {
        <<interface>>
        +enviar(Pagamento p)
    }
    class NotificacaoEmail
    class NotificacaoSMS

    Cliente "1" --> "*" Pagamento : realiza
    NotificacaoStrategy <|.. NotificacaoEmail
    NotificacaoStrategy <|.. NotificacaoSMS
```

## Como adaptar para outro projeto
Troque os nomes dos participantes/classes/caixas e as setas de relacionamento —
a sintaxe de cada tipo de diagrama (C4Context, flowchart, sequenceDiagram,
classDiagram) permanece igual. Documentação completa: https://mermaid.js.org/
