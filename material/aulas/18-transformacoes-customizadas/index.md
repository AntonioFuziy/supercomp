# 19 - Operações customizadas

Vamos trabalhar hoje com transformações customizadas. O último argumento de `thrust::transform` é a operação a ser realizada. Já usamos funções prontas com `thrust::plus<double>()` e `thrust::multiply<double>()`.  

Para criar nossas próprias operações usamos a seguinte sintaxe:

```.cpp
struct custom_transform
{
    // essas marcações indicam que o código deve ser compilado para CPU (host) 
    // e GPU (device)
    // IMPORTANTE: somente código com a marcação __device__ é compilado para GPU
    __host__ __device__
        double operator()(const double& x, const double& y) {
            // isto pode ser usado com um transform que usa dois vetores 
            // e coloca o resultado em um terceiro.
            
            // x é um elemento do primeiro vetor
            // y é o elemento correspondente do segundo vetor
            
            // o valor retornado é colocado no vetor de resultados
            
            // para fazer operações unárias basta receber somente um argumento.
        }
};
```

A operação acima seria aceita em um transform como o abaixo:


```cpp
thrust::device_vector<double> A, B, C;
thrust::transform(A.begin(), A.end(), B.begin(), C.begin(), custom_transform());
```

Note que os tipos dos vetores devem bater com os tipos declarados no `struct`. Por vezes precisamos receber parâmetros para a operação customizada funcionar. Um truque comum é adicionar atributos no `struct` usado como operação:

```cpp
struct T {
    int attr;

    T(int a): attr(a) {};

    // TODO: operação customizada aqui
};
```

O valor `attr` estará disponível para uso dentro da operação customizada. A linha `T(int a): attr(a) {}` declara o construtor do `struct T`. Ela faz com que o atributo `attr` seja inicializado com o valor do parâmetro `a`. Se houver mais de uma atribuição parâmetro - atributo é só usar `,` para separar as inicializações. Note que só podemos receber tipos básicos, então não daria para passar um `std::vector` como argumento.

Vamos agora usar esta nova sintaxe para escrever código mais sucinto (e complexo) em `thrust`. 

!!! example
    Faça uma nova implementação da variância, dessa vez usando uma operação customizada e com a chamada `transform_reduce`. 

    **Dica**: passe a média do vetor como parâmetro para seu `struct`.

!!! tip 
    Chamadas a GPU tem um custo fixo. Ao usar `transform_reduce` evitamos incorrer esse custo duas vezes. Também economizamos um vetor temporário que seria usado para guardar os elementos do somatório antes da operação `reduce`.
    

## Estruturas 2D - matrizes e imagens

Assim como na CPU, podemos representar imagens como um vetor "deitado". O acesso ao elemento `(i, j)` é feito como abaixo.

```cpp
img[i * width + j] = 10;
```

Logo, podemos guardar matrizes na GPU apesar de só temos vetores 1D: basta sempre fazer a conta acima para descobrir o elemento 1D a partir das coordenadas `(x,y)`.

!!! question short
    Como descobrir as coordenadas `(x,y)` a partir do índice 1D?
    
    ??? details "Resposta"
        Sendo `k` o índice 1D:
        ```
        y = k / largura
        x = k % largura
        ```

Vamos começar com um processamento de imagens bem simples: o limiar.

1. Se o ponto atual for maior que `127`, coloque na saída `255` (branco)
2. caso contrário, coloque na saída `0` (preto)


!!! question short
    Retome os arquivos `imagem.h/cpp` da [aula 13](https://insper.github.io/supercomp/aulas/13-paralelismo-dados/#exercicio-pratico). Quais dados você precisaria copiar para a GPU? Quais dados seriam copiados de volta para a CPU ao finalizar?
    
    ??? details "Resposta"
        É necessário copiar o vetor pixels e o tamanho total da imagem para a GPU, o que significa que teremos um vetor para a imagem de entrada. O vetor de saída também deve ser criado na GPU, mas não precisa ser inicializado. Após o cálculo ele deverá ser copiado de volta para a CPU.
    
Podemos copiar dados de ponteiros "crus" para a GPU com uma sintaxe parecida com os nossos `host_vector`:

```cpp
int *dados; // possui N elementos
thrust::device_vector<int> dados_gpu(dados, dados + N);
```

!!! example
    Use uma transformação customizada para implementar o filtro do limiar. Use os arquivos examinados na pergunta anterior. 

A operação acima encaixa bem na `thrust` pois é ponto a ponto: cada processamento só leva em conta o valor do ponto atual. A maioria dos filtros, porém, usa informações da vizinhança de um ponto. Um exemplo é o *filtro de média* mostrado abaixo.

Dada uma imagem de entrada $I$, a imagem de saída $O$ é dada pela seguinte expressão.

$$
O[i, j] = \frac{I[i, j] + I[i-1, j] + I[i+1, j] + I[i, j-1] + I[i,j+1]}{5}
$$

Ambas as imagens tem o mesmo tamanho. Se o pixel acessado estiver fora da área válida da imagem ele deve ser considerado 0. 

Apesar da `thrust` nos permitir acessar os dados de cada iteração, o acesso a elementos arbitrários do vetor não é diretamente suportado. Apesar de ser possível fazer isto com iteradores e tuplas, vamos usar uma abordagem um pouco diferente: acessar o vetor diretamente e usar a `thrust` para fornecer ao nossa transformação customizada o índice a ser usado. Vejamos abaixo um exemplo (arquivo *raw_access.cu*):


```cpp
struct raw_access {
    double *ptr;

    raw_access (double *ptr) : ptr(ptr) {};

    __device__ __host__
    double operator()(const int &i) {
        return ptr[i] + 1;
    }
};

...
thrust::counting_iterator<int> iter(0);
raw_access ra(thrust::raw_pointer_cast(vec.data()));
thrust::transform(iter, iter+vec.size(), vec.begin(), ra);
...
```

No código acima nossa operação customizada recebe o vetor como parâmetro de criação do `struct`. O valor passado pelo `transform` agora é o **índice a ser preenchido no vetor de saída**. Para simplificar, em geral vamos entender que o vetor de entrada e o de saída são do mesmo tamanho. Ou seja, conseguimos escrever código em GPU trabalhando somente com ponteiros e índices. Código arbitrariamente complexo pode estar dentro do `operator()`, desde que seja retornado o valor a ser colocado no vetor de saída na posição `i`.


!!! danger
    No caso acima o vetor de entrada e saída eram o mesmo. Não há problema pois a operação só acessa o elemento `i`. Porém, se acessasse outros não conseguimos garantir a ordem das operações e os resultados seriam imprevisíveis. Na dúvida, sempre envie os dados para um vetor de saída diferente.
    

!!! example
    Implemente um programa `media_gpu` que faz o processamento descrito acima usando `thrust`. Seu programa deverá funcionar como abaixo. 


