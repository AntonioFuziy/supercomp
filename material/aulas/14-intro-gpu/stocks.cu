#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>
#include <iostream>

int main(){
  double n = 2518;
  thrust::host_vector<double> cpu_stocks(n, 0);
  for(int i = 0; i < n; i++){
    std::cin >> cpu_stocks[i];
  }

  thrust::device_vector<double> gpu_stocks(cpu_stocks);

  double result = thrust::reduce(thrust::device, gpu_stocks.begin(), gpu_stocks.end(), 0);

  std::cout << "Soma: " << result << std::endl;

  return 0;
}