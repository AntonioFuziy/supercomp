#include <thrust/random.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/iterator/counting_iterator.h>
#include <vector>

struct rng_gpu {  
    __device__ __host__
    double operator() (const int n) {
        thrust::default_random_engine eng(n);
        thrust::uniform_real_distribution<double> d(25, 40);
        return d(eng);
    }
};

int main(int argc, char* argv[]) {
    size_t N = 10;
    thrust::host_vector<double> cpu(N);
    thrust::device_vector<double> gpu = cpu;

    thrust::transform(
        thrust::make_counting_iterator<int>(0),
        thrust::make_counting_iterator<int>(N),
        cpu.begin(),
        rng_gpu()
    );

    thrust::transform(
        thrust::make_counting_iterator<int>(0),
        thrust::make_counting_iterator<int>(N),
        gpu.begin(),
        rng_gpu()
    );

    for(int i = 0; i < 10; i++){
        std::cout << cpu[i] << " ";
    }
    std::cout << std::endl;

    for(int i = 0; i < 10; i++){
        std::cout << gpu[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}