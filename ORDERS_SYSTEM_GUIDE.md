# ระบบการจัดการ Orders และการจ่ายเงินใหม่

## ภาพรวมระบบ

ระบบใหม่นี้ช่วยให้ผู้ใช้สามารถ:
- ดูรายการการสั่งซื้อทั้งหมด
- ตรวจสอบสถานะการจ่ายเงิน
- จ่ายเงินใหม่สำหรับ Orders ที่ยังค้างอยู่ (pending)

## ฟีเจอร์หลัก

### 1. สถานะ Order
- **pending (ລໍຖ້າການຈ່າຍເງິນ)**: ยังไม่ได้จ่ายเงิน สามารถจ่ายใหม่ได้
- **completed (ຈ່າຍເງິນແລ້ວ)**: จ่ายเงินเสร็จสิ้นแล้ว
- **cancelled (ຍົກເລີກແລ້ວ)**: ยกเลิกการสั่งซื้อแล้ว

### 2. การจ่ายเงินใหม่ (Repayment)
- สำหรับ Orders ที่มีสถานะ pending เท่านั้น
- สร้าง Stripe Checkout Session ใหม่อัตโนมัติ
- อัปเดตข้อมูลการจ่ายเงินผ่าน Webhook

## API Endpoints ใหม่

### Backend APIs

1. **GET /api/orders**
   - ดึงรายการ orders ของผู้ใช้
   - รองรับ pagination (page, limit)
   ```
   GET /api/orders?page=1&limit=10
   ```

2. **GET /api/order/:orderId**
   - ดึงรายละเอียด order เฉพาะ
   - รวมข้อมูลสินค้าในการสั่งซื้อ
   ```
   GET /api/order/OID1234567890
   ```

3. **POST /api/order/:orderId/repay**
   - สร้างการจ่ายเงินใหม่สำหรับ pending orders
   - ส่งคืน Stripe checkout URL
   ```json
   {
     "success": true,
     "session_url": "https://checkout.stripe.com/...",
     "session_id": "cs_..."
   }
   ```

### Frontend Components

1. **OrdersController** (`lib/controller/orders_c.dart`)
   - จัดการข้อมูล orders และการจ่าย
   - Pagination และ refresh data
   - Error handling

2. **OrdersPage** (`lib/view/Home/orders.dart`)
   - หน้าแสดงรายการ orders
   - ปุ่มจ่ายเงินใหม่สำหรับ pending orders
   - OrderDetailPage สำหรับรายละเอียด

3. **Account Integration**
   - เพิ่มเมนู "ການສັ່ງຊື້ຂອງຂ້ອຍ" ในหน้า Account
   - เชื่อมต่อไปยัง OrdersPage

## การใช้งาน

### สำหรับผู้ใช้

1. **ดูรายการสั่งซื้อ**:
   - เข้าแอป → Account → ການສັ່ງຊື້ຂອງຂ້ອຍ
   - ดูสถานะและรายละเอียดแต่ละ order

2. **จ่ายเงินใหม่**:
   - กดปุ่ม "ຈ່າຍເງິນ" ใน pending orders
   - ระบบจะเปิด Stripe checkout อัตโนมัติ
   - เมื่อจ่ายสำเร็จจะอัปเดตสถานะเป็น completed

### สำหรับนักพัฒนา

1. **เริ่มต้นใช้งาน**:
   ```bash
   # Backend
   cd tuv-commerce
   npm start
   
   # Frontend
   cd app_shoe
   flutter run
   ```

2. **ตั้งค่า Stripe**:
   - ตรวจสอบ STRIPE_SECRET_KEY ใน .env
   - ตั้งค่า Webhook endpoint สำหรับ payment completion
   - URL: http://localhost:3000/api/webhook

## ข้อมูลฐานข้อมูล

### ตาราง orders
```sql
- Order_ID: Primary key
- OID: Unique order identifier  
- Order_Status: 'pending', 'completed', 'cancelled'
- session_id: Stripe session ID
- Total_Amount: ยอดรวม
```

### ตาราง payments
```sql
- Payment_ID: Stripe payment intent ID
- Order_ID: เชื่อมต่อกับ orders
- Payment_Status: สถานะการจ่าย
- Payment_Method: วิธีการจ่าย
```

### ตาราง cart
```sql
- รายการสินค้าในแต่ละ order
- เชื่อมต่อกับ products และ orders
```

## การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **ไม่สามารถโหลดรายการ orders**:
   - ตรวจสอบ token authentication
   - ตรวจสอบการเชื่อมต่อ API

2. **ปุ่มจ่ายเงินไม่ทำงาน**:
   - ตรวจสอบสถานะ order (ต้องเป็น pending)
   - ตรวจสอบ url_launcher dependency

3. **Webhook ไม่อัปเดตสถานะ**:
   - ตรวจสอบ STRIPE_WEBHOOK_SECRET
   - ตรวจสอบ logs ใน console

### Debug Tips

1. **Backend logs**:
   ```bash
   # ดู console สำหรับ API calls
   console.log('Order status check:', order);
   ```

2. **Flutter debug**:
   ```dart
   // ใช้ Get.snackbar สำหรับแจ้งเตือน
   print('Error fetching orders: $e');
   ```

## อนาคต

### ฟีเจอร์ที่อาจเพิ่มเติม

1. **การยกเลิก order**
2. **การติดตามการจัดส่ง**
3. **การให้คะแนนสินค้า**
4. **ประวัติการจ่าย**
5. **การแจ้งเตือนแบบ push**

### การปรับปรุงระบบ

1. **การแคชข้อมูล** เพื่อความเร็ว
2. **การ sync แบบ real-time**
3. **ระบบ notification**
4. **การรองรับการชำระเงินหลายรูปแบบ**

---

*อัปเดตล่าสุด: พฤศจิกายน 2024* 