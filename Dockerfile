# Sub-Store Docker Image (带前端)
# 多阶段构建，减小镜像体积

# ============================================
# 阶段1：构建后端
# ============================================
FROM node:20-alpine AS builder

# 安装构建依赖
RUN apk add --no-cache git python3 make g++

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制整个 backend 目录
COPY backend/ ./

# 安装依赖（不使用 frozen-lockfile，因为 lock 文件可能不完整）
RUN pnpm install --no-frozen-lockfile

# 构建项目
RUN pnpm bundle:esbuild

# 清理开发依赖，只保留生产依赖
RUN pnpm prune --prod

# ============================================
# 阶段2：下载前端
# ============================================
FROM alpine:latest AS frontend

RUN apk add --no-cache curl unzip

WORKDIR /frontend

# 下载 Sub-Store 官方前端（从 GitHub Release）
RUN curl -L -o frontend.zip https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip && \
    unzip frontend.zip && \
    rm frontend.zip

# ============================================
# 阶段3：运行阶段
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

# 从构建阶段复制构建产物和运行时依赖
COPY --from=builder /app/sub-store.min.js ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# 从前端阶段复制前端文件
COPY --from=frontend /frontend/dist ./frontend

# 创建数据目录
RUN mkdir -p /data && chown -R substore:substore /data /app

# 设置环境变量（启用前后端合并模式）
ENV NODE_ENV=production
ENV SUB_STORE_BACKEND_API_PORT=3000
ENV SUB_STORE_BACKEND_API_HOST=0.0.0.0
ENV SUB_STORE_DATA_BASE_PATH=/data
ENV SUB_STORE_FRONTEND_PATH=/app/frontend
ENV SUB_STORE_FRONTEND_BACKEND_PATH=/api
ENV SUB_STORE_BACKEND_MERGE=true

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

