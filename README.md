# 粒子物理大作业

提示：如果你无法渲染其中的公式，请阅读 `README.pdf`，两者内容相同。

## 大作业介绍

中微子是组成自然界的基本粒子之一，质量几乎为 0 ，以接近光速运动，每一秒钟就有数万亿中微子穿过每个人的身体。中微子只参与弱相互作用，与物质的相互作用十分微弱，很难探测，因此被称为幽灵粒子(Ghost Particle)。现在的探测方法，是借助中微子与物质偶然相互作用产生带电粒子，在探测器上沉积能量发出光子，进而通过光电倍增管(Photomultiplier，简称 PMT)接收光信号，产生电压波形。

在探测中微子信号的同时，探测器也会探测到一些典型带电粒子，例如alpha粒子和beta粒子等。在众多的粒子信号中，我们需要将不同的探测事例进行分析比对后，分别标记，本次的大作业，即是完成对alpha粒子和beta粒子的鉴别标记。

粒子物理大作业主要分为两个阶段：

第一个阶段为根据物理背景，模拟生成alpha粒子和beta粒子进入液体闪烁体探测器时，光电倍增管最后得到的输出出信号，即探测器系统对于粒子的信号相应。

第二阶段为将现有光电倍增管输出波形信号，对alpha粒子和beta粒子进行鉴别，分析事例信号为两种粒子的概率大小。

本次大作业的第二部分以清华-锦屏中微子实验为物理背景。对中微子实验中的光电倍增管（PMT）波形（HDF5格式存储）进行数据分析，对液体闪烁体探测器中的alpha粒子和beta粒子进行鉴别，得到相应的粒子类型，并将入射粒子的类型作为输出结果进行提交。



## 物理背景

### 锦屏中微子实验

中国锦屏地下实验室（China Jinping Underground Laboratory， CJPL）位于四川省雅砻江锦屏山的深处，是中国首个用于开展暗物质探测等国际前沿基础研究课题的极深地下实验室，于2010年12月12日正式投入使用。目前，CDEX、PandaX等暗物质实验在这里进行，这些实验的研究水平已达到国际第一阵营。不仅仅是暗物质实验，未来的锦屏中微子实验也会在中国锦屏地下实验室开展，在太阳中微子、地球中微子、超新星遗迹中微子等学科前沿方面进行研究。
为了研究锦屏中微子实验所用到的液体闪烁体和低本底技术，我们在锦屏地下实验室中建造了一个小型原型机。其核心部件包括1吨液体闪烁体和30个光电倍增管（PMT）。高速运动的微观粒子在液体闪烁体中沉积能量，闪烁体会发出荧光，光电倍增管会将这些光信号转化为电信号输出。通过分析这30个光电倍增管上的电压波形，我们就可以得到原初粒子的能量、位置等信息，进而进行相关的物理分析。

![avatar](https://github.com/physics-data/tpl_PID/blob/master/data/back.jpg)

探测器每次运行被称为一个run，每个run中都包含了很多个触发事例（event）。我们记录下来的主要信息就是每个事例的触发时间戳，以及30个PMT（编号从通道0到通道29）上的波形。

### 电离

闪烁体需要发光，首先要吸收能量，能量主要来源于粒⼦的电离过程。电离过程是带电粒⼦损失能量的重要方式，可以用Bethe公式描述:

$$
{(\frac{dE}{dx})}_{ion}={({\frac{1}{{4}{\pi}{\epsilon}_0}})}^2{\frac{4{\pi}{e}^4{z}^2}{{{m_0}v}^2}}NB
$$

其中， m为电子的静止质量， z为入射粒子的电荷数， v为入射粒子速度， N是靶物质（液闪）单位体积的原子数。

$$
B=Z[ln({\frac{2{m_0}{v}^2}{I}})-ln(1-{\frac{{v}^2}{{c}^2}})-{\frac{{v}^2}{{c}^2}}]
$$

其中， Z为靶物质的原子的原子序数（因为液闪含有不同种类原子，因此需要将不同类原子分开计算，但是看成一种原子并不会影响最后的分析结果），I为靶物质（液闪）的平均激发和电离能。注意当接近相对论速度时，该项在增加，所以这一点也是非常重要的。



### 闪烁体

中微子探测器偏爱闪烁体探测器，中微子反应截面很小，因此探测器需要非常巨大，而液体闪烁体恰好符合这个要求。
闪烁体有很多类型，但是发光原理基本上一致。锦屏1吨原型探测器中使用液体闪烁体LAB（PPO），其中的苯环会形成π键。对应电子能级也会分成单态与三态。

![avatar](https://github.com/physics-data/tpl_PID/blob/master/data/back1.jpg)

在闪烁体发光的过程中，可以认为闪烁体的激发是瞬间完成的，但是退激发发射光子的过程是一个逐渐完成的过程，退激发发射光子的过程是一个满足指数衰减的概率过程，随着时间的增长，闪烁体退激发光放出的光子数会逐渐的减少。

当然，闪烁体退激发射的光子总数是固定的，但是随着传播距离的增加，进入到光电倍增管形成输出信号的光子数会大幅度减小，当光电倍增管距离发光点足够远时，就有可能会出现单个光子或者少量光子进入光电倍增管的情况。

### 粒子发光特点

对应的电荷更大，质量大，电离密度更高，因此产生光子密度更大，运动轨迹短并且偏转小。进入三线态概率更大，导致发光时间常数变长。

#### alpha粒子

质量小，速度近光速，会产生切伦科夫光。
对应的电荷小，质量小，电离密度小，单位距离能损较小，因此产生光子密度小。

#### beta粒子

虽然单位距离能损较小，但是因为质量较小，因此电子反复散射轨迹曲折，最后行走距离不长。
进入三线态概率小，导致发光时间常数比 alpha粒子要短。

### 光电倍增管电压波形响应
当单个光子进入PMT时，形成的信号是由光电倍增管特性决定的一个信号响应，当射入到PMT的光子数比较多时，得到的波形则是由各个光子的波形响应叠加得到的一个波形，这条波形在数学表达上，可以理解为光电倍增管的单光子响应和闪烁体发射光子的概率分布的卷积形式。
入射到PMT的光子数比较多时，光电倍增管流过阳极回路的总电荷量：

$$
Q=E*k*T*M*e
$$

其中，E为闪烁体内沉积的能量，k为每MeV能量沉积发射光子量，T为转化因子，M为光电倍增管总的放大倍数。

得到最终的电压信号的脉冲响应为：

$$
V（t）={\frac{Q}{C}}*{\frac{RC}{RC-{\tau}}}*({e}^{-{\frac{t}{RC}}}-{e}^{-{\frac{t}{\tau}}})
$$

式中，R，C为探测器输出回路的的等效电阻和等效电容，τ为光子的时间衰减常数。


## 数据说明

所有的输入数据存放在data文件夹下，因此请不要pai随意改动这个文件夹下的内容。

data.csv文件中存储了用于第一步任务中需要用到的探测器参数和粒子的基本信息，具体内容如下：

| Table    | value     | units               |
| -------- | --------- | ------------------- |
| E_alpha  | 10        | MeV                 |
| E_beta   | 1         | MeV                 |
| Z        | 246       | 相对原子质量        |
| I        | 0.0022    | MeV                 |
| c        | 3.0*10^8  | m/s                 |
| k        | 4300      | /MeV                |
| n_alpha1 | 0.8       | 慢成分比例          |
| n_alpha2 | 0.2       | 快成分比例          |
| n_beta1 | 0.1       | 慢成分比例          |
| n_beta2 | 0.9      | 快成分比例          |
| t_alpha1 | 25        | ns，慢成分衰减常数  |
| t_alpha2 | 5         | ns，快成分衰减常数  |
| t_beta1   | 25         | ns                  |
| t_beta2   | 5         | ns                  |
| d        | 1         | m，探测器直径       |
| n        | 1.5       | 液闪的折射率        |
| M        | 100000    | PMT总的倍增系数     |
| t0       | 50        | ns，PMT平均渡越时间 |
| T        | 1         | PMT转换因子         |
| C0       | 1         | pF，PMT等效电容     |
| R0       | 1         | kΩ，PMT等效电阻     |
| f        | 0.3       | PMT的覆盖率         |
| Np       | 30        | PMT数量             |





## 作业要求（功能部分）

### Makefile

本次作业提供了 Makefile，最终助教也将使用 Makefile 进行测试。需要注意，你在编写所有程序文件时，都应该使用 make 给程序传入的参数（来自 `data.txt`；否则，你可能无法通过测试。

在本目录中运行 `make -n` 即可看到实际运行的命令，这或许能帮助你开发。

### 基本要求

第一阶段的作业主要进行的是模拟探测器对alpha粒子和beta粒子的响应。可以大概分为以下三个步骤，完成每一个任务即可拿到相应的分数：

| 任务（程序名） | 分数 |
| -------------- | ---- |
| energy_deposition.py       | 10   |
| light_spread.py      | 10   |
| reponse.py       | 10   |



第一步：根据入射粒子的类型和能量，计算带电粒子的电离能量损失（bethe公式描述），以及发射光子的数量。这里我们做一个简化，认为带电粒子在运动过程中只在探测器球心出发生一次能量沉积，且作为点源发射各向同性的光子。这里需要区分发射光子的快慢成分（完成`energy-deposition.py`）。经过该步骤应该得到一个如下的表格形式：

|           | 快成分光子数 | 慢成分光子数 |
| --------- | ------------ | ------------ |
| alpha粒子 |              |              |
| beta粒子  |              |              |

由于该发射光子的过程是一个概率分布的问题，因此，此结果解释为一个发射光子的期望值更为准确。


第二步：模拟光子到达光电倍增管的过程（完成`light_spread.py`）。发射光子，这里的发射位置简化为在探测器的球心。同样，简化后我们认为光子的发射是各向同性的。

在光子传输到达光电倍增管的过程，我们认为该过程是需要进行一定的衰减的，衰减的过程简单的认为符合平方反比规律，即光子到达光电倍增管的亮度认为与发射点到PMT间的距离满足平方反比规律。该部分需要输出光子到达PMT的时间和光强。你需要输出一个如下的表格：

|           | 到达时间（ns） | 进入单个PMT光子数（快慢成分一起） |
| --------- | -------------- | -------------- |
| alpha粒子 |                |                |
| beta粒子  |                |                |



第三步：模拟光子经过光电倍增管放大，得到输出的波形（完成`spread.py`）。该部分需要输出得到的波形图像。

该阶段的作业需要提交3个编程文件，经过测试后得到一个result.pdf文件，包含第一步输出的光类型与数量、第二步输出的时间与光强、第三步输出的波形图像。








