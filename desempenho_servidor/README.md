# Desafio 01 — Estatísticas do Servidor

Script Bash que coleta e exibe estatísticas de desempenho de qualquer servidor Linux.

## Requisitos

- Linux (qualquer distribuição)
- Bash
- Comandos padrão: `top`, `df`, `ps` (presentes em qualquer distro)

## Como executar

```bash
chmod +x server-stats.sh
./server-stats.sh
```

## O que o script exibe

- Data e hora da execução
- Uso de CPU (usada vs livre)
- Uso de memória (usada vs total, com percentual)
- Uso de disco (usado vs total, com percentual)
- Top 5 processos por consumo de CPU
- Top 5 processos por consumo de memória

## Exemplo de saída

```
============================
Estatisticas Servidor
2026-03-12 13:36:26
============================

CPU Usada: 3.5% | CPU Livre: 96.5%
Memória: 1.4G usada / 7.6G total (18%)
Disco Linux: 9.7G usado / 1007G total (2%)

Top 5 processos por uso de CPU
--------------------------------
USER       PID      %CPU   %MEM   COMMAND
kdu        1234     5.2    1.0    node
...

Top 5 processos por uso de memória
--------------------------------
USER       PID      %CPU   %MEM   COMMAND
kdu        1234     5.2    9.0    node
...
```
