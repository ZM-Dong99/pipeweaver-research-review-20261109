# HTTPS 传输记录（2026-10-30）

2026-11-06真实SSE预检后续：新授权最多2次，仅调用1次即按失败停止。HTTP200，35.328秒首字节，收到155217字节，但180秒总超时（curl28），未获得完整候选/用量，未执行新EDA。37项执行核对通过，不能当成生成成功。剩余1次未调用；调整长时限需新同意，原批次不恢复。[结果与下一步](eda/experiments/sse_generation_preflight_20261106_final/RESULT_SUMMARY.md)。

2026-11-06独立流式接收方案完成：agents/sse_transport.py 已通过12项离线检查和3份历史响应的合成分片回放。现有实验默认传输未切换；两次真实预检已冻结，等待新授权，新增推理0次。见[预检范围与执行条件](eda/experiments/sse_generation_preflight_20261106_final/README.md)。

2026-11-06补充：[最新网关诊断](eda/experiments/gateway_connectivity_20261106_083218_275189/DIAGNOSIS.md)。三次无鉴权探测均完成证书验证，网关首页200、模型列表401；旧批次6次524集中125–129秒，符合网关等待超时特征。尚未验证生成稳定性，本次新增推理0次，旧额度不复用。

原默认 urllib 保留；设置 PIPEWEAVER_HTTP_TRANSPORT=curl 可选择本机 curl。新冻结协议记录传输方式、二进制 SHA-256 与版本，实际请求审计也记录传输方式。两组必须使用同一设置。旧冻结协议不得混改传输后继续执行。

curl 仅尝试一次，不带 --insecure，不自动跟随重定向，不读默认 curlrc；设置连接与总超时。鉴权通过标准输入配置传给子进程，不放入 argv、项目文件或日志，子进程环境移除 OPENAI_API_KEY。临时请求体仅含正常请求内容，退出时清理。依据 curl 官方配置接口：https://curl.se/docs/manpage.html#-K

本机无鉴权诊断中，一次 Python 请求出现约 5.05 秒 SSL EOF；同时间 curl 到同一模型列表接口收到 HTTP 401，证书校验结果为 0。随后新客户端的一次真实鉴权模型列表查询成功，记录位于 eda/experiments/addr_calcu_preflight_20261030/curl_probe.json。它不等于证明下一轮生成不会再中断，也不能确认上游模型身份。没有通过关闭证书校验处理连接失败。

新增三项本地合成响应测试验证：令牌只经 stdin、不在 argv/请求文件或子进程环境；HTTP/传输错误不回显 stderr；超时不重试。已有 15 项适配器、格式和闭环测试通过。测试数据不是实验候选。
