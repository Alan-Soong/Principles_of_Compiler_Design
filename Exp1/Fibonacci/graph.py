import pandas as pd
import matplotlib.pyplot as plt

# 读取数据
df = pd.read_csv('result.csv')

# 转换 batch_size 为整数
df['batch_size'] = df['batch_size'].astype(int)

# 绘图
plt.figure(figsize=(10, 6))
for opt in df['optimization'].unique():
    sub = df[df['optimization'] == opt]
    plt.plot(sub['batch_size'], sub['elapsed(ms)'], marker='o', label=opt)

plt.xlabel('Batch Size')
plt.ylabel('Elapsed Time (ms)')
plt.title('Performance Comparison of Optimization Levels')
plt.legend(title='Optimization')
plt.grid(True)
plt.xscale('log')  # 如果 batch_size 跨度大，建议用对数坐标
plt.tight_layout()
plt.savefig('result_plot.png')
plt.show()