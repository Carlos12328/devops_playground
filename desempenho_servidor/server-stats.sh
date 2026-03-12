#!/bin/bash

# ---- Funções ----

mostrar_cabecalho() {
    
    echo "============================"
    echo "Estatisticas Servidor"
    date "+%Y-%m-%d %H:%M:%S"
    echo "============================"
    echo ""

}

mostrar_cpu() {
    # -----------------------------------------------------------------------------
    # Captura o uso de CPU em um snapshot único e imprime "CPU Usada" e "CPU Livre".
    #
    # Como funciona:
    # 1) top -bn1          → Executa o top em modo batch (-b), uma vez (-n1).
    # 2) grep "Cpu(s)"     → Filtra apenas a linha que resume o uso da CPU.
    # 3) awk               → Lê a linha e calcula:
    #      - $8 = valor "id" (idle), isto é, CPU ociosa em %.
    #      - used = 100 - $8  → CPU Usada (soma de user+system+outros).
    #      - free = $8        → CPU Livre (idle).
    #    Em seguida, formata a saída: "CPU Usada: X.X% | CPU Livre: Y.Y%".
    #
    # Observações:
    # - Este parser assume o layout padrão do top onde o campo idle (id) é o $8.
    #   Se o layout/localização do top variar, ajuste o índice do campo.
    # -----------------------------------------------------------------------------

    top -bn1 | grep "Cpu(s)" | awk '{used=100-$8; free=$8; printf "CPU Usada: %.1f%% | CPU Livre: %.1f%%\n", used, free}'
    
}

mostrar_memoria() {
    # -----------------------------------------------------------------------------
    # Captura o uso de memória em um snapshot único e imprime memória usada/total.
    #
    # Como funciona:
    # 1) top -bn1          → Executa o top em modo batch (-b), uma vez (-n1).
    # 2) awk '/Mem :/'     → Filtra apenas a linha "Mem" do top (ignora Swap).
    # 3) Extrai os campos:
    #      - $4 = total (em MiB)
    #      - $8 = usada  (em MiB)
    #    Converte ambos para GiB dividindo por 1024.
    #    Calcula o percentual usado e formata a saída:
    #    "Memória: X.XG usada / Y.YG total (Z%)".
    #
    # Observações:
    # - Este parser assume o layout atual do top onde os valores total/usado
    #   aparecem nas posições $4 e $8. Se mudar, ajuste os índices.
    # -----------------------------------------------------------------------------

    top -bn1 | awk '/Mem :/ {printf "Memória: %.1fG usada / %.1fG total (%.0f%%)\n", $8/1024, $4/1024, 100*$8/$4}'
}

mostrar_disco() {
    # -----------------------------------------------------------------------------
    # Mostra o uso de disco do Linux (/) e do Windows (C:) de forma formatada.
    #
    # Como funciona:
    # 1) df -hT              → Lista os sistemas de arquivos com tamanho legível (-h) e tipo (-T).
    # 2) awk '$NF=="/"'      → Filtra a linha cujo ponto de montagem (última coluna, $NF) é "/".
    #    Formata como: "Disco Linux: <usado> / <total> (<%>)".
    # 3) awk '$NF=="/mnt/c"' → Filtra a linha montada em "/mnt/c" (disco C: do Windows no WSL).
    #    Formata como: "Disco Windows: <usado> / <total> (<%>)".
    #
    # Observações:
    # - Usamos $NF (último campo) por ser mais robusto: o ponto de montagem sempre é a última coluna.
    # - Ignoramos entradas temporárias/virtuais (tmpfs/overlay), focando apenas em "/" e "/mnt/c".
    # -----------------------------------------------------------------------------

    df -hT | awk '$NF=="/"{printf "Disco Linux: %s usado / %s total (%s)\n", $4, $3, $6}'
    df -hT | awk '$NF=="/mnt/c"{printf "Disco Windows: %s usado / %s total (%s)\n", $4, $3, $6}'
}

mostrar_top_cpu() {
    # -----------------------------------------------------------------------------
    # Mostra os 5 processos que mais consomem CPU.
    #
    # Como funciona:
    # 1) ps aux --sort=-%cpu → lista todos os processos ordenados por %CPU (maior primeiro).
    # 2) head -n 6           → mantém o cabeçalho + os 5 primeiros processos.
    # 3) awk                 → formata e alinha as colunas:
    #       $1  = USER
    #       $2  = PID
    #       $3  = %CPU
    #       $4  = %MEM
    #       $11 = COMMAND (nome do processo)
    # -----------------------------------------------------------------------------

    echo ""
    echo "Top 5 processos por uso de CPU"
    echo "--------------------------------"

    ps aux --sort=-%cpu | head -n 6 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1,$2,$3,$4,$11}'

}


mostrar_top_mem() {
    # -----------------------------------------------------------------------------
    # Mostra os 5 processos que mais consomem memória.
    #
    # Como funciona:
    # 1) ps aux --sort=-%mem → lista todos os processos ordenados por %MEM (maior primeiro).
    # 2) head -n 6           → mantém o cabeçalho + os 5 primeiros processos.
    # 3) awk                 → formata e alinha as colunas:
    #       $1  = USER
    #       $2  = PID
    #       $3  = %CPU
    #       $4  = %MEM
    #       $11 = COMMAND (nome do processo)
    # -----------------------------------------------------------------------------

    echo ""
    echo "Top 5 processos por uso de memória"
    echo "--------------------------------"
    ps aux --sort=-%mem | head -n 6 | awk '{printf "%-10s %-8s %-6s %-6s %s\n", $1,$2,$3,$4,$11}'

}


# ---- Execução principal ----

mostrar_cabecalho
mostrar_cpu
mostrar_memoria
mostrar_disco
mostrar_top_cpu
mostrar_top_mem