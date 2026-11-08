-- =====================================================================
-- ĐỀ 07 - QUẢN LÝ SALON CHĂM SÓC TÓC
-- Tệp 4/4: views.sql  - Tạo VIEW (xét toàn bộ thời gian)
-- Chạy sau schema.sql, seed.sql, queries.sql
-- =====================================================================

SET NAMES utf8mb4;
USE salon_mini;

-- ---------------------------------------------------------------------
-- v_detail: mỗi dòng là một lịch hẹn; giữ cả lịch chưa có phiếu dịch vụ
--           (LEFT JOIN service_records -> service_cost = NULL).
--           Phiếu dịch vụ 1-1 với lịch hẹn nên không sinh dòng lặp.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_detail AS
SELECT a.appointment_id,
       a.appointment_date,
       a.status,
       c.customer_id,
       c.full_name   AS customer_name,
       s.stylist_id,
       s.full_name   AS stylist_name,
       t.team_id,
       t.name        AS team_name,
       sr.cost       AS service_cost
FROM appointments a
JOIN customers     c ON c.customer_id = a.customer_id
JOIN stylists      s ON s.stylist_id  = a.stylist_id
JOIN service_teams t ON t.team_id     = s.team_id
LEFT JOIN service_records sr ON sr.appointment_id = a.appointment_id;

-- ---------------------------------------------------------------------
-- v_group_summary: mỗi dòng là một tổ dịch vụ; giữ cả tổ chưa có giao
--                  dịch (các số đếm và tổng phí hiển thị 0).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_group_summary AS
SELECT t.team_id,
       t.name                                                            AS team_name,
       COUNT(a.appointment_id)                                           AS total_appointments,
       COALESCE(SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END), 0) AS completed_count,
       COALESCE(SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END), 0) AS cancelled_count,
       COALESCE(SUM(sr.cost), 0)                                         AS total_service_cost
FROM service_teams t
LEFT JOIN stylists s         ON s.team_id = t.team_id
LEFT JOIN appointments a     ON a.stylist_id = s.stylist_id
LEFT JOIN service_records sr ON sr.appointment_id = a.appointment_id
GROUP BY t.team_id, t.name;

-- ---------------------------------------------------------------------
-- v_debt: mỗi dòng là một khách hàng; giữ cả người chưa phát sinh chi phí
--         hoặc thanh toán. Chi phí và thanh toán được cộng ở HAI truy vấn
--         con riêng rồi mới nối với customers -> chi phí không bị cộng lặp
--         khi một lịch hẹn có nhiều lần thanh toán.
--         còn nợ = tổng chi phí đã xác nhận - tổng tiền thực thu.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_debt AS
SELECT c.customer_id,
       c.full_name                                            AS customer_name,
       COALESCE(cost_sum.total_cost, 0)                       AS total_confirmed_cost,
       COALESCE(pay_sum.total_paid, 0)                        AS total_paid,
       COALESCE(cost_sum.total_cost, 0)
         - COALESCE(pay_sum.total_paid, 0)                    AS remaining_debt
FROM customers c
LEFT JOIN (
    SELECT a.customer_id,
           SUM(sr.cost) AS total_cost
    FROM appointments a
    JOIN service_records sr ON sr.appointment_id = a.appointment_id
    WHERE a.status = 'Completed'
    GROUP BY a.customer_id
) cost_sum ON cost_sum.customer_id = c.customer_id
LEFT JOIN (
    SELECT a.customer_id,
           SUM(p.amount) AS total_paid
    FROM appointments a
    JOIN payments p ON p.appointment_id = a.appointment_id
    GROUP BY a.customer_id
) pay_sum ON pay_sum.customer_id = c.customer_id;

-- ---------------------------------------------------------------------
-- Truy vấn xem nhanh kết quả các VIEW
-- ---------------------------------------------------------------------
SELECT * FROM v_detail        ORDER BY appointment_id;
SELECT * FROM v_group_summary ORDER BY team_id;
SELECT * FROM v_debt          ORDER BY customer_id;
