# Design-de-Software
Repositório de atividade curricular Design de Software.
## 1. Identificação

- **Disciplina/Atividade:** Design de Gráfico - Atividade 1
- **Autor:** João Pedro Moreira Costa, Matheus Borges, Octávio Freire
- **Data:** 04/08/2026
- **Linguagem:** Markdown

## 2. Objetivo

Solucoes para uma empresa cujo sistema apresenta falhas de escalabilidade e desempenho.


## 3. Como o problema foi resolvido
A estrategia adotada focou em garantir **estabilidade, redundancia e eficiencia de recursos**, abordando as falhas do sistema em quatro frentes principais:

**Otimizacao de Cache (Gravidade Baixa):** Reconfiguramos o ciclo de vida do cache (Ajuste de TTL) e implementamos invalidação reativa ao alterar preços/promoções, garantindo que consultas repetitivas sejam resolvidas na memória antes de atingirem o banco de dados.
**Gestao e Fila de Conexoes (Gravidade Media):** Centralizamos o tráfego de banco com um *proxy* (gerenciador de conexões), reduzimos o tempo de retenção no código para o milissegundo da gravação e enfileiramos o processamento de acessos via mensageria em segundo plano para suavizar picos de acessos em datas críticas.
**Protecao de API via Rate Limiting (Gravidade Alta):** Implementamos regras de limitação de tráfego (*rate limiting/throttling*) no nivel do API Gateway por IP e chave de acesso, bloqueando requisições abusivas ou loops infinitos de clientes antes que afetem os demais usuários.
**Eliminacao de Ponto Unico de Falha (Gravidade Critica):** Criamos uma arquitetura de alta disponibilidade com replicação de dados em tempo real, *failover* automatizado para promocao do banco secundario em caso de queda, e testes diarios automatizados de restauracao de backups (*Disaster Recovery*).



**Estruturas de dados / algoritmos usados:**
* **Filas (FIFO - First In, First Out):** Utilizadas no sistema de mensageria para organizar as requisições de checkout e processá-las em segundo plano por ordem de chegada.
* **Tabelas Hash (Hash Maps):** Utilizadas pela solução de cache (Redis) para garantir busca de dados em tempo constante $O(1)$ usando chave-valor.
* **Algoritmo Token Bucket:** Utilizado pelo API Gateway para a lógica de *rate limiting*, controlando o fluxo de requisições por cliente.
* **Reaproveitamento de Recursos (Pooling):** Utilizado pelo Proxy de Banco para gerenciar e reusar um número fixo de conexões abertas sem sobrecarregar o servidor.


## 6. Limitações conhecidas

O que você sabe que não está tratado ou que poderia falhar?
* **Latência em Mensageria:** O processamento assíncrono melhora o desempenho, mas adiciona um pequeno atraso (latência) até que a transação seja confirmada no banco principal.
* **Consistência Eventual:** Durante atualizações de preço, pode haver uma fração de segundo em que o cache e o banco fiquem brevemente desalinhados (*eventual consistency*).
* **Custo e Complexidade de Infraestrutura:** A adição de réplicas de banco, proxies e mensageria eleva o custo mensal de nuvem e exige monitoramento constante.
* **Escopo Fictício:** O modelo assume um tráfego simulado, não tendo sido testado com volumes de dados reais de petabytes ou sob cenários de indisponibilidade total de região (*multi-region failure*).
