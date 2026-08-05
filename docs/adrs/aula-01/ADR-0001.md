# ADR-0001: Mitigação de Falhas de Escalabilidade e Desempenho

## Status

Proposto

## Contexto

O sistema vem apresentando degradação de desempenho e risco de indisponibilidade á medida que o volume de usuários e dados cresce. Uma análise dos incidentes e pontos de risco identificou problemas recorrentes em diferentes níveis de gravidade, listados abaixo em ordem crescente do impacto:

O crescimento do negócio torna esses riscos cada vez mais prováveis de se materializar, e sua ocorrência tem impacto direto em receita, reputação e confiança dos clientes. É necessário definir uma estratégia arquitetural para mitigar esses riscos de forma priorizada.

## Decision Drivers (Motivadores da Decisão)

- Minimizar indisponibilidade e degradação perceptível pelo usuário
- Priorizar correções por relação custo/impacto, não apenas por complexidade técnica
- Evitar retrabalho arquitetural futuro (soluções paliativas que geram nova dívida técnica)
- Manter capacidade de evolução incremental, sem exigir reescrita completa do sistema
- Viabilizar observabilidade contínua para identificar novos gargalos antes que se tornem incidentes

## Opções Consideradas

### Opção A — Correções pontuais reativas
Resolver cada problema apenas quando ele causar um incidente em produção.

- **Prós:** menor esforço imediato, não exige planejamento antecipado
- **Contras:** custo de correção emergencial é maior; risco de dano reputacional; problemas de gravidade crítica (SPOF, cascading failure) não podem ser tratados reativamente sem colocar o negócio em risco
### Opção B — Reescrita completa da arquitetura (big bang)
Redesenhar o sistema do zero com arquitetura distribuída, resiliente e escalável desde a concepção.

- **Prós:** resolve a raiz de todos os problemas estruturais de uma vez
- **Contras:** alto custo, alto risco, longo tempo sem entregar valor novo ao negócio; comum falhar por escopo excessivo
### Opção C — Mitigação priorizada e incremental (escolhida)
Tratar os problemas por ordem de gravidade e probabilidade de ocorrência, aplicando correções incrementais sem interromper a evolução do produto.

- **Prós:** equilíbrio entre risco e esforço; entrega valor de forma contínua; permite validar cada mudança isoladamente
- **Contras:** exige disciplina de priorização contínua e rastreamento de dívida técnica
## Decisão

Adotar a **Opção C — Mitigação priorizada e incremental**, seguindo a seguinte ordem de tratamento:

1. **Gravidade Crítica primeiro** (item 4): eliminar Single Points of Failure através de redundância (réplicas de banco, múltiplas instâncias atrás de load balancer) e failover automático; implementar circuit breakers para conter cascading failures; revisar políticas de auto-scaling com base em testes de carga realistas.
2. **Gravidade Alta em seguida** (item 3): desacoplar estado do monólito para permitir escalonamento horizontal; tornar consumidores de fila elásticos (auto-scaling baseado em profundidade da fila); implementar rate limiting (token bucket) em todas as APIs públicas.
3. **Gravidade Média** (item 2): revisar e criar índices com base em análise de `EXPLAIN ANALYZE`; dimensionar connection pools com base em testes de carga; migrar sessão para armazenamento distribuído (ex: Redis).
4. **Gravidade Baixa** (item 1): tratados de forma contínua pelo time de desenvolvimento, sem necessidade de esforço coordenado — resolvidos no fluxo normal de manutenção e code review.
Cada mitigação será acompanhada de métricas de observabilidade (latência, throughput, taxa de erro, uso de recursos) para validar a eficácia da correção antes de considerá-la concluída.

## Consequências

### Positivas
- Redução progressiva e mensurável do risco de indisponibilidade
- Priorização clara evita que esforço seja desperdiçado em problemas de baixo impacto enquanto riscos críticos permanecem abertos
- Cada mudança é validável isoladamente, reduzindo risco de regressão
- Cria uma cultura de observabilidade e revisão arquitetural contínua

### Negativas / Trade-offs
- Problemas de gravidade baixa e média podem persistir por mais tempo, exigindo comunicação clara com stakeholders sobre o cronograma
- Exige investimento em testes de carga e chaos engineering, que têm custo de implementação
- Correções incrementais em sistemas com forte acoplamento (ex: monólito) podem exigir refatorações intermediárias antes de atingir o estado desejado

## Métricas de Sucesso

- Redução do número de incidentes de gravidade Alta/Crítica em produção
- Aumento da taxa de cache hit e do índice de queries otimizadas (via `EXPLAIN`)
- Tempo médio de recuperação (MTTR) reduzido após implementação de failover automático
- Ausência de degradação de serviço para múltiplos clientes durante picos de tráfego de um único cliente (validação do rate limiting)

## Referências

- Análise interna de incidentes e mapeamento de dependências arquiteturais
- Práticas de Chaos Engineering (ex: Chaos Monkey, Netflix)
- Casos públicos de incidentes de escalabilidade (ex: falha em cascata AWS S3 us-east-1, 2017)

---
*Autor(es): João Pedro Moreira, Matheus Borges, Octávio Freire*
*Data: 03/08/2026*
