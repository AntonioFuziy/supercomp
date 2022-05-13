#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>
#include <iostream>

int main(){
  double n = 2518;

  thrust::host_vector<double> cpu_comparison(n, 0);
  thrust::host_vector<double> cpu_apple(n, 0);
  thrust::host_vector<double> cpu_microsoft(n, 0);

  for(int i = 0; i < n; i++){
    std::cin >> cpu_apple[i] >> cpu_microsoft[i];
  }

  thrust::device_vector<double> gpu_apple(cpu_apple);
  thrust::device_vector<double> gpu_microsoft(cpu_microsoft);
  thrust::device_vector<double> gpu_comparison(cpu_comparison);

  thrust::transform(gpu_apple.begin(), gpu_apple.end(), gpu_microsoft.begin(), gpu_comparison.begin(), thrust::minus<double>());

  double mean = thrust::reduce(gpu_comparison.begin(), gpu_comparison.end(), (double) 0, thrust::plus<double>()) / n;
  std::cout << "Media: " << mean << std::endl;

  return 0;
}