# 天机简介

[![GitHub stars](https://img.shields.io/github/stars/Safe3/tianji.svg?label=关注&nbsp;天机&style=for-the-badge)](https://github.com/Safe3/tianji)
[![Chat](https://img.shields.io/badge/Discuss-加入讨论组-7289da.svg?style=for-the-badge)](https://github.com/Safe3/tianji/discussions)

> **天机办公安全平台**（简称：天机）是有安科技推出的一款全方位办公安全防护产品。天机提供了**DNS安全服务器**功能，可以作为企业内部安全DNS服务器使用，提供域名解析和安全过滤功能。天机**云访问安全代理**（**CASB**）功能能有效保护各种办公服务，包括但不限于OA、ERP、HR、BOSS等办公系统的数据水印、数据脱敏、入侵防护、访问控制等。天机**安全Web网关**（**SWG**）功能可以对员工上网行为进行安全管控，包括访问控制、内容过滤、数据防泄漏、流量控制等，为企业营造绿色健康、安全稳定的办公上网环境。不仅如此，还可以通过天机的客户端管理**终端安全**。本产品是基于有安科技团队多年丰富安全攻防实战经验研发而成，为政府、企事业单位全面保护办公安全、满足国家法律要求提供完整的安全解决方案。

![](https://tianji.uusec.com/_media/osg.png)

🏠安装及使用请访问官网： https://tianji.uusec.com/



## :dart: 技术优势 <!-- {docsify-ignore} -->
 :libra: 先进的无密身份认证

  天机采用当前最新的**FIDO2**无密身份认证**PassKey**和**TOTP**动态口令技术抛弃老旧传统密码，可以完全解决用户弱口令、账户被盗、网络钓鱼攻击等身份认证风险难题（认证私钥存储于**TPM芯片**当中），并且相比传统用户名密码为基础的认证方式，易用性得到极大改善，用户无需记忆各种纷繁复杂的密码，使用Windows Hello、生物指纹、FaceID等即可一键单点登录（SSO）各种办公系统。

 :taurus: 便捷的DNS和证书服务

  天机内置**DNS域名解析**和**SSL证书签发**功能，企业无需购买商业域名和SSL证书。通过天机的安全DNS服务器，企业可以随意自定义任意内部域名包括.com、.net、.org等，并可以对外部DNS解析提供安全过滤。天机内置证书中心服务，可以自动对内部域名提供可信的https证书签发，所有CASB中站点将自动切换为HTTPS加密访问，并在终端电脑浏览器上显示为绿色可信连接。

 :ophiuchus: 全面的云访问保护技术

  天机创新性的运用**CASB**动态网关过滤和证书生成技术，对内各种办公服务无需做任何改造，即可实现对网页添加**数字水印**、对API和网页进行**动态数据脱敏**等功能，很好的照顾了各种老旧或无法改造的第三方办公系统，并且可以拦截各种**Web安全攻击**，提供和**Web应用防火墙-**WAF防护功能。免除客户因数据被盗或遭遇黑客攻击而触犯法律合规处罚的痛苦，保护企业声誉。

 :gemini: 高级的上网管理功能

  天机对比一般上网行为管理产品，内置**SWG**可以高效**无感知解密**https流量，并且支持包括恶意软件、钓鱼网站、挖矿域名、成人网站、赌博网站、广告隐私的拦截功能，为员工提供绿色、安全、健康、稳定的上网环境。可对外发内容和访问的网页进行关键词过滤和审计，满足法律监管合规要求。还提供了**数据防泄漏**和带宽流量控制功能，有效提升上网安全和办公体验。

 :scorpius: All in one终端安全管理功能

  天机客户端集成办公服务导航、零信任网络、终端安全、资产管理、软件商店、数据防泄漏等众多功能，解决了传统终端产品各自为战、功能单一、维护困难、成本高昂等一系列问题，全面提高办公安全效率和节约企业成本。

  

##  :art: 界面预览 <!-- {docsify-ignore} -->

天机为你提供了简单易用的Web后台管理界面和漂亮美观的客户端，注册登录后所有管理操作都可以在浏览器中完成，如下：

![](https://tianji.uusec.com/_media/agent.png)



## 快速入门

天机主要由两部分组成：天机网关以及天机客户端。网关用于身份管理、单点登录、双因素认证、DNS安全、云访问安全代理、安全Web网关、数据防泄漏等，可以集中管理并过滤网络流量，客户端负责终端安全、根证书安装、流量代理等功能。



##  :lemon:安装网关 <!-- {docsify-ignore} -->

注意：如有疑问，可加入 [有安科技微信群](https://waf.uusec.com/_media/weixin.jpg) 与社区用户共同讨论，或在 [天机论坛](https://github.com/Safe3/tianji/discussions) 内发帖求助。

### 环境要求 <!-- {docsify-ignore} -->

安装天机前请确保你的系统环境符合以下要求

- 操作系统：Linux
- CPU 指令架构：x86_64
- CPU 指令架构：支持 ssse3 指令集
- 最低资源需求：1 核 CPU / 1 GB 内存 / 5 GB 磁盘

### 自动安装 <!-- {docsify-ignore} -->

> 必须提前准备一个可以通过SMTP发送邮件的邮箱账号(注意：大部分免费邮箱需要单独开通SMTP功能，并需要设置专用密码才能登录，这里推荐 [完美邮箱](https://www.88.com/) )，安装过程中需要配置使用。

以 root 权限执行以下命令，根据命令提示输入相关配置信息，几分钟即可完成自动安装。

```bash
bash -c "$(curl -fsSLk https://tianji.uusec.com/download/latest/setup.sh)"
```

安装成功后会有提示信息，现在你需要安装客户端了



##  :melon:装客户端 <!-- {docsify-ignore} -->

> 天机客户端支持Windows、Linux、macOS系统。天机支持有客户端模式和无客户端模式，如若不安装客户端则需要手工推送根证书安装到终端电脑，并在防火墙或路由器上将80、443端口流量重定向到天机网关ip。

### 环境要求 <!-- {docsify-ignore} -->

安装天机客户端前请确保你的系统环境符合以下要求

- 微软系统：Windows 10/11 AMD64/ARM64
- 苹果系统：macOS 10.13+ AMD64、macOS 11.0+ ARM64
- Linux系统：Ubuntu 22.04+ AMD64/ARM64

### 下载安装 <!-- {docsify-ignore} -->

- 微软系统：[https://tianji.uusec.com/download/latest/tianji-setup.exe](https://tianji.uusec.com/download/latest/tianji-setup.exe)
- 苹果系统：[https://tianji.uusec.com/download/latest/tianji-setup.pkg](https://tianji.uusec.com/download/latest/tianji-setup.pkg)
- Linux系统：仅供商业定制用户



## :peach:开始使用 <!-- {docsify-ignore} -->

请提前在手机上安装一个动态口令软件如 [FreeOTP](https://freeotp.github.io/) 或 Google Authenticator 等

1. *运行后点击”网关设置“按钮，在设置界面输入网关ip地址，然后依次点击”应用“、”确定“按钮。*
2. *点击”登录注册“按钮，在打开的浏览器中输入邮箱后点击”注册“按钮发送验证码，将邮件收到的验证码输入下方输入框，点击”验证“按钮。*
3. *打开手机中动态口令软件扫描第二步中最后弹出的二维码录入动态口令密钥，输入6位数字动态口令后点击”登录“按钮，成功后即可看到个人信息页面，首次注册的用户默认为系统管理员账户。*
4. *在天机客户端点击”启动停止“按钮，开启客户端系统代理。浏览器打开 [https://tj.local/](https://tj.local/) ，输入用户名和动态口令后进入天机网关管理后台。*
4. *客户端DNS配置：方式一，进入企业路由器DHCP服务器设置，将“首选DNS服务器”修改为天机网关ip，所有办公电脑再次联网时会自动切换为天机安全DNS；方式二，本地电脑手工设置“首选DNS服务器”修改为天机网关ip，需要每个员工都进行配置。*

注意：由于天机使用了独特的单点登录认证技术，部分浏览器需要单独进行设置，否则浏览网页可能出现异常。Safari 浏览器请在“偏好设置”中关闭”阻止跨站跟踪“，Firefox 浏览器请在“隐私与安全” -> "增强跟踪保护" 自定义设置中关闭”跨网站跟踪性 cookie“。



## :kissing_heart: 加入讨论

欢迎各位就天机的各种bug或功能需求及使用问题，在如下渠道参与讨论

- 问题提交：https://github.com/Safe3/tianji/issues

- 讨论社区：https://github.com/Safe3/tianji/discussions

- 官方 QQ 群：11500614

- 官方微信群：微信扫描以下二维码加入

  <img src="https://waf.uusec.com/_media/weixin.jpg" alt="微信群"  height="200px" />

