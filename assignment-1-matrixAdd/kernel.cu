#include <stdio.h>

#define TILE_SIZE 16

__global__ void matAdd(int dim, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A + B
     *   where A is a (dim x dim) matrix
     *   where B is a (dim x dim) matrix
     *   where C is a (dim x dim) matrix
     *
     ********************************************************************/

    /*************************************************************************/
    // INSERT KERNEL CODE HERE
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int i;

    if (row < dim && col < dim) {
	 i = row * dim + col;
	C[i] = A[i] + B[i];
    } 	    
        
    /*************************************************************************/

}

void basicMatAdd(int dim, const float *A, const float *B, float *C)
{
    // Initialize thread block and kernel grid dimensions ---------------------

    const unsigned int BLOCK_SIZE = TILE_SIZE;
	
    /*************************************************************************/
    //INSERT CODE HERE

    dim3 blockDim(BLOCK_SIZE, BLOCK_SIZE);

    dim3 gridDim((dim + BLOCK_SIZE - 1) / BLOCK_SIZE, (dim + BLOCK_SIZE - 1) / BLOCK_SIZE);

    /*************************************************************************/
	
	// Invoke CUDA kernel -----------------------------------------------------

    /*************************************************************************/
    //INSERT CODE HERE
    
    matAdd<<<gridDim, blockDim >>>(dim, A, B, C);
    /*************************************************************************/

}

