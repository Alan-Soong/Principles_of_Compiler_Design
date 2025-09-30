target triple = "aarch64-unknown-linux-gnu"

declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)

define i32 @main() {
entry:
  %a = alloca i32
  %b = alloca i32
  %i = alloca i32
  %t = alloca i32
  %n = alloca i32

  store i32 0, i32* %a
  store i32 1, i32* %b
  store i32 1, i32* %i

  %call1 = call i32 @getint()
  store i32 %call1, i32* %n

  %a_val = load i32, i32* %a
  call void @putint(i32 %a_val)
  call void @putch(i32 10)

  %b_val = load i32, i32* %b
  call void @putint(i32 %b_val)
  call void @putch(i32 10)

  br label %while.cond

while.cond:
  %i_val = load i32, i32* %i
  %n_val = load i32, i32* %n
  %cmp = icmp slt i32 %i_val, %n_val
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %b_val2 = load i32, i32* %b
  store i32 %b_val2, i32* %t

  %a_val2 = load i32, i32* %a
  %add = add i32 %a_val2, %b_val2
  store i32 %add, i32* %b

  call void @putint(i32 %add)
  call void @putch(i32 10)

  %t_val = load i32, i32* %t
  store i32 %t_val, i32* %a

  %i_val2 = load i32, i32* %i
  %inc = add i32 %i_val2, 1
  store i32 %inc, i32* %i

  br label %while.cond

while.end:
  ret i32 0
}