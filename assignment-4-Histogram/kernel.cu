#include <stdio.h>

__global__ void histo_kernel(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins)
{
	
    extern __shared__ int private_bins[];

    unsigned int counter = threadIdx.x; 
    while (counter  < num_bins){

	    private_bins[counter] = 0;
	    counter += blockDim.x;

    }

    __syncthreads();

    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    while (i < num_elements){
	    
	    unsigned int bin = input[i];

	    if (bin < num_bins){
		    atomicAdd(&private_bins[bin],1);
	    }

	    i += stride;
    }


    __syncthreads();

    counter = threadIdx.x;
    while (counter < num_bins){
	    atomicAdd(&bins[counter], private_bins[counter]);
	    counter += blockDim.x;
    }
}

void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins) {

	cudaMemset(bins, 0, num_bins * sizeof(unsigned int));

	histo_kernel<<<16, 512, num_bins * sizeof(unsigned int)>>>(input, bins, num_elements, num_bins);
	cudaDeviceSynchronize();

}


