TARGET = main0
SRC = main.c
LL = main.ll
LIB = ../../../lib/libsysy_aarch.a

# Use bash and run each recipe in a single shell to avoid continuation parsing issues
SHELL := /bin/bash
.ONESHELL:

# 优化等级
OPT_LEVELS = O0 O1 O2 O3

# 批次大小（可根据需要修改）
BATCH_SIZES = 10 100 1000 10000 100000 1000000

# 生成不同优化等级的可执行文件
all: $(OPT_LEVELS)

O0:
	clang -target aarch64-linux-gnu -O0 -o $(TARGET)_O0 $(LL) $(LIB)
O1:
	clang -target aarch64-linux-gnu -O1 -o $(TARGET)_O1 $(LL) $(LIB)
O2:
	clang -target aarch64-linux-gnu -O2 -o $(TARGET)_O2 $(LL) $(LIB)
O3:
	clang -target aarch64-linux-gnu -O3 -o $(TARGET)_O3 $(LL) $(LIB)

# 运行并计时


# 自动生成输入文件，并以CSV格式输出运行结果

run: all
	# Initialize result file and input files
	echo "batch_size,optimization,elapsed(ms),sys(ms),user(ms),output" > result.csv
	for size in $(BATCH_SIZES); do
		echo "$$size" > input_$$size.txt
	done

	# Run each optimization and batch size, capture output and timing
	for opt in $(OPT_LEVELS); do
		for size in $(BATCH_SIZES); do
			# run and capture timing and stdout per optimization
			/usr/bin/time -f "%e,%S,%U" qemu-aarch64 -L /usr/aarch64-linux-gnu ./$(TARGET)_$$opt < input_$$size.txt > tmp_output 2> tmp_time || true
			# save per-opt output for later comparison
			cp tmp_output output_$$size_$$opt.txt
			OUT=`tr '\n' ' ' < tmp_output | sed 's/"/\\"/g'`
			TIME=`cat tmp_time | tr -d '\n'`
			ELAPSED=`echo $$TIME | cut -d, -f1 | awk '{print int($$1*1000)}'`
			SYS=`echo $$TIME | cut -d, -f2 | awk '{print int($$1*1000)}'`
			USER=`echo $$TIME | cut -d, -f3 | awk '{print int($$1*1000)}'`
			echo "$$size,$$opt,$$ELAPSED,$$SYS,$$USER,\"$$OUT\"" >> result.csv
			rm -f tmp_output tmp_time
		done
	done

# Collect outputs target (ensures outputs exist)
outputs: run

# 比较不同优化等级的输出，生成 comparisons.csv 并把差异写在 diffs/ 下

compare_outputs: outputs
	mkdir -p diffs
	echo "batch_size,opt1,opt2,are_equal,diff_file" > comparisons.csv

	for size in $(BATCH_SIZES); do
		for i in $(OPT_LEVELS); do
			for j in $(OPT_LEVELS); do
				if [ "$$i" = "$$j" ]; then
					continue
				fi
				f1=output_$$size_$$i.txt; f2=output_$$size_$$j.txt
				if [ ! -f $$f1 ] || [ ! -f $$f2 ]; then
					echo "$$size,$$i,$$j,missing," >> comparisons.csv
					continue
				fi
				if cmp -s $$f1 $$f2; then
					echo "$$size,$$i,$$j,yes," >> comparisons.csv
				else
					df=diffs/diff_$$size_$$i_vs_$$j.txt
					diff -u $$f1 $$f2 > $$df || true
					echo "$$size,$$i,$$j,no,$$df" >> comparisons.csv
				fi
			done
		done
	done

clean:
	rm -f $(TARGET)_O0 $(TARGET)_O1 $(TARGET)_O2 $(TARGET)_O3

.PHONY: all O0 O1 O2 O3 run clean