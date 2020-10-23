# 12 - Introdução a OpenMP

OpenMP é uma tecnologia de computação multi-core usada para paralelizar programas. Sua principal vantagem é oferecer uma transição suave entre código sequencial e código paralelo. 

## Primeiros passos

Nesta parte do roteiro usaremos 4 chamadas do OpenMP para criar nossas primeiras threads.

1. `#pragma omp parallel` cria um conjunto de threads. Deve ser aplicado acima de um bloco de código limitado por `{  }`
2. `int omp_get_num_threads();` retorna o número de threads criadas (dentro de uma região paralela)
3. `int omp_get_max_threads();` retorna o número de máximo de threads (fora de uma região paralela)
4. `int omp_get_thread_num();` retorna o id da thread atual (entre 0 e o valor acima, dentro de uma região paralela)

O código abaixo (*exemplo1.cpp*) ilustra como utilizar OpenMP para criar um conjunto de *threads* que rodam em paralelo.

```cpp
#pragma omp parallel 
{
    std::cout << "ID:" << omp_get_thread_num() << "/" << 
                        omp_get_num_threads() << "\n";
}
```

Vamos agora fazer alguns experimentos com esse exemplo básico para entender como OpenMP funciona. 

!!! example
    Compile o programa de exemplo usando a seguinte linha de comando e rode-o.

    > `$ g++ -O3 exemplo1.cpp -o exemplo1 -fopenmp`

!!! question short
    O OpenMP permite alterar o número máximo de threads criados usando a variável de ambiente `OMP_NUM_THREADS`. Rode `exemplo1` como abaixo.

    > `OMP_NUM_THREADS=2 ./exemplo1` 

    Quantas threads foram criadas?
    
!!! question short 
    Rode agora sem a variável de ambiente. Qual é o valor padrão assumido pelo OpenMP? É uma boa ideia usar mais threads que o valor padrão?

A utilização de `OMP_NUM_THREADS` ajuda a realizar testes de modo a compreender os ganhos de desempenho de um programa conforme mais threads são utilizadas. 

Quando uma região paralela inicia são criadas `OMP_NUM_THREADS` *threads* e cada uma roda o bloco de código imediatamente abaixo de maneira independents.

!!! question short
    No trecho abaixo, quantas cópias da variável `temp` são criadas? E da variável `res`? Responda usando o número de cores da máquina como referência.

    ```cpp
    double res = 0;
    #pragma omp parallel 
    {
        double temp = 10;
        res *= temp;
    }
    ```

    ??? details "Resposta"
        Só uma variável `res` existe, pois ela foi declarada fora da região paralela. Existem `N` cópias de `temp`, uma criada para cada *thread* existente.


!!! question short
    Você consegue prever o resultado do código abaixo? Se sim, qual sua saída? Se não, você consegue explicar o por que?

    ```cpp
    int res = 1;
    #pragma omp parallel 
    {
        for (int i = 0; i < 10000; i++) {
            res += 1;
        }
    }
    ```

!!! example
    Rode o código acima (arquivo *exemplo2.cpp*) e veja se suas expectativas se cumprem. Chame o professor se você se surpreender com o resultado.


!!! danger
    Nos dois exemplos acima as variáveis `res` eram usadas por múltiplas threads! Ou seja, cada thread possui uma **dependência** em relação a `res`. Escrever código sem levar em conta as dependências é um problema que será abordado nas próximas aulas. 

## Paralelismo de tarefas

Vamos agora criar *tarefas* que podem ser executadas em paralelo.

!!! tip "Definição"
    Uma **tarefa** é um bloco de código que é rodado de maneira paralela usando OpenMP. *Tarefas* são alocadas para cada uma das *threads* criadas em um região paralela. Não existe uma associação **1-1** entre *threads* e *tarefas*. Posso ter mais *tarefas* que *threads* e mais *threads* que *tarefas*.

Veja abaixo um exemplo de criação de tarefas.

```cpp
#pragma omp parallel 
{
    #pragma omp task 
    {
        std::cout << "Estou rodando na tarefa " << omp_get_thread_num() << "\n";
    }
}
std::cout << "eu só rodo quanto TODAS tarefas acabarem.\n";
```

!!! question short
    O exemplo acima cria quantas tarefas, supondo que `OMP_NUM_THREADS=4`? 

Para controlar a criação de tarefas em geral usamos a diretiva `master`, que executa somente na thread de índice `0`. 

```cpp
#pragma omp parallel 
{
    #pragma omp master 
    {
        std::cout << "só roda uma vez na thread:" << omp_get_thread_num() << "\n";
        #pragma omp task 
        {
            std::cout << "Estou rodando na thread:" << omp_get_thread_num() << "\n";
        }
    }
}
```

!!! question short
    Quantas tarefas são criadas no exemplo acima? Elas rodam em qual thread? Responda somente lendo o código e depois confirme sua resposta rodando *exemplo3.cpp*. 

!!! question short
    Execute *exemplo3.cpp* diversas vezes. Os resultados são sempre iguais? Por que?

!!! example 
    Complete *exercicio1.cpp* criando duas tarefas. A primeira deverá rodar `funcao1` e a segunda `funcao2`. Salve seus resultados nas variáveis indicadas no código.

!!! question short
    Leia o código e responda. Quanto tempo o código sequencial demora? E o paralelo? Verifique que sua implementação está de acordo com suas expectativas.

## Problema prático

Vamos agora para um exemplo prático. O código *pi-numeric-integration.cpp* calcula o `pi` usando uma técnica chamada integração numérica. 

!!! question short
    Examine o arquivo acima. Onde haveriam oportunidades de paralelização?

!!! question short
    Suponha que você irá tentar dividir os cálculos do programa em duas partes. Como você faria isso?

!!! example
    Faça a divisão do cálculo do `pi` em duas tarefas. 
    
    * Sua primeira tarefa deverá guardar seu resultado na variável `res_parte1`. 
    * A segunda tarefa deverá guardar seu resultado na variável `res_parte2`. 
    * Você deverá somar os dois resultados após as tarefas acabarem.

!!! question short
    Meça o tempo do programa paralelizado e compare com o original. Verifique também que os resultados continuam iguais.