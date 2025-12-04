# Sub-Store 项目分析文档

> 版本：v2.20.47  
> 项目地址：https://github.com/sub-store-org/Sub-Store  
> 官方文档：https://xream.notion.site/Sub-Store-abe6a96944724dc6a36833d5c9ab7c87

---

## 一、项目概述

**Sub-Store** 是一个高级代理订阅管理工具，专为代理客户端设计，支持订阅格式转换、节点过滤、多订阅合并等功能。

### 支持的客户端

| 客户端 | 平台 | 支持状态 |
|--------|------|----------|
| Quantumult X (QX) | iOS | ✅ 完整支持 |
| Loon | iOS | ✅ 完整支持 |
| Surge | iOS/macOS | ✅ 完整支持 |
| Stash | iOS | ✅ 完整支持 |
| Egern | iOS | ✅ 完整支持 |
| Shadowrocket | iOS | ✅ 完整支持 |
| Clash.Meta (mihomo) | 多平台 | ✅ 完整支持 |
| sing-box | 多平台 | ✅ 完整支持 |
| V2Ray | 多平台 | ✅ 完整支持 |

---

## 二、核心功能详解

### 2.1 订阅格式转换

Sub-Store 的核心功能是在不同代理客户端格式之间进行转换。

#### 支持的输入格式

| 格式类型 | 具体协议/格式 |
|----------|---------------|
| **URI 协议** | socks5, socks5+tls, http, https |
| **标准 URI** | AnyTLS, SOCKS, SS, SSR, VMess, VLESS, Trojan, Hysteria, Hysteria 2, TUIC v5, WireGuard |
| **Clash 格式** | Clash Proxies YAML, Clash Proxy JSON (单行) |
| **QX 格式** | SS, SSR, VMess, Trojan, HTTP, SOCKS5, VLESS |
| **Loon 格式** | SS, SSR, VMess, Trojan, HTTP, SOCKS5, SOCKS5-TLS, WireGuard, VLESS, Hysteria 2 |
| **Surge 格式** | Direct, SS, VMess, Trojan, HTTP, SOCKS5, SOCKS5-TLS, TUIC, Snell, Hysteria 2, SSH, WireGuard |
| **Surfboard 格式** | SS, VMess, Trojan, HTTP, SOCKS5, SOCKS5-TLS, WireGuard |
| **Clash.Meta 格式** | Direct, SS, SSR, VMess, Trojan, HTTP, SOCKS5, Snell, VLESS, WireGuard, Hysteria, Hysteria 2, TUIC, SSH, mieru, sudoku, AnyTLS |
| **Stash 格式** | SS, SSR, VMess, Trojan, HTTP, SOCKS5, Snell, VLESS, WireGuard, Hysteria, TUIC, Juicity, SSH |

#### 支持的输出平台

| 平台 | 说明 |
|------|------|
| Plain JSON | 纯 JSON 格式输出 |
| Stash | Stash 客户端格式 |
| Clash.Meta (mihomo) | Clash Meta 内核格式 |
| Surfboard | Surfboard 客户端格式 |
| Surge | Surge iOS 格式 |
| SurgeMac | Surge macOS 格式（使用 mihomo 支持额外协议） |
| Loon | Loon 客户端格式 |
| Egern | Egern 客户端格式 |
| Shadowrocket | Shadowrocket 客户端格式 |
| QX | Quantumult X 格式 |
| sing-box | sing-box 核心格式 |
| V2Ray | V2Ray 配置格式 |
| V2Ray URI | V2Ray 链接格式 |

---

### 2.2 订阅格式化处理

#### 过滤器 (Filters)

| 过滤器类型 | 功能说明 |
|------------|----------|
| **Regex filter** | 正则表达式过滤，保留匹配的节点 |
| **Discard regex filter** | 排除正则过滤，移除匹配的节点 |
| **Region filter** | 地区过滤，按国家/地区筛选 |
| **Type filter** | 类型过滤，按协议类型筛选 |
| **Useless proxies filter** | 无效节点过滤，移除不可用节点 |
| **Script filter** | 脚本过滤，使用自定义脚本筛选 |

#### 节点操作 (Proxy Operations)

| 操作类型 | 功能说明 |
|----------|----------|
| **Set property operator** | 设置节点属性（udp、tfo、skip-cert-verify 等） |
| **Flag operator** | 添加或移除节点名称中的国旗 emoji |
| **Sort operator** | 按名称排序节点 |
| **Regex sort operator** | 按关键词正则排序（支持回退到普通排序） |
| **Regex rename operator** | 正则重命名，替换节点名称中的内容 |
| **Regex delete operator** | 正则删除，移除节点名称中的内容 |
| **Script operator** | 脚本操作，使用自定义脚本修改节点 |
| **Resolve Domain Operator** | 域名解析，将节点域名解析为 IP 地址 |

---

### 2.3 多订阅合并

将多个订阅源整合为一个统一的订阅链接。

#### 订阅类型

| 类型 | 说明 |
|------|------|
| **单条订阅 (Subscription)** | 管理单个订阅源，支持本地和远程 |
| **组合订阅 (Collection)** | 合并多个单条订阅为一个 |
| **订阅标签** | 通过标签自动分组管理订阅 |

#### 合并模式

- **localFirst**: 本地内容优先，远程内容追加
- **remoteFirst**: 远程内容优先，本地内容追加

---

### 2.4 同步与备份

#### Gist 同步

- 支持 GitHub Gist 和 GitLab Snippet
- 将处理后的配置自动上传到云端
- 生成永久可用的订阅链接

#### 定时任务

| 环境变量 | 功能 |
|----------|------|
| `SUB_STORE_BACKEND_SYNC_CRON` | 定时同步所有配置到 Gist |
| `SUB_STORE_PRODUCE_CRON` | 定时处理指定订阅 |
| `SUB_STORE_BACKEND_DOWNLOAD_CRON` | 定时从 Gist 下载备份 |
| `SUB_STORE_BACKEND_UPLOAD_CRON` | 定时上传备份到 Gist |
| `SUB_STORE_MMDB_CRON` | 定时更新 GeoIP 数据库 |

---

## 三、技术架构

### 3.1 项目结构

```
Sub-Store/
├── backend/                    # 后端代码
│   ├── src/
│   │   ├── main.js            # 入口文件
│   │   ├── constants.js       # 常量定义
│   │   ├── core/              # 核心模块
│   │   │   ├── app.js         # 应用实例
│   │   │   ├── proxy-utils/   # 代理处理工具
│   │   │   │   ├── parsers/   # 解析器
│   │   │   │   ├── processors/# 处理器
│   │   │   │   ├── producers/ # 生成器
│   │   │   │   ├── preprocessors/ # 预处理器
│   │   │   │   └── validators/# 验证器
│   │   │   └── rule-utils/    # 规则处理工具
│   │   ├── restful/           # RESTful API
│   │   │   ├── index.js       # API 路由注册
│   │   │   ├── subscriptions.js # 订阅管理
│   │   │   ├── collections.js # 组合订阅
│   │   │   ├── artifacts.js   # 同步配置
│   │   │   ├── sync.js        # 同步功能
│   │   │   ├── settings.js    # 设置管理
│   │   │   ├── file.js        # 文件管理
│   │   │   ├── module.js      # 模块管理
│   │   │   └── ...
│   │   ├── utils/             # 工具函数
│   │   │   ├── database.js    # 数据库操作
│   │   │   ├── download.js    # 下载功能
│   │   │   ├── geo.js         # 地理位置
│   │   │   ├── gist.js        # Gist 操作
│   │   │   └── ...
│   │   └── vendor/            # 第三方库适配
│   ├── package.json           # 依赖配置
│   └── dist/                  # 构建输出
├── config/                    # 客户端配置文件
│   ├── Loon.plugin           # Loon 插件
│   ├── Surge.sgmodule        # Surge 模块
│   ├── QX.snippet            # QX 重写
│   ├── Stash.stoverride      # Stash 覆写
│   └── Egern.yaml            # Egern 模块
└── scripts/                   # 示例脚本
    ├── demo.js               # 演示脚本
    ├── ip-flag.js            # IP 添加旗帜
    └── ...
```

### 3.2 核心处理流程

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           Sub-Store 处理流程                              │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────┐    ┌─────────────┐    ┌─────────┐    ┌─────────────────┐   │
│  │ 原始订阅 │ -> │  预处理器   │ -> │ 解析器  │ -> │ 统一代理对象格式 │   │
│  │ (各种格式)│    │(Preprocessor)│   │(Parser) │    │   (Proxy[])     │   │
│  └─────────┘    └─────────────┘    └─────────┘    └─────────────────┘   │
│                                                            │             │
│                                                            ▼             │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │                        处理器 (Processor)                           │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐            │ │
│  │  │ 过滤器   │  │ 排序器   │  │ 重命名器 │  │ 脚本处理 │  ...       │ │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘            │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                          │                               │
│                                          ▼                               │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │                        生成器 (Producer)                            │ │
│  │  ┌───────┐ ┌───────┐ ┌──────┐ ┌────┐ ┌──────────┐ ┌────────┐      │ │
│  │  │ Surge │ │ Clash │ │ Loon │ │ QX │ │ sing-box │ │ V2Ray  │ ...  │ │
│  │  └───────┘ └───────┘ └──────┘ └────┘ └──────────┘ └────────┘      │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                          │                               │
│                                          ▼                               │
│                               ┌─────────────────┐                        │
│                               │ 目标平台配置输出 │                        │
│                               └─────────────────┘                        │
└──────────────────────────────────────────────────────────────────────────┘
```

### 3.3 RESTful API 接口

#### 订阅管理

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/subs` | 获取所有订阅 |
| POST | `/api/subs` | 创建订阅 |
| PUT | `/api/subs` | 替换所有订阅 |
| GET | `/api/sub/:name` | 获取指定订阅 |
| PATCH | `/api/sub/:name` | 更新指定订阅 |
| DELETE | `/api/sub/:name` | 删除指定订阅 |
| GET | `/api/sub/flow/:name` | 获取订阅流量信息 |

#### 组合订阅管理

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/collections` | 获取所有组合订阅 |
| POST | `/api/collections` | 创建组合订阅 |
| GET | `/api/collection/:name` | 获取指定组合订阅 |
| PATCH | `/api/collection/:name` | 更新指定组合订阅 |
| DELETE | `/api/collection/:name` | 删除指定组合订阅 |

#### 同步管理

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/sync/artifacts` | 同步所有配置 |
| GET | `/api/sync/artifact/:name` | 同步指定配置 |

#### 下载/预览

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/download/sub/:name` | 下载订阅（转换后） |
| GET | `/download/collection/:name` | 下载组合订阅（转换后） |
| GET | `/api/preview/sub/:name` | 预览订阅节点 |
| GET | `/api/preview/collection/:name` | 预览组合订阅节点 |

---

## 四、依赖技术栈

### 后端依赖

| 依赖 | 版本 | 用途 |
|------|------|------|
| express | ^4.17.1 | Web 框架 |
| lodash | ^4.17.21 | 工具库 |
| js-base64 | ^3.7.2 | Base64 编解码 |
| static-js-yaml | ^1.0.0 | YAML 解析 |
| json5 | ^2.2.3 | JSON5 解析 |
| cron | ^3.1.6 | 定时任务 |
| undici | ^7.4.0 | HTTP 客户端 |
| @maxmind/geoip2-node | ^5.0.0 | GeoIP 查询 |
| ip-address | ^9.0.5 | IP 地址处理 |
| nanoid | ^3.3.3 | ID 生成 |

### 开发依赖

| 依赖 | 用途 |
|------|------|
| esbuild | 代码打包 |
| gulp | 构建工具 |
| babel | 代码转译 |
| mocha/chai | 测试框架 |
| peggy | 语法解析器生成 |

---

## 五、部署指南

### 5.1 客户端内部署（推荐）

直接在代理客户端中安装对应的模块/插件：

#### Loon

```
插件地址：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Loon.plugin
```

#### Surge

```
# 默认版（支持编辑参数）
https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule

# Beta 版（支持最新特性）
https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge-Beta.sgmodule

# 带 ability 参数版（用于指定节点功能）
https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge-ability.sgmodule

# 不带 ability 参数版
https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge-Noability.sgmodule
```

#### Quantumult X

```
重写地址：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/QX.snippet
定时任务：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/QX-Task.json
```

#### Stash

```
覆写地址：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Stash.stoverride
```

#### Shadowrocket

```
模块地址：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge-Noability.sgmodule
```

#### Egern

```
模块地址：https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Egern.yaml
```

安装后访问 **https://sub.store** 即可使用 Web 界面。

---

### 5.2 服务器部署

#### 服务器需求

##### 最低配置

| 资源 | 最低要求 | 说明 |
|------|----------|------|
| **CPU** | 1 核 | 单核即可运行 |
| **内存** | 256MB | 基础运行内存 |
| **存储** | 500MB | 包含 Node.js、依赖和数据 |
| **网络** | 需要公网 IP 或域名 | 用于订阅链接访问 |
| **系统** | Linux/Windows/macOS | 支持 Node.js 的系统均可 |

##### 推荐配置

| 资源 | 推荐配置 | 说明 |
|------|----------|------|
| **CPU** | 1-2 核 | 处理大量订阅时更流畅 |
| **内存** | 512MB - 1GB | 处理复杂脚本和大订阅需要更多内存 |
| **存储** | 1GB+ | 包含 GeoIP 数据库和缓存 |
| **带宽** | 1Mbps+ | 取决于用户数量和订阅更新频率 |

##### 资源消耗分析

| 场景 | CPU 占用 | 内存占用 | 说明 |
|------|----------|----------|------|
| **空闲状态** | < 1% | ~50-80MB | Node.js 进程基础占用 |
| **单次订阅转换** | 5-20% | ~100-150MB | 取决于节点数量 |
| **大量节点处理** | 20-50% | ~200-400MB | 处理 500+ 节点时 |
| **脚本操作** | 10-30% | ~150-300MB | 执行自定义脚本 |
| **GeoIP 查询** | 5-15% | +50-100MB | 加载 MMDB 数据库 |

##### 注意事项

1. **内存敏感**：处理大量节点或复杂脚本时内存消耗较大
2. **网络依赖**：需要能访问订阅源 URL（可能需要代理）
3. **存储增长**：缓存和日志会随时间增长，建议定期清理
4. **并发处理**：多用户同时请求时资源消耗会叠加

##### 适合的服务器类型

| 服务器类型 | 适用场景 | 预估成本 |
|------------|----------|----------|
| **VPS 最低配** | 个人使用，少量订阅 | $3-5/月 |
| **VPS 入门配** | 家庭/小团队使用 | $5-10/月 |
| **树莓派** | 家庭内网使用 | 一次性硬件成本 |
| **NAS** | 家庭 24h 运行 | 已有设备无额外成本 |
| **Cloudflare Workers** | 免费额度内使用 | 免费 |
| **Vercel/Railway** | 免费额度内使用 | 免费/按量付费 |

---

#### 软件环境要求

| 软件 | 版本要求 | 说明 |
|------|----------|------|
| **Node.js** | >= 16.x | 推荐 18.x LTS 或 20.x LTS |
| **pnpm** | >= 7.x | 包管理器（必需） |
| **Git** | 任意版本 | 用于克隆代码 |

##### 可选软件

| 软件 | 用途 |
|------|------|
| **Nginx/Caddy** | 反向代理、HTTPS、域名绑定 |
| **PM2** | 进程管理、自动重启 |
| **Docker** | 容器化部署 |

---

#### 安装步骤

```bash
# 1. 克隆项目
git clone https://github.com/sub-store-org/Sub-Store.git
cd Sub-Store/backend

# 2. 安装 pnpm（如未安装）
npm install -g pnpm

# 3. 安装依赖
pnpm install

# 4. 构建项目
pnpm bundle:esbuild

# 5. 运行服务
node sub-store.min.js
```

#### 环境变量配置

创建 `.env` 文件或设置系统环境变量：

```bash
# 后端配置
SUB_STORE_BACKEND_API_PORT=3000          # API 端口
SUB_STORE_BACKEND_API_HOST=::            # 监听地址（:: 表示所有地址）

# 前端配置（可选，用于前后端合并部署）
SUB_STORE_FRONTEND_PATH=/path/to/frontend  # 前端文件路径
SUB_STORE_FRONTEND_PORT=3001               # 前端端口
SUB_STORE_FRONTEND_HOST=::                 # 前端监听地址
SUB_STORE_FRONTEND_BACKEND_PATH=/api       # 后端 API 路径前缀
SUB_STORE_BACKEND_MERGE=true               # 前后端合并模式

# 定时任务配置
SUB_STORE_BACKEND_SYNC_CRON="0 */6 * * *"  # 每6小时同步一次
SUB_STORE_PRODUCE_CRON="0 */2 * * *,sub,订阅名"  # 定时处理订阅

# 数据恢复
SUB_STORE_DATA_URL=https://example.com/backup.json  # 启动时恢复数据

# GeoIP 数据库更新
SUB_STORE_MMDB_CRON="0 0 * * 0"            # 每周日更新
SUB_STORE_MMDB_COUNTRY_PATH=/path/to/Country.mmdb
SUB_STORE_MMDB_COUNTRY_URL=https://example.com/Country.mmdb
SUB_STORE_MMDB_ASN_PATH=/path/to/ASN.mmdb
SUB_STORE_MMDB_ASN_URL=https://example.com/ASN.mmdb
```

#### 开发模式

```bash
cd backend
pnpm install
SUB_STORE_BACKEND_API_PORT=3000 pnpm run --parallel "/^dev:.*/"
```

---

### 5.3 Docker 部署

#### 基础部署

```bash
# 使用 GitHub Container Registry 镜像
docker run -d \
  --name sub-store \
  --restart always \
  -p 3000:3000 \
  -v /path/to/data:/data \
  ghcr.io/moearly/sub-store
```

#### 带前端的完整部署

```bash
docker run -d \
  --name sub-store \
  --restart always \
  -p 3000:3000 \
  -e SUB_STORE_FRONTEND_PATH=/frontend \
  -e SUB_STORE_BACKEND_MERGE=true \
  -v /path/to/data:/data \
  ghcr.io/moearly/sub-store
```

#### Docker Compose

```yaml
version: '3'
services:
  sub-store:
    image: ghcr.io/moearly/sub-store
    container_name: sub-store
    restart: always
    ports:
      - "3000:3000"
    volumes:
      - ./data:/data
    environment:
      - SUB_STORE_BACKEND_API_PORT=3000
      - SUB_STORE_FRONTEND_PATH=/frontend
      - SUB_STORE_BACKEND_MERGE=true
```

---

### 5.4 Zeabur 云平台部署

[Zeabur](https://zeabur.com/) 是一个现代化的云部署平台，支持一键部署 Node.js 应用，非常适合部署 Sub-Store。

#### 方式一：使用 Docker 镜像部署（推荐）

##### 步骤 1：注册并登录 Zeabur

1. 访问 [Zeabur 官网](https://zeabur.com/)
2. 使用 GitHub 账号登录（推荐）或邮箱注册

##### 步骤 2：创建项目

1. 点击控制台右上角的「Create Project」
2. 选择一个区域（推荐选择离你较近的区域）
3. 输入项目名称，如 `sub-store`

##### 步骤 3：添加服务

1. 在项目中点击「Add Service」
2. 选择「Prebuilt」->「Docker」
3. 输入 Docker 镜像：`ghcr.io/moearly/sub-store`
4. 点击「Deploy」

##### 步骤 4：配置环境变量

在服务的「Variables」选项卡中添加以下环境变量：

| 变量名 | 值 | 说明 |
|--------|------|------|
| `SUB_STORE_BACKEND_API_PORT` | `3000` | 后端端口（必需） |
| `SUB_STORE_FRONTEND_PATH` | `/frontend` | 前端路径 |
| `SUB_STORE_BACKEND_MERGE` | `true` | 前后端合并模式 |

##### 步骤 5：配置端口

1. 在「Networking」选项卡中
2. 添加端口映射：`3000`
3. 开启「Public」使服务可公开访问

##### 步骤 6：绑定域名

1. 在「Networking」->「Domains」中
2. 可以使用 Zeabur 提供的免费子域名（如 `xxx.zeabur.app`）
3. 或绑定自己的域名

##### 步骤 7：配置持久化存储（重要）

1. 在「Storage」选项卡中
2. 添加持久化卷：挂载路径 `/data`
3. 这样数据不会因为重新部署而丢失

---

#### 方式二：从 GitHub 仓库部署

##### 步骤 1：Fork 仓库

1. 访问 [Sub-Store GitHub](https://github.com/sub-store-org/Sub-Store)
2. 点击右上角「Fork」按钮
3. Fork 到你自己的 GitHub 账号

##### 步骤 2：创建项目并部署

1. 在 Zeabur 中创建新项目
2. 点击「Add Service」->「Git」
3. 选择你 Fork 的 Sub-Store 仓库
4. 设置根目录为 `backend`
5. 点击「Deploy」

##### 步骤 3：配置构建命令

在「Build」选项卡中设置：

| 配置项 | 值 |
|--------|------|
| **Build Command** | `npm install -g pnpm && pnpm install && pnpm bundle:esbuild` |
| **Start Command** | `node sub-store.min.js` |
| **Root Directory** | `backend` |

##### 步骤 4：配置环境变量

同方式一的步骤 4。

---

#### Zeabur 部署完整配置示例

```yaml
# zeabur.yaml（可选，放在仓库根目录）
build:
  root: backend
  command: npm install -g pnpm && pnpm install && pnpm bundle:esbuild
start:
  command: node sub-store.min.js
env:
  SUB_STORE_BACKEND_API_PORT: "3000"
  SUB_STORE_FRONTEND_PATH: "/frontend"
  SUB_STORE_BACKEND_MERGE: "true"
```

---

#### Zeabur 费用说明

| 计划 | 费用 | 资源限制 |
|------|------|----------|
| **Free** | 免费 | 共享资源，有使用时长限制 |
| **Developer** | $5/月起 | 更多资源，无时长限制 |
| **Team** | 按需付费 | 团队协作功能 |

> **提示**：免费计划足够个人使用，但可能有冷启动延迟。

---

#### Zeabur 部署优势

| 优势 | 说明 |
|------|------|
| ✅ 一键部署 | 无需服务器运维知识 |
| ✅ 自动 HTTPS | 免费 SSL 证书 |
| ✅ 自动扩缩容 | 按需分配资源 |
| ✅ 持久化存储 | 数据不丢失 |
| ✅ 全球节点 | 多区域可选 |
| ✅ GitHub 集成 | 自动部署更新 |

---

### 5.5 其他云平台部署

#### Vercel 部署

Vercel 主要适合静态网站和 Serverless 函数，Sub-Store 作为持久化服务不太适合。

#### Railway 部署

```bash
# 使用 Railway CLI
railway login
railway init
railway up
```

环境变量配置同上。

#### Render 部署

1. 在 Render 创建 Web Service
2. 连接 GitHub 仓库
3. 设置 Root Directory: `backend`
4. Build Command: `npm install -g pnpm && pnpm install && pnpm bundle:esbuild`
5. Start Command: `node sub-store.min.js`

---

### 5.6 生产环境部署建议

#### 使用 PM2 管理进程

```bash
# 安装 PM2
npm install -g pm2

# 启动服务
pm2 start sub-store.min.js --name sub-store

# 设置开机自启
pm2 startup
pm2 save

# 常用命令
pm2 status          # 查看状态
pm2 logs sub-store  # 查看日志
pm2 restart sub-store  # 重启服务
```

#### 使用 Nginx 反向代理

```nginx
server {
    listen 80;
    server_name sub.example.com;
    
    # 重定向到 HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name sub.example.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket 支持（如需要）
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

#### 使用 Caddy 反向代理（更简单）

```
sub.example.com {
    reverse_proxy localhost:3000
}
```

#### Systemd 服务（不使用 PM2 时）

创建 `/etc/systemd/system/sub-store.service`：

```ini
[Unit]
Description=Sub-Store Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/sub-store/backend
ExecStart=/usr/bin/node sub-store.min.js
Restart=on-failure
RestartSec=10
Environment=SUB_STORE_BACKEND_API_PORT=3000

[Install]
WantedBy=multi-user.target
```

```bash
# 启用服务
sudo systemctl daemon-reload
sudo systemctl enable sub-store
sudo systemctl start sub-store
```

---

### 5.5 网络要求

#### 端口需求

| 端口 | 用途 | 是否必需 |
|------|------|----------|
| 3000 | 后端 API 默认端口 | 是（可修改） |
| 3001 | 前端默认端口（分离部署时） | 否 |
| 80/443 | 反向代理端口 | 推荐 |

#### 防火墙配置

```bash
# UFW（Ubuntu）
sudo ufw allow 3000/tcp

# firewalld（CentOS）
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
```

#### 网络访问需求

| 目标 | 用途 | 是否必需 |
|------|------|----------|
| 订阅源 URL | 下载原始订阅 | 是 |
| GitHub/GitLab | Gist 同步 | 可选 |
| GeoIP 数据库 URL | 更新 MMDB | 可选 |

> **注意**：如果服务器无法直接访问订阅源，需要配置代理。

---

## 六、使用说明

### 6.1 基本使用流程

1. **访问 Web 界面**
   - 客户端部署：访问 `https://sub.store`
   - 服务器部署：访问 `http://你的服务器IP:3000`

2. **添加订阅**
   - 点击「订阅」->「添加」
   - 填写订阅名称和 URL
   - 保存

3. **配置处理规则**
   - 添加过滤器（如地区过滤、正则过滤）
   - 添加操作（如重命名、排序）

4. **获取转换链接**
   - 选择目标平台
   - 复制生成的订阅链接
   - 在对应客户端中使用

### 6.2 高级功能

#### 组合订阅

将多个订阅合并为一个：

1. 创建多个单条订阅
2. 创建组合订阅
3. 选择要合并的订阅
4. 配置组合订阅的处理规则

#### 脚本操作

使用 JavaScript 脚本自定义处理：

```javascript
// 示例：为节点添加前缀
function operator(proxies) {
  return proxies.map(proxy => {
    proxy.name = `[自定义] ${proxy.name}`;
    return proxy;
  });
}
```

#### Gist 同步

1. 在设置中配置 GitHub/GitLab Token
2. 创建同步配置（Artifact）
3. 关联订阅或组合订阅
4. 手动或定时同步到 Gist

---

## 七、常见问题

### Q1: 订阅转换失败？

- 检查原始订阅 URL 是否可访问
- 检查订阅格式是否被支持
- 查看日志获取详细错误信息

### Q2: 节点丢失？

- 检查过滤器规则是否过于严格
- 确认节点协议是否被目标平台支持

### Q3: 如何备份数据？

- 使用 Gist 同步功能
- 导出订阅配置为 JSON 文件

### Q4: 如何更新 Sub-Store？

- 客户端部署：更新模块/插件即可
- 服务器部署：拉取最新代码重新构建

---

## 八、相关链接

- **项目主页**: https://github.com/sub-store-org/Sub-Store
- **官方文档**: https://xream.notion.site/Sub-Store-abe6a96944724dc6a36833d5c9ab7c87
- **Wiki**: https://github.com/sub-store-org/Sub-Store/wiki
- **Telegram 频道**: https://t.me/cool_scripts
- **问题反馈**: https://github.com/sub-store-org/Sub-Store/issues

