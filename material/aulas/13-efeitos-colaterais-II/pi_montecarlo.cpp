#include<iostream>
#include<algorithm>
#include<random>
#include<cmath>
#include<omp.h>
#include<iomanip>

using namespace std;

int main(){
  default_random_engine generator(10);
  uniform_real_distribution<double> distribution(0.0, 1.0);
  double sum = 0;
  int n = 100000000;
  double x, y, dist, pi;
  double init_time, final_time;

  init_time = omp_get_wtime();
  omp_set_num_threads(4);

  #pragma omp parallel for reduction(+:sum)
  for(int i = 0; i < n; i++){
    x = distribution(generator);
    y = distribution(generator);
    dist = pow(x,2) + pow(y,2);
    if(dist <= 1){
      sum += 1;
    }
  }

  pi = 4 * sum / n;
  cout << "pi: " << pi << endl;

  final_time = omp_get_wtime() - init_time;
  cout << "final time: " << final_time << endl;
  return 0;
}