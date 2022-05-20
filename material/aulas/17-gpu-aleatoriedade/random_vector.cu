#include <thrust/random.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/iterator/counting_iterator.h>
#include <vector>

int main(int argc, char* argv[]) {
    int n = atoi(argv[1]);
    thrust::default_random_engine eng(n);
    thrust::uniform_real_distribution<double> d(25, 40);
    thrust::host_vector<double> cpu(10);
    thrust::device_vector<double> gpu = cpu;

    for(int i = 0; i < 10; i++){
        cpu[i] = d(eng);
        gpu[i] = d(eng);
    }

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