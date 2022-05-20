# Paralelismo com GPU

Neste último projeto, vamos explorar os mecanismos de paralelismo multicore com GPU. Para tanto, vamos considerar a implementação da busca exaustiva que vimos, na análise realizada 
no relatório parcial, ter o desempenho bastante comprometido quando trabalhamos com tamanhos de sequencias de DNA muito grandes.

Na busca exaustiva, existe um procedimento básico que é realizado para cada par de subsequencias que estão sendo analisadas: cálculo do score. Relembrando o algoritmo de Smith-Waterman, nós temos que o score de alinhamento entre duas sequências S1 e S2 é dado por:

$$ 
S_{i,j} = max\begin{Bmatrix}
S_{i-1, j-1} + 2, & a_i = b_j \\ 
S_{i-1, j-1} - 1,  & a_i \neq b_j\\ 
S_{i-1, j} - 1 &  b_j = -\\
S_{i, j-1} - 1 &  a_i = -\\ 
0 & 
\end{Bmatrix}
$$ 

A operação `max` é associativa e comutativa, o que indica que nós podemos calcula de maneira paralelizada. Na prática, observe que o cálculo do score só depende da linha anterior, de modo que não é preciso ter toda a matriz carregada na memória, quando nosso objetivo é obter o melhor score. 

Podemos dividir esse cálculo de score em duas fases, a partir da linha anterior. Para isso, precisamos de duas estrututas de armazenamento, uma estrutura para armazenar o resultado do cálculo da linha anterior, e uma estrutura para receber temporariamente o resultado (primeira fase), e posteriormente ser atualizada (segunda fase).


A primeira fase poderia ser chamada de $S_{temp}$ e poderia ser calculada da seguinte maneira:

$$ 
S_{temp}(i,j) = max\begin{Bmatrix}
S_{i-1, j-1} + 2, & a_i = b_j \\ 
S_{i-1, j-1} - 1,  & a_i \neq b_j\\ 
S_{i, j-1} - 1 &  b_j = -\\
0 & 
\end{Bmatrix}
$$ 

Você pode implementar essa primeira fase como uma transformação. A segunda fase seria então fazer calcular o máximo entre $S_{temp}$ e a lateral direita:

$$ 
S_{i,j} = max\begin{Bmatrix}
S_{temp}(i,j) & \\ 
S_{temp}(i-1, j) - 1 &  \\
0 & 
\end{Bmatrix}
$$ 

Dessa forma, podemos:


<ul>
  <li>  usar thrust::transform para calcular a primeira fase e armazenar em uma estrutura temporaria o seu resultado
  <li> podemos usar thrust::inclusive_scan para atualizar o resultado temporário obtido na fase anterior
</ul>

O procedimento acima calcula, de maneira paralela, o score entre duas sequencias S1 e S2. Porém, quantos pares de sequencias podemos ocupar simultaneamente a GPU ? Este é o
 desafio que deverá ser resolvido neste projeto. Lembre-se que você não precisa armazenar a matriz inteira na GPU. Como mostramos no algoritmo acima, a última linha da matriz é necessária. Você também deve buscar formas de realizar o cálculo entre múltiplos pares. Assim, seu código não deve apenas ser otimizado para obter o score, mas calcular o score entre diversos pares simultaneamente. 


O que entregar:

<ul>
  <li> código-fonte da implementação exaustiva e da implementação paralela de GPU. A implementação paralela deverá seguir o cálculo do score descrito acima e, adicionalmente, 
    conter a implementação da estratégia de ocupação da GPU pelas sequencias. 
  <li> arquivos de testes utilizados
  <li> pequeno relatório descrevendo a estratégia usada para ocupação da GPU
  <li> resultados dos testes
</ul>

Um detalhe importante é que, como agora estamos trabalhando com paralelismo em GPU, os tamanhos dos arquivos de testes precisam ser bem maiores como em OpenMP. Muitas vezes, os resultados de speedup 
aparecem a partir de grandes instâncias do problema.

Caso você considere necessário, pode refatorar a sua implementação da busca exaustiva para poder explorar mais mecanismos da biblioteca TRUST em GPU.