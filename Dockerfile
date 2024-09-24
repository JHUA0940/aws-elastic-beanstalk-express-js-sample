# 选择基础镜像，这里选择较小的 node:16-alpine 版本
FROM node:16-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目的所有文件到容器中
COPY . .

# 暴露应用程序的端口
EXPOSE 8081

# 启动应用程序
CMD ["npm", "start"]
