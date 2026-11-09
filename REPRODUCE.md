# 老师核查与EDA复跑

## 归档检查

```sh
python tools/verify.py
```

无需密钥。当前整理环境会实际运行该命令并归档其输出。

## STA汇报案例复跑

STA_CASES.json绑定7组真实STA候选，包括优先编码器、ALU、选择器、译码器、CRC、乘法器和补充地址计算实例。

```powershell
python tools/reproduce.py --registry STA_CASES.json --case alu64 --liberty D:/path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
python tools/reproduce.py --registry STA_CASES.json --case all --liberty D:/path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
```

## 完整研究的八个代表性组合实例

实例和原始/候选SHA-256记录在REVIEW_CASES.json，包含priority256、mux10x8、alu64、addr128、crc32_d8、comparator16、decoder8和multiply8。

归档的生产评估器采用Windows及名为Ubuntu的WSL发行版。依赖Yosys、OpenSTA，CRC额外需要Yosys的Slang前端。通过YOSYS环境变量指定Yosys可执行文件，通过OPENSTA指定Ubuntu内的OpenSTA路径。协议中的原工具版本供对照。

使用者提供已获准使用的相同Liberty文件，其SHA-256为92eb4e93a3d4c2563018ac81cdec2f02fdeaced9b39337ed5c141fa63e0ad8f8。本地实验源文件来自OpenSTA的test/sky130hd目录，相关说明保留在原项目的SKY130记录中。该库文件按外部依赖处理。

```powershell
$env:YOSYS = 'D:/oss-cad-suite/bin/yosys.exe'
$env:OPENSTA = '/home/easton1/OpenSTA/build/sta'
python tools/reproduce.py --case comparator16 --liberty D:/path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
python tools/reproduce.py --case all --liberty D:/path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
```

结果写入新建runs目录，依次进行原始与候选证明、映射、门级证明和真实STA，输出REPRODUCTION.json。proofs_and_ppa_passed表示本次证明和测量状态，exact_metrics_match另行比较冻结指标。工具版本或环境变化导致差异时保留实际结果与日志。

## 物理层核查

先核对复位合同、实际输入RTL、布局布线记录、填充前后保留性、SPEF重读结果、独立DRC和具名普通体硅LVS正负例。源目录的脚本和协议保留原执行环境信息。完整物理复跑还需对应版本的OpenROAD、KLayout、PDK和省略资产清单中的文件，复跑环境封装可继续完善。

## GitHub发布

本目录可直接作为独立Git仓库推送。若由项目负责人手动发布，可在GitHub创建空的公开仓库，再设置origin和推送main。创建页面应与本地已有文件配套，避免预填初始化文件产生分叉。[GitHub创建仓库官方说明](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)

## 整理环境已执行

已实际执行上述all命令，8组原始/候选的16次证明、映射与STA通过，全部冻结指标匹配。[验收输出](ACCEPTANCE_REPRODUCTION.json)记录了实际版本及测量值。
