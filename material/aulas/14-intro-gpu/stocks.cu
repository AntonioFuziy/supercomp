#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/extrema.h>
#include <thrust/execution_policy.h>
#include <iostream>

int main(){
  double n = 2518;
  // double microsoft_stock, apple_stocks;
  double stock;
  thrust::host_vector<double> cpu_comparison(n, 0);

  for(int i = 0; i < n; i++){
    std::cin >> stock;
    // std::cin >> apple_stocks >> microsoft_stock;
    cpu_comparison[i] = stock;
    // cpu_comparison[i] = apple_stocks - microsoft_stock;
  }

  thrust::device_vector<double> gpu_comparison(cpu_comparison);

  // double result = thrust::reduce(thrust::device, gpu_comparison.begin(), gpu_comparison.end(), 0);
  double min_value = thrust::reduce(gpu_comparison.end()-2500, gpu_comparison.end(), (double) 9999999999, thrust::minimum<double>());
  double max_value = thrust::reduce(gpu_comparison.end()-2500, gpu_comparison.end(), (double) 0, thrust::maximum<double>());
  

  std::cout << "Min: " << min_value << std::endl;
  std::cout << "Max: " << max_value << std::endl;
  // double media = result / n;

  // std::cout << "Soma: " << result << std::endl;
  // std::cout << "Media: " << media << std::endl;

  return 0;
}