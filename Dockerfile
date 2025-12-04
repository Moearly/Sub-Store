# Sub-Store Docker Image
# 多阶段构建，减小镜像体积

# ============================================
# 阶段1：构建阶段
# ============================================
FROM node:20-alpine AS builder

# 安装构建依赖
RUN apk add --no-cache git python3 make g++

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制 package 文件
COPY backend/package.json backend/pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install --frozen-lockfile || pnpm install

# 复制后端源码
COPY backend/ ./

# 构建项目
RUN pnpm bundle:esbuild

# ============================================
# 阶段2：运行阶段
# ============================================
FROM node:20-alpine AS runner

# 添加标签
LABEL maintainer="Moearly"
LABEL org.opencontainers.image.source="https://github.com/Moearly/Sub-Store"
LABEL org.opencontainers.image.description="Advanced Subscription Manager for QX, Loon, Surge, Stash, Egern and Shadowrocket"
LABEL org.opencontainers.image.licenses="AGPL-3.0"

# 安装运行时依赖
RUN apk add --no-cache tini curl

# 创建非 root 用户
RUN addgroup -g 1001 -S substore && \
    adduser -S substore -u 1001 -G substore

# 设置工作目录
WORKDIR /app

# 从构建阶段复制构建产物
COPY --from=builder /app/sub-store.min.js ./
COPY --from=builder /app/dist ./dist

# 创建数据目录
RUN mkdir -p /data && chown -R substore:substore /data /app

# 设置环境变量
ENV NODE_ENV=production
ENV SUB_STORE_BACKEND_API_PORT=3000
ENV SUB_STORE_BACKEND_API_HOST=0.0.0.0
ENV SUB_STORE_DATA_BASE_PATH=/data

# 切换到非 root 用户
USER substore

# 暴露端口
EXPOSE 3000

# 数据卷
VOLUME ["/data"]

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# 使用 tini 作为 init 进程
ENTRYPOINT ["/sbin/tini", "--"]

# 启动命令
CMD ["node", "sub-store.min.js"]

