本zip包内容只为想要自己申请API_ID或自己获取API_SESSION的有缘人准备，如果你不想如此麻烦，可以直接使用在线地址：
**********************
http://tg.seczh.com
**********************
把上述地址直接配置到网盘配置-》网盘相关配置-》TG登录后搜索服务器地址即可，无需看下面任何内容。


==================================

本zip内包含了4个平台的独立可执行文件，对应关系为：
tgsearch.exe     对应Windows X64系列
tgsearch.x86_64  对应x86_64(amd64)的所有Linux平台，包括但不限于x86软路由、安卓x86版、WSL/WSL2、所有Linux发行版（比如Debian,Ubuntu,Alpine,CentOS)
tgsearch.arm32v7 对应所有基于arm32或arm64的平台，包括但不限于安卓手机、安卓盒子、安卓电视、WSA、arm路由器、arm服务器，各种基于arm的Linux发行版（比如Debian,Ubuntu,Alpine,CentOS)
tgsearch.arm64v8 对应所有基于arm64的平台，包括但不限于安卓手机、安卓盒子、安卓电视、WSA、arm路由器、arm服务器，各种基于arm的Linux发行版（比如Debian,Ubuntu,Alpine,CentOS)


==================================
tgsearch.*包含了若干参数，可以tgsearch -h获取帮助，参数说明：
-i 指定Telegram API_ID，目前程序中已经预置了生十个儿子的赵霸道赵总贡献的API_ID，无需自己申请。如果一定要自己申请，可以从https://my.telegram.org申请，需要干净翻墙ip或任意翻墙IP情况下打开网页https://www.lumiproxy.com/zh-hans/online-proxy/proxysite/ 使用该网页的页面代理申请
-H 指定Telegram API_HASH，可以不指定，情况类似-i
-s 指定Telegram API_SESSION，在首次运行时会自动提示输入手机号，输入后到Telegram App中等待验证码（不是短信验证码），然后输入验证码得到Session，然后就可以用-s参数指定之，在大部分系统环境下，不指定也可以，因为首次获取后会写入.tgsearch_session的配置文件,后续执行会尝试读取本目录下的.tgsearch_session文件
-P 指定连接Telegram API所需要用到的翻墙代理，代理可以包含前缀和验证，例如http://192.168.1.1:7890 或 socks5://user@pass@192.168.1.1:7890
-p 等同于-P
-o 指定本程序监听端口，默认是10199，用于其他程序连接本程序获取TG内容。
-1 仅尝试验证Telethon API V1 Session, 验证完成后退出
-2 仅尝试验证Telethon API V2 Session, 验证完成后退出
-S 指定Telegram API_SESSION_V1，类似-s参数，但用来指定V1的session
-I 是否提供下载图片服务(默认不开启)，带有本参数时会接受TG群组内的图片下载请求，会消耗本服务器的流量
-d 调试模式

上述参数也可以使用环境变量来指定具体对应关系为：(除API_SESSION外皆可省略)
export API_ID=     api_id
export API_HASH=     api_hash
export API_SESSION=     api_session
export API_PROXY=     api_proxy
export API_SESSION_V1=     api_session_v1
export API_DOWNLOAD_IMAGE=     api_download_image


==================================
本程序在服务端首次运行需要获取session，需要输入手机号和验证码，因此不能用nohup保活，但可以用screen或tmux保活。在成功获取或指定session后，可以用nohup,screen或tmux保活，具体用法：
nohup用法: nohup ./tgsearch -P socks5ip:socks5port 2>&1 >/dev/null &

screen用法：screen -S tgsearch ./tgsearch -P socks5ip:socks5port
screen退出终端不退应用方法： 在screen窗口中按ctrl+a，然后松手再按d
screen断连后重连方法：screen -r tgsearch

tmux用法：tmux new-session -s tgsearch "./tgsearch -P socks5ip:socks5port"
tmux退出终端不退应用方法：在tmux窗口中按ctrl+b，然后松手再按d
tmux断连后重连方法：tmux attach -t tgsearch

==================================
本程序的arm版本可以直接在安卓设备上运行，可以使用termux或类似的安卓终端软件，直接在终端窗口中执行用来获取session。
在termux安装后需要在termux终端窗口中执行termux-setup-storage用来获取SD卡访问权限。
termux无需安装任何发行版，无需debian也无需ubuntu，只要纯净termux安装即可。
注意：termux不能使用GoolgePlay版本，会权限不足。需要使用github版本或fdroid版本，对应的termux下载地址分别是：
https://f-droid.org/repo/com.termux_1000.apk
和
https://github.com/termux/termux-app/releases

termux获取tgsearch session方法: 
1.用安卓解压软件把本zip解压到sd卡任意路径，比如/sdcard/tgsearch/
2.在termux窗口中执行：cd;cp /sdcard/tgsearch/tgsearch.arm32v7 .;chmod u+x tgsearch.arm32v7 
  注意，以上第2步必须执行，受安卓系统安全限制，任何二进制程序无法在/sdcard路径中直接执行，会报权限不够。
3.在termux窗口中继续执行：export API_FORCE_ANDROID=1;unset LD_PRELOAD;./tgsearch.arm32v7 -P socks5ip:socks5port
4.后续流程和本文开始讲述步骤一样。


==================================
在通过上述方式获取到session后就可以把session字符串填入影视的网盘配置-》网盘相关配置-》TG API_SESSION 中，然后就会被线路中自带的tgsearch调用到。配置中的API_ID,API_HASH可以省略
部分手机无法运行pg.xxxx.zip中预置的tgsearch，需要用本zip内的tgsearch.arm64v8替换到pg.xxxx.zip的js/lib中的tgsearch
