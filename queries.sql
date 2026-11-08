-- =====================================================================
-- ĐỀ 07 - QUẢN LÝ SALON CHĂM SÓC TÓC
-- Tệp 3/4: queries.sql  - 10 truy vấn độc lập
-- Chạy sau schema.sql và seed.sql
-- Quy ước thời gian (dùng khoảng nửa mở để không sót giờ trong ngày):
--   Tháng 01/2025 : >= '2025-01-01' AND < '2025-02-01'
--   Quý I/2025    : >= '2025-01-01' AND < '2025-04-01'
--   Năm 2025      : >= '2025-01-01' AND < '2026-01-01'
-- "Chi phí đã xác nhận" = cost trong service_records của lịch Completed.
-- =====================================================================

SET NAMES utf8mb4;
USE salon_mini;

-- ---------------------------------------------------------------------
-- Câu 1. Các lịch hẹn Completed trong tháng 01/2025, kèm khách hàng,
--        nhân viên làm tóc và ngày nghiệp vụ appointment_date.
-- ---------------------------------------------------------------------
SELECT a.appointment_id,
       a.appointment_date,
       a.status,
       c.customer_id,
       c.full_name  AS customer_name,
       s.stylist_id,
       s.full_name  AS stylist_name
FROM appointments a
JOIN customers c ON c.customer_id = a.customer_id
JOIN stylists  s ON s.stylist_id  = a.stylist_id
WHERE a.status = 'Completed'
  AND a.appointment_date >= '2025-01-01'
  AND a.appointment_date <  '2025-02-01'
ORDER BY a.appointment_date, a.appointment_id;

-- ---------------------------------------------------------------------
-- Câu 2. Tổng số lịch hẹn theo từng tổ dịch vụ trong quý I/2025 (mọi
--        trạng thái); hiển thị cả tổ có số lượng bằng 0.
--        Điều kiện thời gian đặt ở mệnh đề ON để LEFT JOIN giữ tổ = 0.
-- ---------------------------------------------------------------------
SELECT t.team_id,
       t.name                    AS team_name,
       COUNT(a.appointment_id)   AS total_appointments_q1_2025
FROM service_teams t
LEFT JOIN stylists s
       ON s.team_id = t.team_id
LEFT JOIN appointments a
       ON a.stylist_id = s.stylist_id
      AND a.appointment_date >= '2025-01-01'
      AND a.appointment_date <  '2025-04-01'
GROUP BY t.team_id, t.name
ORDER BY t.team_id;

-- ---------------------------------------------------------------------
-- Câu 3. Khách hàng có ít nhất một lịch hẹn chưa có phiếu dịch vụ,
--        loại trừ Cancelled; mỗi người chỉ xuất hiện một lần.
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name AS customer_name,
       c.phone
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM appointments a
    LEFT JOIN service_records sr ON sr.appointment_id = a.appointment_id
    WHERE a.customer_id = c.customer_id
      AND a.status <> 'Cancelled'
      AND sr.record_id IS NULL
)
ORDER BY c.customer_id;

-- ---------------------------------------------------------------------
-- Câu 4. Phí dịch vụ trung bình trên một giao dịch Completed của từng tổ,
--        xét toàn bộ thời gian; chỉ lấy tổ đã phát sinh chi phí.
--        (Không nối payments nên chi phí không bị cộng lặp.)
-- ---------------------------------------------------------------------
SELECT t.team_id,
       t.name                       AS team_name,
       COUNT(sr.record_id)          AS completed_count,
       SUM(sr.cost)                 AS total_cost,
       ROUND(AVG(sr.cost), 2)       AS avg_cost_per_completed
FROM service_teams t
JOIN stylists s         ON s.team_id = t.team_id
JOIN appointments a     ON a.stylist_id = s.stylist_id
                       AND a.status = 'Completed'
JOIN service_records sr ON sr.appointment_id = a.appointment_id
GROUP BY t.team_id, t.name
HAVING COUNT(sr.record_id) > 0
ORDER BY t.team_id;

-- ---------------------------------------------------------------------
-- Câu 5. 3 nhân viên làm tóc có nhiều lịch hẹn Completed nhất năm 2025;
--        bằng nhau thì ưu tiên stylist_id tăng dần; chỉ lấy người có
--        giao dịch (INNER JOIN nên người có 0 lịch không xuất hiện).
-- ---------------------------------------------------------------------
SELECT s.stylist_id,
       s.full_name               AS stylist_name,
       t.team_id,
       t.name                    AS team_name,
       COUNT(a.appointment_id)   AS completed_count_2025
FROM stylists s
JOIN service_teams t ON t.team_id = s.team_id
JOIN appointments a  ON a.stylist_id = s.stylist_id
WHERE a.status = 'Completed'
  AND a.appointment_date >= '2025-01-01'
  AND a.appointment_date <  '2026-01-01'
GROUP BY s.stylist_id, s.full_name, t.team_id, t.name
ORDER BY completed_count_2025 DESC, s.stylist_id ASC
LIMIT 3;

-- ---------------------------------------------------------------------
-- Câu 6. Tổng tiền từng khách hàng đã thanh toán trong năm 2025 theo
--        payment_date; hiển thị cả người chưa trả với tổng bằng 0.
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name                  AS customer_name,
       COALESCE(pay.total_paid, 0)  AS total_paid_2025
FROM customers c
LEFT JOIN (
    SELECT a.customer_id,
           SUM(p.amount) AS total_paid
    FROM payments p
    JOIN appointments a ON a.appointment_id = p.appointment_id
    WHERE p.payment_date >= '2025-01-01'
      AND p.payment_date <  '2026-01-01'
    GROUP BY a.customer_id
) pay ON pay.customer_id = c.customer_id
ORDER BY c.customer_id;

-- ---------------------------------------------------------------------
-- Câu 7. Khách hàng chưa có bất kỳ bản ghi thanh toán nào trong toàn bộ
--        dữ liệu, kể cả người chưa có giao dịch.
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name AS customer_name,
       c.phone
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM appointments a
    JOIN payments p ON p.appointment_id = a.appointment_id
    WHERE a.customer_id = c.customer_id
)
ORDER BY c.customer_id;

-- ---------------------------------------------------------------------
-- Câu 8. Toàn bộ khách hàng theo tổng phí dịch vụ đã xác nhận giảm dần,
--        không phụ thuộc thanh toán; bằng nhau thì mã tăng dần.
--        (Không nối payments nên chi phí không bị cộng lặp.)
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name                 AS customer_name,
       COALESCE(SUM(sr.cost), 0)   AS total_confirmed_cost
FROM customers c
LEFT JOIN appointments a
       ON a.customer_id = c.customer_id
      AND a.status = 'Completed'
LEFT JOIN service_records sr
       ON sr.appointment_id = a.appointment_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_confirmed_cost DESC, c.customer_id ASC;

-- ---------------------------------------------------------------------
-- Câu 9. Tỷ lệ hủy của từng nhân viên trong năm 2025:
--        số Cancelled / tổng số lịch hẹn của năm * 100, làm tròn 2 chữ số;
--        NULLIF trả NULL khi tổng bằng 0 (tránh chia cho 0).
-- ---------------------------------------------------------------------
SELECT s.stylist_id,
       s.full_name                                               AS stylist_name,
       COUNT(a.appointment_id)                                   AS total_appointments_2025,
       SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END)   AS cancelled_count_2025,
       ROUND(
           100.0 * SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END)
                 / NULLIF(COUNT(a.appointment_id), 0)
       , 2)                                                      AS cancel_rate_percent
FROM stylists s
LEFT JOIN appointments a
       ON a.stylist_id = s.stylist_id
      AND a.appointment_date >= '2025-01-01'
      AND a.appointment_date <  '2026-01-01'
GROUP BY s.stylist_id, s.full_name
ORDER BY s.stylist_id;

-- ---------------------------------------------------------------------
-- Câu 10. Khách hàng có hơn 3 lịch hẹn Completed trong năm 2025, kèm số
--         lần; sắp số lần giảm dần.
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name               AS customer_name,
       COUNT(a.appointment_id)   AS completed_count_2025
FROM customers c
JOIN appointments a ON a.customer_id = c.customer_id
WHERE a.status = 'Completed'
  AND a.appointment_date >= '2025-01-01'
  AND a.appointment_date <  '2026-01-01'
GROUP BY c.customer_id, c.full_name
HAVING COUNT(a.appointment_id) > 3
ORDER BY completed_count_2025 DESC, c.customer_id ASC;
