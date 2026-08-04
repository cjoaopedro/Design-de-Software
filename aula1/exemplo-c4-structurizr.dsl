workspace "NimbusPay" "Exemplo de Diagrama C4 — Contexto e Contêineres" {

    model {
        cliente = person "Cliente" "Usuário final que realiza pagamentos pelo app"
        operador = person "Operador Interno" "Equipe de suporte e operações da NimbusPay"

        nimbuspay = softwareSystem "NimbusPay" "Plataforma de pagamentos digitais" {
            web = container "Painel Web" "Interface de administração e suporte" "React"
            api = container "API de Pagamentos" "Recebe, valida e processa transações" "Java / Spring Boot"
            bancoDados = container "Banco de Dados" "Armazena contas, transações e histórico" "PostgreSQL"
            filaMensagens = container "Fila de Notificações" "Processa envio assíncrono de notificações" "RabbitMQ"
        }

        bandeira = softwareSystem "Bandeira de Cartão" "Sistema externo de autorização de pagamentos"

        # Relacionamentos
        cliente -> api "Realiza pagamentos via app (HTTPS/JSON)"
        operador -> web "Administra contas e consulta transações"
        web -> api "Faz requisições via HTTPS/JSON"
        api -> bancoDados "Lê e grava dados via JDBC"
        api -> filaMensagens "Publica eventos de pagamento confirmado"
        api -> bandeira "Solicita autorização de pagamento via API"
    }

    views {
        systemContext nimbuspay "DiagramaContexto" {
            include *
            autoLayout
            description "Visão de contexto: a NimbusPay e quem interage com ela."
        }

        container nimbuspay "DiagramaContainer" {
            include *
            autoLayout
            description "Visão de contêiner: os blocos internos que compõem a NimbusPay."
        }

        theme default
    }

}

# Como usar este arquivo:
# 1. Acesse https://structurizr.com/dsl (editor online, gratuito, sem necessidade de instalar nada)
#    ou instale o Structurizr Lite (https://docs.structurizr.com/lite) para rodar localmente.
# 2. Cole todo este conteúdo no editor.
# 3. Os dois diagramas (Contexto e Contêiner) são gerados automaticamente a partir do texto.
# 4. Para adaptar a outro projeto: troque os nomes de "person", "softwareSystem" e "container",
#    e ajuste os relacionamentos (as linhas com "->") para refletir o sistema real.
