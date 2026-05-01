#include <stdio.h>

int main(int argc, char* argv[]) {
    // int main(int argc, char** argv) {
    // NOT: int main(int argc, char argv[][]) {
    printf("Number of arguments: %d\n", argc);

    for (int i = 0; i < argc; i++) {
        printf("Argument %d: %s\n", i, argv[i]);
    }

    return 0;
}

// argc = počet argumentů předaných programu
// argv = pole ukazatelů na C-řetězce (char *)
// ./program hello 123
// - tak pak: argc = 3
// - argv[0] → "./program"
// - argv[1] → "hello"
// - argv[2] → "123"
// - argv[3] → NULL