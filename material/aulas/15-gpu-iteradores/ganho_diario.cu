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
  thrust::host_vector<double> cpu_ganho(n, 0);
  thrust::host_vector<double> cpu_entrada(n, 0);

  for(int i = 0; i < n; i++){
    std::cin >> cpu_entrada[i];
  }

  thrust::device_vector<double> gpu_ganho(cpu_ganho);
  thrust::device_vector<double> gpu_entrada(cpu_entrada);

  thrust::transform(gpu_entrada.begin(), gpu_entrada.end()-1, gpu_entrada.begin()+1, gpu_ganho.begin(), thrust::minus<double>());

  for(int i = 0; i < n; i++){
    std::cout << gpu_ganho[i] << std::endl;
  }

  return 0;
}