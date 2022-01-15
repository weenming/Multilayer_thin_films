# 多层膜的逆问题
这是光学课的project
## 特性

采用传输矩阵，链式法则[1]替代差分求梯度来提高效率
可以用反射光谱计算（可能的）薄膜折射率分布

薄膜设计

## 运行方法
- 在mainlm.m中，指定m个波长和对应的折射率输入targetpts就可以拟合。
- 使用generate_targetpts 或 generate_targetpoints_from_picture来从膜厚度得到目标光谱/从图片读取目标光谱
- 欲更改折射率，请在get_jacobian和get_R中一起改


## Reference
>[1] Lingjie Fan, Ang Chen, Tongyu Li, Jiao Chu, Yang Tang, Jiajun Wang, Maoxiong Zhao, Tangyao Shen, Minjia Zheng, Fang Guan, Haiwei Yin, Lei Shi, Jian Zi. Thin-film neural networks for optical inverse problem[J]. Light: Advanced Manufacturing. doi: 10.37188/lam.2021.027 shu
