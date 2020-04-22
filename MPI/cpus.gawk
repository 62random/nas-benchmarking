BEGIN {FS="[ ]+";}
NR == 3 && NF == 12 {for(i=3; i <= NF; i++) {header[i+1] = $i;}}
NR > 3 && NF == 12 && ($3 != "CPU" && $3 != "all"){
  data[$3, 0]++; #indice 0 contém número de ticks que foram contados por CPU
  CPU[$3];
  for(i=4; i <= NF; i++) { #coleta de dados sem os dados irrelevantes (soma acumulada já)
    data[$3, i-3] += $i;
  }
}
END{
  for (i in header){ #imprimir header
    printf "%s;",header[i];
  };
  print "";

  for (id in CPU){
    printf "%d;",id; #identificador do CPU
    tick_count = data[id, 0]; #número de ticks
    for(i=1; i < 10; i++){
      printf "%f;",data[id, i] / tick_count; #total dos dados precalculado agora apenas necessário dividir
    }
    print "";
  };
}
