target triple = "aarch64-unknown-linux-gnu"
; Handwritten LLVM IR for Fibonacci main.c
; Mirrors the behavior of the original C program: reads n, prints sequence

@.str.scanf = private constant [3 x i8] c"%d\00"
@.str.printf = private constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

define i32 @main() {
entry:
  ; allocate locals
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %t = alloca i32, align 4
  %n = alloca i32, align 4

  ; a = 0; b = 1; i = 1;
  store i32 0, i32* %a, align 4
  store i32 1, i32* %b, align 4
  store i32 1, i32* %i, align 4

  ; scanf("%d", &n);
  %0 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.scanf, i32 0, i32 0
  %1 = bitcast i32* %n to i8*
  %call_scanf = call i32 (i8*, ...) @scanf(i8* %0, i8* %1)

  ; printf(a)
  %2 = load i32, i32* %a, align 4
  %3 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.printf, i32 0, i32 0
  %4 = call i32 (i8*, ...) @printf(i8* %3, i32 %2)

  ; printf(b)
  %5 = load i32, i32* %b, align 4
  %6 = call i32 (i8*, ...) @printf(i8* %3, i32 %5)

  br label %loop

loop:
  ; while (i < n)
  %7 = load i32, i32* %i, align 4
  %8 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %7, %8
  br i1 %cmp, label %body, label %end

body:
  ; t = b;
  %9 = load i32, i32* %b, align 4
  store i32 %9, i32* %t, align 4

  ; b = a + b;
  %10 = load i32, i32* %a, align 4
  %11 = load i32, i32* %b, align 4
  %add = add i32 %10, %11
  store i32 %add, i32* %b, align 4

  ; printf(b)
  %12 = load i32, i32* %b, align 4
  %13 = call i32 (i8*, ...) @printf(i8* %3, i32 %12)

  ; a = t;
  %14 = load i32, i32* %t, align 4
  store i32 %14, i32* %a, align 4

  ; i = i + 1;
  %15 = load i32, i32* %i, align 4
  %inc = add i32 %15, 1
  store i32 %inc, i32* %i, align 4

  br label %loop

end:
  ret i32 0
}