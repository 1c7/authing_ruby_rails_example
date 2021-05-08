# Ruby on Rails + Authing 例子

## 介绍
本项目演示在 Ruby on Rails 中如何使用 Authing 实现用户身份管理（使用 `authing_ruby` gem）   
也就是无需自己写注册登录（比如用 `devise` gem）

## 适合人群
想使用 Authing 的 Rails 开发者。

## 如何演示
本项目演示两种登录方式：  
1. 传统方式：cookie session 管理登录态
2. JWT 方式：适合做 API 后端


## 运行前的准备
1. 登录 Authing 后新建一个"用户池"，名字比如"测试用户池"(或其他任意名字)
2. 运行 `cp .env.example .env`，目的是复制一下文件，复制 `.env.example` 文件为 `.env`
3. 根据 `.env` 文件里的提示，填写用户池的各项信息，比如 `app id`, `userpool id`, `app host`

## 如何运行
### 安装依赖
```
bundle install
```

### 运行
```
rails s
```
访问 http://localhost:3000


## 如何体验整个登录流程

### 传统方式
1. 访问 XX 页面，会看到 YY，点击登录，会跳转到 Authing 的托管登录页。
2. 进行注册
3. 进行登录
4. 阅读 ZZ，理解整个流程和核心概念。  

### JWT 方式


## 常见问题
1. 对于一个前后端分离的项目，比如 React+Rails 或 Vue+Rails，加入 Authing 后有何不同？
	* 同样用 JWT 管理

2. 对于一个传统的 Rails 项目（用 `app/views/`）又怎么用 Authing？
	* 自己通过 cookie+session 实现登录态

3. 忘记密码怎么做？
	* 先登出，然后在 Authing 的托管登录页面做
	* 如果不用 Authing 提供的托管页面做，希望用自定义的界面
	* [通过短信验证码重置密码](https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E9%80%9A%E8%BF%87%E7%9F%AD%E4%BF%A1%E9%AA%8C%E8%AF%81%E7%A0%81%E9%87%8D%E7%BD%AE%E5%AF%86%E7%A0%81)
	* [通过邮件验证码重置密码](https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E9%80%9A%E8%BF%87%E9%82%AE%E4%BB%B6%E9%AA%8C%E8%AF%81%E7%A0%81%E9%87%8D%E7%BD%AE%E5%AF%86%E7%A0%81)

4. 更新密码怎么做？
	* [更新密码](https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E6%9B%B4%E6%96%B0%E7%94%A8%E6%88%B7%E5%AF%86%E7%A0%81)

4. 注册/登录页面怎么做？

5. 手机号+验证码登录怎么做？

6. 邮箱+验证码怎么做？

7. 用户资料怎么处理？就是头像，昵称，性别，出生日期
