#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int main() {
    const size_t N = 10000000;
    void** ptrs = malloc(N * sizeof(void*));
    clock_t start = clock();

    for (size_t i = 0; i < N; ++i)
        ptrs[i] = malloc(64);

    for (size_t i = 0; i < N; ++i)
        free(ptrs[i]);

    free(ptrs);
    clock_t end = clock();
    printf("Time: %f seconds\n", (double)(end - start) / CLOCKS_PER_SEC);
    return 0;
}
