#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/extrema.h>
#include <thrust/execution_policy.h>
#include <iostream>
#include <thrust/iterator/constant_iterator.h>

int main(){
  int n = 2518;
  thrust::host_vector<double> cpu_resultado(n, 0);
  thrust::host_vector<double> cpu_variancia(n, 0);
  thrust::host_vector<double> cpu_entrada(n, 0);

  for(int i = 0; i < n; i++){
    std::cin >> cpu_entrada[i];
  }

  thrust::device_vector<double> gpu_resultado(cpu_resultado);
  thrust::device_vector<double> gpu_variancia(cpu_variancia);
  thrust::device_vector<double> gpu_entrada(cpu_entrada);

  double sum = thrust::reduce(gpu_entrada.begin(), gpu_entrada.end(), (double) 0, thrust::plus<double>());

  double media = sum / n;

  thrust::transform(gpu_entrada.begin(), gpu_entrada.end(), thrust::constant_iterator<double> (media), gpu_variancia.begin(), thrust::minus<double>());

  thrust::transform(gpu_variancia.begin(), gpu_variancia.end(), gpu_variancia.begin(), gpu_resultado.begin(), thrust::multiplies<double>());

  double variancia = thrust::reduce(gpu_resultado.begin(), gpu_resultado.end(), (double) 0, thrust::plus<double>()) / n;

  std::cout << variancia << std::endl;

  return 0;
}