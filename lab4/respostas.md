# Por que o valor no waveform é apresentado como X para os primeiros dois nanosegundos de sua simulação?
### Porque ele não tem nenhum valor definido, não foi inicializado.
# Por que ele é atualizado para 0 após 2 ns?
### Porque após 2ns ocorre uma subida de clock, e nesse instante o reset está em nivel logico alto
# Ao contrário, no contador mod-4 o valor do waveform inicia em 0; Por que?
### Porque no próprio módulo do contador o value já é inicializado como 2'b00.