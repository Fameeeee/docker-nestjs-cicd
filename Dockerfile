# --- Stage 1: Build Stage ---
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# --- Stage 2: Production Stage ---
FROM node:20-alpine AS runner

# ตั้งค่า Environment เป็น Production
ENV NODE_ENV=production

WORKDIR /usr/src/app

# ก๊อปปี้เฉพาะไฟล์ที่จำเป็นมาจาก Stage "builder"
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist

# ✅ [Non-root User] สลับไปใช้ User "node" แทน Root
COPY scripts/entrypoint.sh /usr/src/app/entrypoint.sh
USER root
RUN chmod +x /usr/src/app/entrypoint.sh
USER node

EXPOSE 3000

# รันแอป
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["node", "dist/main"]