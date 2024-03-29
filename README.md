# Ruby on Rails + Authing 例子
1. 初次写于 2021 年 5 月。
2. 更新于 2023 年 7 月 21 号。

## 介绍
本项目演示在 Ruby on Rails 中如何使用 Authing 实现用户身份管理（使用 [`authing_ruby`](https://rubygems.org/gems/authing_ruby) gem）   
无需自己实现注册登录（不需要使用 `devise` gem）

## 适合人群
想使用 Authing 的 Ruby on Rails 开发者。  

## 演示什么？
两种登录方式：  
1. 传统方式：cookie session 管理登录态
2. API 方式：一般用 JWT

## 运行前准备
1. 注册一个 [Authing 账号](http://authing.cn/) 并登录。
1. 登录 [Authing](https://console.authing.cn/console/userpool) 后新建一个"用户池"，名字随便填，比如"测试用户池"，类型可以选择 "to C"。
2. 运行命令 `cp .env.example .env`, 这条命令复制 `.env.example` 文件, 黏贴成新文件 `.env`, `.env` 文件用于提供环境变量给 Rails app，比如 Authing 所需的各项配置。
3. 填充 `.env` 文件里面的环境变量，比如 `app id`, `userpool id`, `app host`，因为必须要这些信息才能运行起来。
4. 设置回调地址，方法是 登录 Authing -> 选择某个用户池 -> 应用 -> URL设置 -> `登录回调 URL`, 写上 `http://localhost:3000/authing/callback` 因为这个 Rails 应用默认跑在 `3000` 端口，而 `authing/callback` 是对应 `routes.rb` 里的设置

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

2023-7-21 补充：我在 (硬件) Macbook Pro 2021 年款 14 寸，(系统) macOS (Ventura) 13.4.1，`rbenv install 2.6.3` 会报错，所以懒得处理了，直接添加了 Docker 运行方式（见下文）

## 如何运行 (使用 Docker)
```
docker compose build
docker compose up
```
访问 http://localhost:3000


## 传统方式 (使用 session)
1. 访问 [http://localhost:3000](http://localhost:3000)，此时页面上会显示"尚未登录"
![图 1](doc/img/149a5883ee57b539c447de4204e412fe1cd647f4d05499a8268e6cefb6f92c40.png)  

2. 点击右侧的"登录"按钮，会跳转到 Authing 的托管登录页。
![图 2](doc/img/95cd63ffa6a23d2d2eea8d68fb35b20e804efcc33db787f5e8d374f45a41a124.png)  


2. 注册：使用 `邮箱+密码` 或 `手机号+密码+验证码`，比如邮箱 `1@qq.com`, 密码 `123456789`
3. 注册完成后，进行登录
4. 此时会回到 `http://localhost:3000/` 看到登录成功的消息。并且显示邮箱 或 手机号（取决于你的注册方式）
![图 3](doc/img/b82906efc0f84e2aa0cd2ce7e2a5f95d748977b70fa31010b5247ca19282a735.png)  

## 传统方式是怎么实现的？
1. 用户登录态是用 session 实现，在 Ruby on Rails 里 session 数据默认是全部存到 Cookie 里，这个叫 `CookieStore`, 你也可以换成 Redis 来存， 具体细节可以看 [Securing Rails Applications](https://guides.rubyonrails.org/security.html#session-storage), 以及 [Action Controller Overview#Session](https://guides.rubyonrails.org/action_controller_overview.html#session) 这个是 Rails 的东西，和  Authing 毫无关系

2. 当用户访问 `http://localhost:3000/` 时，我们判断 `session[:user_id]` 是否存在，如果有就当做已登录，没有就是没登录

3. 点击"登录"按钮会跳转到 Authing 的认证地址，这个地址来自于: `某用户池`->`某应用`->`基础设置`->`认证地址`

4. 登录成功后，页面会跳转到回调地址，这个回调地址来自于: `某用户池`->`某应用`->`URL设置`->`登录回调地址`，我这里设置的是 `http://localhost:3000/authing/callback` 跳转到这个地址时会带上参数，完整 URL 例子：`http://localhost:3000/authing/callback?code=ZndQ4xxhds3kNHlaXYgOSKhBVEhEHLmN1HOX3O8IZf9&state=tL5NYtMet` 这个 `code` 参数是核心

5. 拿到 code 后，用它来换取 AccessToken (`getAccessTokenByCode(code)`)

6. AccessToken 可以用来换取用户信息 (`getUserInfoByAccessToken(access_token)`)

7. 用户信息里有一个 `sub`，是用户独一无二的 ID, 比如 `609678b09079b7a7cea20541`

8. 我们用这个 `用户 ID` 来查找/新建 User 纪录即可，比如 `user = User.find_or_create_by(authing_user_id: sub)`

9. 最后设置一下 session: `session[:user_id] = user.id ` 就结束了

以上这种方式来自于文档 [概念->单点登录与单点登出->标准协议认证](https://docs.authing.cn/v2/concepts/single-sign-on-and-single-sign-out.html#%E6%A0%87%E5%87%86%E5%8D%8F%E8%AE%AE%E8%AE%A4%E8%AF%81)

> Authing 支持 OIDC、OAuth 2.0、SAML2、CAS 1.0、LDAP 标准认证协议。标准协议会按照特定的方式传递用户信息，例如 OIDC 协议中，用户认证后 Authing 不会直接将用户的信息返回，而是返回一个授权码 code，再使用 code 在业务后端换取 Access token，再用 Access token 获取用户信息。成熟、正规的业务系统产品都会支持标准协议，使用标准协议对接可以一劳永逸地完成对接。标准协议的推荐度：OIDC > SAML2 > CAS 1.0 > LDAP > OAuth2.0。

### 问题来了：为什么要 code 换 token 再换用户信息？   
应用登录后的这个页面（应用新建后记得保持默认设置，不要设置回调地址，就会显示这个）   
有给出答案。  

![图 1](doc/img/03a01d8c504e3256dcfd8919ed8984ed437417ea3f00ae8eef240bf6b3972b79.png)   

![图 2](doc/img/af8e0e81e3a9a5133559dfc5e89cbeb2cec87b69dd3c3c3cf353af3197e5c4ca.png)   

[为什么要 code 换 token 再换用户信息？](https://docs.authing.cn/v2/concepts/oidc-common-questions.html#%E4%B8%BA%E4%BB%80%E4%B9%88-oidc-%E6%8E%88%E6%9D%83%E7%A0%81%E6%B5%81%E7%A8%8B%E8%A6%81-code-%E6%8D%A2-token-%E5%86%8D%E6%8D%A2%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF)

![图 3](doc/img/bc631b408e8cadb4ccfd63275c0e892cddef1eb4e542d0a7e4166a6525127c8c.png)  



## API 方式
这个部分不需要写代码演示了，把核心概念和流程讲清楚，读者就知道怎么做了。      

API 的话，一般后端只提供 API 接口，可以是 REST API 或 GraphQL。      
前端可能是一个网页 SPA(Single Page Application)，比如 React.js/Vue.js 等。      
前端也可能是 App (安卓/iOS) 或微信小程序。       

前后端之间不能再用 cookie 和 session 做身份验证了。   
此时一般用 token。token 具体实现一般选 JWT (JSON Web Token)。    
这时候有两种做法：   

* 做法1：自己生成 JWT
* 做法2：直接用 Authing 登录后的 token (他们叫这个 ID token, 其实也就是一个 JWT)    

## JWT 的基本概念
1. JWT 默认只签名，没加密，所以 payload (实际数据部分) 谁都可以看到，只是做了 base64 编码而已。不能在 payload 里面存放任何机密消息（比如登录密码的明文）

2. 收到 JWT 第一件事就是验证签名，确保没有被篡改，验证签名之后 payload 才是可信的。

3. JWT 的常用算法有：
* HMAC + SHA256
* RSASSA-PKCS1-v1_5 + SHA256
* ECDSA + P-256 + SHA256   

[常用算法的资料来源](https://auth0.com/blog/json-web-token-signing-algorithms-overview/)     
额外补充：Ruby 的 `jwt` gem 支持 HMAC, RSASSA and ECDSA.     


## 做法1：自己生成 JWT
* 好处：可以自己选签名算法，自由度更高，payload 随便自己定义。比如 `{user_id: 2}`
* 坏处：需要花时间去选算法 (这个其实不算多大的坏处，直接选 HS256 也可以)

## 做法2：直接用 Authing 登录后的 token  
举例：         

（完整代码可参照 Authing Ruby SDK(`authing_ruby` gem) 里的 `example/7.loginByUsername.rb`）      
```ruby
username = "user9527" # 用户名
password = "12345678" # 密码
response = authenticationClient.loginByUsername(username, password)

# 登录成功后返回：
puts response
# {"id"=>"6094e8f02996bde98a56ed01", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e8f02996bde98a56ed01", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>"user9527", "email"=>nil, "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:username-password"], "photo"=>"https://files.authing.co/authing-console/default-user-avatar.png", "password"=>"8ec053e999798c3f82cb55bb8c5fc760", "oauth"=>nil, "token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDk0ZThmMDI5OTZiZGU5OGE1NmVkMDEiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0wN1QwNzoxNDo1Ni43MjBaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjpudWxsLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6bnVsbCwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJleHRlcm5hbF9pZCI6bnVsbCwidW5pb25pZCI6bnVsbCwiZGF0YSI6eyJ0eXBlIjoidXNlciIsInVzZXJQb29sSWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhcHBJZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImlkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwidXNlcklkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwiX2lkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwicGhvbmUiOm51bGwsImVtYWlsIjpudWxsLCJ1c2VybmFtZSI6InVzZXI5NTI3IiwidW5pb25pZCI6bnVsbCwib3BlbmlkIjpudWxsLCJjbGllbnRJZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCJ9LCJ1c2VycG9vbF9pZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCIsImF1ZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImV4cCI6MTYyMTU4MTI5OCwiaWF0IjoxNjIwMzcxNjk4LCJpc3MiOiJodHRwczovL3JhaWxzLWRlbW8uYXV0aGluZy5jbi9vaWRjIn0.YFIsdbSHKzpYdjgnBTnmGK8Cf1wzxrHsikKG-2pcLSo", "tokenExpiredAt"=>"2021-05-21T07:14:58+00:00", "loginsCount"=>1, "lastLogin"=>"2021-05-07T07:14:58+00:00", "lastIP"=>"223.104.66.68", "signedUp"=>"2021-05-07T07:14:56+00:00", "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:14:56+00:00", "updatedAt"=>"2021-05-07T07:14:58+00:00", "externalId"=>nil}
```

这里有个 `token` 字段，我们可以直接用它。   
再次强调它是个 JWT, 如果直接复制粘贴到 `jwt.io` 可以看到内容，它的 payload 是    
```json
{
  "sub": "6094e8f02996bde98a56ed01",
  "birthdate": null,
  "family_name": null,
  "gender": "U",
  "given_name": null,
  "locale": null,
  "middle_name": null,
  "name": null,
  "nickname": null,
  "picture": "https://files.authing.co/authing-console/default-user-avatar.png",
  "preferred_username": null,
  "profile": null,
  "updated_at": "2021-05-07T07:14:56.720Z",
  "website": null,
  "zoneinfo": null,
  "address": {
    "country": null,
    "postal_code": null,
    "region": null,
    "formatted": null
  },
  "phone_number": null,
  "phone_number_verified": false,
  "email": null,
  "email_verified": false,
  "external_id": null,
  "unionid": null,
  "data": {
    "type": "user",
    "userPoolId": "60800b8ee5b66b23128b4980",
    "appId": "60800b9151d040af9016d60b",
    "id": "6094e8f02996bde98a56ed01",
    "userId": "6094e8f02996bde98a56ed01",
    "_id": "6094e8f02996bde98a56ed01",
    "phone": null,
    "email": null,
    "username": "user9527",
    "unionid": null,
    "openid": null,
    "clientId": "60800b8ee5b66b23128b4980"
  },
  "userpool_id": "60800b8ee5b66b23128b4980",
  "aud": "60800b9151d040af9016d60b",
  "exp": 1621581298,
  "iat": 1620371698,
  "iss": "https://rails-demo.authing.cn/oidc"
}
```

直接把这个登录后的 token 返回给客户端，原封不动。  
客户端每次在 HTTP 请求头里带过来 `Authorization: Bearer <token>`    
服务端每次验证签名，得到 `"sub": "6094e8f02996bde98a56ed01"` 把这个作为用户 id 来在数据库里找。  

好处：省事，不用自己选签名算法，Authing 目前支持 HS256 和 RS256 (应用 -> 授权 -> id_token 签名算法)     
签名 JWT 的 secret 也保存在 Authing 上，不用自己管理。  


## 推荐用那种做法？做法1还是做法2？
推荐做法1：自己做 JWT。      
如果用做法2，直接用 Authing 返回的 ID token， 
payload 数据里面包含了太多东西，比如：  
```json
  "phone_number": null,
  "email": null,
  "address": {
    "country": null,
    "postal_code": null,
    "region": null,
    "formatted": null
  },
```

手机号，邮件，地址是很关键的数据。      
而且 name 和 nickname 用户可能填自己的真名。       
假设用户的 JWT 因为某种原因被恶意第三方拿到了，这些数据就泄露了。(因为 JWT 的 payload 是没加密的)   
所以干脆 payload 里只放一个 `{user_id: 1}` 就行，验证签名后就可信了。     

## 其他
* 如果不希望每次都初始化了再用（这样比较麻烦），可以参照 `config/initializers/authing_ruby.rb` 的写法。  

## 更新日志

### 2023-7-21 更新日志
1. 添加了 Dockerfile 和 compose.yml，方便以 Docker 方式本地运行。
2. 更新了文档说明 (README.md)，因为 Authing 那边的菜单和操作方式有一些变化。

## 备注：截止到 2023-7-21 只有 2 个 gem 支持 Authing。
  * [`authing_ruby` gem](https://rubygems.org/gems/authing_ruby) (我写的) 
  * [`authing` gem](https://rubygems.org/gems/authing)

## 待办事项 (TODO)
1. 新建一个 `authing_rails` gem，进一步简化所有操作，节省开发者时间。

### 使用流程举例：
1. Gemfile 里加了 `authing_rails` 之后，只需要写 `/config/initializers/authing.rb`，在里面配置 App ID, App Secret, App Host, Redirect URI, UserPool ID。
2. 然后给 routes.rb 里加上几条路由。用途是处理 REDIRECT_URI，登录成功后的跳转。
3. 然后给 Controller 和 View 里提供几个 helper 方法。用途是判断是否已登录。
4. 总而言之：`authing_rails` 应当比 `authing_ruby` 用起来更简单。尽可能节省时间。

