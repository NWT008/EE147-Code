#include <stdio.h>

#define TILE_SIZE 16

__global__ void mysgemm(int m, int n, int k, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A x B
     *   where A is a (m x k) matrix
     *   where B is a (k x n) matrix
     *   where C is a (m x n) matrix
     *
     * Use shared memory for tiling
     *
     ********************************************************************/

    /*************************************************************************/
    // INSERT KERNEL CODE HERE
    
    __shared__ float A_tile[TILE_SIZE][TILE_SIZE];
    __shared__ float B_tile[TILE_SIZE][TILE_SIZE];

    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int row = blockIdx.y * TILE_SIZE + ty;
    int col = blockIdx.x * TILE_SIZE + tx;

    float sum = 0.0;

    for (int phase = 0; phase < (k + TILE_SIZE-1) / TILE_SIZE; phase++){
	    int A_col = phase * TILE_SIZE + tx;
	    int B_row = phase * TILE_SIZE + ty;

	    if (row < m && A_col < k){
		    A_tile[ty][tx] = A[row * k + A_col];
	    }
	    else{
		    A_tile[ty][tx] = 0.0;
	    }

	    if (B_row < k && col < n){
		    B_tile[ty][tx] = B[B_row * n + col];
	    }
	    else{
		    B_tile[ty][tx] = 0.0;
	    }

	    __syncthreads();

	    for (int i = 0; i < TILE_SIZE; i++){
		    sum += A_tile[ty][i] * B_tile[i][tx];
	    }

	    __syncthreads();
    }

    if (row < m && col < n){
	    C[row * n + col] = sum;
    }
    /*************************************************************************/
}

void basicSgemm(int m, int n, int k, const float *A, const float *B, float *C)
{
    // Initialize thread block and kernel grid dimensions ---------------------

    const unsigned int BLOCK_SIZE = TILE_SIZE;
	
    /*************************************************************************/
    //INSERT CODE HERE
    
    dim3 dim_block(TILE_SIZE, TILE_SIZE, 1);
    dim3 dim_grid((n + TILE_SIZE - 1) / TILE_SIZE, (m + TILE_SIZE - 1) / TILE_SIZE, 1);
    /*************************************************************************/

    // Invoke CUDA kernel -----------------------------------------------------

    /*************************************************************************/
    //INSERT CODE HERE

    mysgemm<<<dim_grid, dim_block>>>(m, n, k, A, B, C);
    /*************************************************************************/
}


