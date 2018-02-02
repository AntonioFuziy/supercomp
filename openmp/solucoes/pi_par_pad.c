/*

This program will numerically compute the integral of

                  4/(1+x*x) 
				  
from 0 to 1.  The value of this integral is pi -- which 
is great since it gives us an easy way to check the answer.

The is the original sequential program.  It uses the timer
from the OpenMP runtime library

History: Written by Tim Mattson, 11/99.
         Updated by Luciano Soares

*/
#include <stdio.h>
#include <omp.h>
#define NUM_THREADS 2
static long num_steps=100000000;
double step;
int main() {
	int i,nthreads;
	double pi,sum[NUM_THREADS][8];
	double start_time,run_time;
	step=1.0/(double)num_steps;
	omp_set_num_threads(NUM_THREADS);
	start_time=omp_get_wtime();
	#pragma omp parallel
	{
		int i;
		double x;
		int id = omp_get_thread_num();
		int n = omp_get_num_threads();
		for(i=id,sum[id][0]=0.0;i<=num_steps;i+=n){
			x=(i-0.5)*step;
			sum[id][0] += 4.0/(1.0+x*x);
		}
	}
	for(i=0,pi=0.0;i<nthreads;i++)
		pi += sum[i][0]*step;
	
	run_time=omp_get_wtime()-start_time;
	printf("\n pi with %ld steps is %.12lf in %lf seconds\n",num_steps,pi,run_time);
	return 0;
}