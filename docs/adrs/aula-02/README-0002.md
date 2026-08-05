Aplicativo de Reserva da Cantina

| Atributo | Detalhe |
| :--- | :--- |
| **Status** | Aceito |
| **Data** | 04/08/2026 |
| **Autores** | João Pedro Moreira Costa, Matheus Borges, Octávio Freire |

---

## Contexto e Problema
A cantina do campus enfrenta longas filas no almoço, levando alunos a desistirem de comprar refeições. O projeto precisa considerar restrições operacionais (1 pessoa no caixa e 2 na cozinha) e indefinições da coordenação sobre pagamentos e regras para faltas.

## Decisão Tomada
Desenvolver o aplicativo focado **apenas na reserva antecipada da refeição**, mantendo o pagamento no caixa presencial e sem cobrança de taxas por não-comparecimento na primeira versão.

## O que você vai encontrar nesta ADR
* **Mapa de Contexto:** Relação entre os participantes (aluno, equipe da cantina, coordenação) e a estrutura física existente.
* **Decisões Arquiteturais (Princípios de Hooker):**
  * *Reserva exclusiva no app* — Aplicação do Princípio 2 (Fazer apenas o necessário).
  * *Foco na redução de filas* — Aplicação do Princípio 1 (O software existe para gerar valor).
  * *Sem cobrança de multas* — Aplicação do Princípio 2 (Evitar funcionalidades desnecessárias).
* **Consequências do Projeto:** Análise dos pontos positivos (rapidez na entrega e baixo custo) e negativos (fluxo no caixa ainda necessário e risco de desperdício).

