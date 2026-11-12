# TaoPlay 130 临时云测仓（跑完即删）

- 对象：TaoPlay v3.25.30 (130) B 线包
- 内容：仅 APK + 云端模拟器流水线，无源码
- 机型（R23 起兼容性拉开差距）：一加 15T（2640×1216, 460dpi）、一加 Ace 5（2780×1264, 450dpi）、小屏 720×1600@280dpi、平板 2560×1600@320dpi、折叠屏内屏 2208×1768@420dpi（均 Android 15）；老系统 1080×2400@440dpi（Android 11 / API 30）
- 生命周期：测试完成即删除本仓库


## 修红坑清单（每轮改脚本前必过，R4-R22 实录）
- R23：验收档位正则只认数字+P（720P/1080P），折叠屏上报「2K」直接漏判——档位正则统一为 数字/2K/4K 通吃（[0-9]{1,4}[PK]）

1. 工具缺失：adb/emulator/aapt2 必须装齐并 PATH；aapt2 用 dump badging，无 badging 子命令
2. 包名提取：只能 grep -oP "package: name='\K[^']+" 精确取，禁 sed 贪婪匹配
3. AVD 注册：ANDROID_AVD_HOME 钉死 $HOME/.android/avd，手写 .ini；libpulse0 必装
4. KVM：sudo chmod 666 /dev/kvm
5. 权限弹窗：install -g + 逐项 pm grant 双保险
6. 测试视频：adb screenrecord 造 10s；MEDIA_SCANNER_SCAN_FILE 广播两次；ace5 偶发不入库
7. 禁用 adb reboot：ace5 重启后模拟器起不来（R20 实录）
8. 系统浮层：全屏提示「Got it」、ANR「Wait」都要解析点掉，且先点后拍
9. 播放器打开：VIEW intent 必加 -p 指定本包，否则被 Google 相册截胡（R19 实录）
10. 首选列表真实路径：解析 taoplay_test 节点直接点卡片
11. 拍照时序：先 screencap 再 uiautomator dump，控制条几秒即隐
12. ANR 陪跑：点开视频主线程可能长时间卡死，循环点 Wait 直到画质行出现才收工，禁止首轮「内容可见」就 break（R22 实录：连点 15 次未恢复）
13. 断言口径：验收点必须落到可 grep 的文本（如 [0-9]+P），只看流程绿不算数；截图必须人眼/看图复核
14. logcat 每轮必查 FATAL EXCEPTION=0，ANR in com.allplayer 单列统计
