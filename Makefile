.PHONY: all
all: num_light.csv spread.csv waveform.h5 waveform.pdf

# 计算能量沉积产生的光子数
num_light.csv: data/constant.json
	python3  energy_deposition.py $^ $@

# 计算光子传播的时间及进入到光电倍增管的各成分数量
spread.csv: data/constant.json data/num_light.csv
	python3 light_spread.py $^ $@

# 计算光电倍增管的波形响应
waveform.h5: data/constant.json data/spread.csv
	python3 generate_response.py $^ $@

# 绘制探测器响应的波形图
waveform.pdf: data/waveform.h5
	python3 plot_waveform.py $^ $@

# Delete partial files when the processes are killed.
.DELETE_ON_ERROR:
# Keep intermediate files around
.SECONDARY:
