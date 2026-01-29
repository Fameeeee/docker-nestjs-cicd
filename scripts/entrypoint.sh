#!/bin/sh

# รัน Migration (ตัวอย่างสำหรับ Prisma)
echo "Running database migrations..."
npx prisma migrate deploy

# เริ่มรันแอปหลัก
echo "Starting application..."
exec "$@"