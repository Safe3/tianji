# 快速入门

!> 天机主要由两部分组成：天机网关以及天机客户端。网关用于身份管理、单点登录、双因素认证、DNS安全、云访问安全代理、安全Web网关、数据防泄漏等，可以集中管理并过滤网络流量，客户端负责终端安全、根证书安装、流量代理等功能。



##  :lemon:安装网关
?> 如有疑问，可加入 [有安科技微信群](https://waf.uusec.com/_media/weixin.jpg) 与社区用户共同讨论，或在 [天机论坛](https://github.com/Safe3/tianji/discussions) 内发帖求助。

### 环境要求

安装天机前请确保你的系统环境符合以下要求

- 操作系统：Linux
- CPU 指令架构：x86_64
- CPU 指令架构：支持 ssse3 指令集
- 最低资源需求：1 核 CPU / 1 GB 内存 / 5 GB 磁盘

### 自动安装

必须提前准备一个可以通过SMTP发送邮件的邮箱账号(注意：大部分免费邮箱需要单独开通SMTP功能，并需要设置专用密码才能登录，这里推荐 [完美邮箱](https://www.88.com/) )，安装过程中需要配置使用。以 root 权限执行以下命令，根据命令提示输入相关配置信息，几分钟即可完成自动安装。

```bash
bash -c "$(curl -fsSLk https://tianji.uusec.com/download/latest/setup.sh)"
```

安装成功后会有提示信息，现在你需要安装客户端了



##  :melon:安装客户端

?> 天机客户端支持Windows、Linux、macOS系统。天机支持有客户端模式和无客户端模式，如若不安装客户端则需要手工推送根证书安装到终端电脑，并在防火墙或路由器上将80、443端口流量重定向到天机网关ip。

### 环境要求

安装天机客户端前请确保你的系统环境符合以下要求

- 微软系统：Windows 10/11 AMD64/ARM64
- Linux系统：Ubuntu 22.04+ AMD64/ARM64
- 苹果系统：macOS 10.13+ AMD64、macOS 11.0+ ARM64

### 下载安装

- 微软系统：[https://tianji.uusec.com/download/latest/tianji-setup.exe](https://tianji.uusec.com/download/latest/tianji-setup.exe)
- 苹果系统：[https://tianji.uusec.com/download/latest/tianji-setup.pkg](https://tianji.uusec.com/download/latest/tianji-setup.pkg)
- Linux系统：仅供商业用户

### 开始使用

提前在手机上安装一个动态口令软件如 [FreeOTP](https://freeotp.github.io/) 或 Google Authenticator 等

1. 运行后点击”网关设置“按钮，在设置界面输入网关ip地址，然后依次点击”应用“、”确定“按钮。
2. 点击”登录注册“按钮，在打开的浏览器中输入邮箱后点击”注册“按钮发送验证码，将邮件收到的验证码输入下方输入框，点击”验证“按钮。
3. 打开手机中动态口令软件扫描第二步中最后弹出的二维码录入动态口令密钥，输入6位数字动态口令后点击”登录“按钮，成功后即可看到个人信息页面，首次注册的用户默认为系统管理员账户。
4. 在天机客户端点击”启动停止“按钮，开启客户端系统代理。浏览器打开 [https://tj.local/](https://tj.local/) ，输入用户名和动态口令后进入天机网关管理后台。
4. 由于天机使用了独特的单点登录认证技术，部分浏览器需要单独进行设置，否则浏览网页可能出现异常。Safari 浏览器请在“偏好设置”中关闭”阻止跨站跟踪“，Firefox 浏览器请在“隐私与安全” -> "增强跟踪保护" 自定义设置中关闭”跨网站跟踪性 cookie“。
