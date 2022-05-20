#include <thrust/random.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/iterator/counting_iterator.h>
#include <vector>

int main() {
    int n;
    std::cin >> n;
    thrust::default_random_engine eng(n);
    thrust::uniform_real_distribution<double> d(25, 40);

    for (int i = 0; i < 10; i++) {
        std::cout << d(eng) << "\n";
    }
    return 0;
}