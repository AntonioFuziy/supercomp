#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <chrono>
#include <cstdlib>
#include <algorithm>
 #include <thrust/host_vector.h>
 #include <thrust/device_vector.h>
 #include <thrust/generate.h>
 #include <thrust/functional.h>
 #include <thrust/copy.h>
//INSIRA AS IMPORTACOES NECESSARIAS DA THRUST
#include <cmath>
#include <random>

using namespace std::chrono;

void reportTime(const char* msg, steady_clock::duration span) {
  auto ms = duration_cast<milliseconds>(span);
  std::cout << msg << " - levou - " <<
  ms.count() << " milisegundos" << std::endl;
}

struct square
{
  __host__ __device__
  float operator()(const int& x) {
    return x*x;
  }
};

// CRIE UMA FUNCTOR PARA CALCULAR A SQUARE

 // IMPLEMENTE O CALCULO DA MAGNITUDE COM THRUST
float magnitude(thrust::device_vector<int> a, thrust::device_vector<int> b) {
  float result;
  // ... add Thrust calls
  // AQUI VAO AS CHAMADAS THRUST 
  thrust::transform(
    a.begin(), a.end(), 
    b.begin(), b.end(),
    square(a)
  );

  result = std::sqrt(thrust::reduce(b.begin(), b.end(), (float) 0, thrust::plus<float>()));

  return result;
};

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << argv[0] << ": numero invalido de argumentos\n"; 
    std::cerr << "uso: " << argv[0] << "  tamanho do vetor\n"; 
    return 1;
  }
  int n = std::atoi(argv[1]); //numero de elementos
  steady_clock::time_point ts, te;

  // Faça um  vector em thrust 

  thrust::device_vector<int> d_a(n);
  thrust::device_vector<int> d_b(n);

  // inicilize o  vector
  ts = steady_clock::now();

  thrust::generate(d_a.begin(), d_a.end(), std::rand);

  te = steady_clock::now();
  reportTime("Inicializacao", te - ts);

  // Calcule a magnitude do vetor
  ts = steady_clock::now();
  float len = magnitude(d_a, d_b);
  te = steady_clock::now();
  reportTime("Tempo para calculo", te - ts);


  std::cout << std::fixed << std::setprecision(4);
  std::cout << "Magnitude : " << len << std::endl;
}
