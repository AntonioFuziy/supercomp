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
    size_t N = 10000;
    thrust::host_vector<double> cpu(2*N);
    thrust::device_vector<double> gpu = cpu;

    thrust::transform(
        thrust::make_counting_iterator<int>(0),
        thrust::make_counting_iterator<int>(2*N),
        gpu.begin(),
        rng_gpu()
    );

    int sum = 0;
    double dist = 0;
    for(int i = 0; i < N; i++){
        dist = pow(gpu[i],2) + pow(gpu[2*i],2);
        if(dist <= 1){
            sum += 1;
        }
    }

    double pi = 4*sum/N;
    std::cout << "pi: " << pi << std::endl;

    return 0;
}