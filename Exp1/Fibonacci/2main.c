#include <stdio.h>
#include <stdbool.h>

// 计算斐波那契数列的第 n 项（递归）
int fibonacci_recursive(int n) {
    if (n <= 1) return n;
    return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2);
}

// 计算斐波那契数列的第 n 项（循环）
int fibonacci_iterative(int n) {
    int a = 0, b = 1, temp, i;
    if (n <= 1) return n;
    for (i = 2; i <= n; i++) {
        temp = a + b; // 数值运算和赋值
        a = b;
        b = temp;
    }
    return b;
}

// 判断一个数是否为偶数
bool is_even(int x) {
    return x % 2 == 0;
}

// 打印前 n 项斐波那契数列，并统计偶数项和
void print_fibonacci(int n) {
    int i, sum_even = 0;
    for (i = 0; i < n; i++) { // 循环
        int val = fibonacci_iterative(i); // 函数调用
        printf("Fibonacci(%d) = %d\n", i, val);
        if (is_even(val)) { // 条件分支
            sum_even += val; // 数值运算和赋值
        }
    }
    printf("Sum of even Fibonacci numbers: %d\n", sum_even);
}

int main() {
    int n;
    printf("Enter n: ");
    scanf("%d", &n);

    if (n < 0) { // 条件分支
        printf("n must be non-negative!\n");
        return 1;
    }

    print_fibonacci(n); // 函数调用

    // 进阶特性：三元运算符
    int last = (n > 0) ? fibonacci_recursive(n - 1) : 0;
    printf("The last Fibonacci number (recursive): %d\n", last);

    return 0;
}