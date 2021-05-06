# Ruby on Rails + Authing 例子
本项目演示如何使用 Ruby on Rails + Authing 实现用户身份管理（注册登录）    
可以替换掉自制注册登录，以及 `devise`  

## 当前进展
制作中

## 问题
1. 对于一个前后端分离的项目，比如 React+Rails 或 Vue+Rails，加入 Authing 后有何不同？
2. 对于一个传统的 Rails 项目（用 `app/views/`）又怎么用 Authing？
3. 忘记密码怎么做？
4. 登录页面怎么做？

## 使用方法

### 先填入必须的信息到 .env
```
cp .env.example .env
``` 

`.env.example` 是一个文件模板，这条命令复制这个文件变为 `.env`

### 安装依赖
```
bundle install
```

### 运行
```
rails s
```

<!--

## 说明
* 方法1：[登录注册页完全托管给 Authing](https://docs.authing.cn/v2/guides/authentication/basic/password/#%E4%BD%BF%E7%94%A8-api-sdk)

-->