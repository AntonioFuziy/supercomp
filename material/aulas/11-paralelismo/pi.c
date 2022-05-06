#include <omp.h>
#include <math.h>

int main(){
  int n = 1000000000;
  double pi;

  for(int i = 0; i < n; i++){
    pi += (pow(-1.0, i))/(2*i+1);
  }

  printf("pi = %f\n", pi);

  return 0;
}