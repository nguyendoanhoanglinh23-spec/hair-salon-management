-- =====================================================================
-- ĐỀ 07 - QUẢN LÝ SALON CHĂM SÓC TÓC
-- Tệp 2/4: seed.sql  - Nạp dữ liệu mẫu và kiểm tra dữ liệu
-- Chạy sau schema.sql
-- =====================================================================

SET NAMES utf8mb4;
USE salon_mini;

START TRANSACTION;

-- ---------------------------------------------------------------------
-- 1. service_teams (5 bản ghi)
--    Tổ 4: chỉ có lịch hẹn NGOÀI quý I/2025
--    Tổ 5: chưa có lịch hẹn nào (chưa có giao dịch trong quý I)
-- ---------------------------------------------------------------------
INSERT INTO service_teams (team_id, name) VALUES
(1, 'Tổ Cắt và Tạo kiểu'),
(2, 'Tổ Nhuộm màu'),
(3, 'Tổ Uốn - Duỗi'),
(4, 'Tổ Phục hồi tóc'),
(5, 'Tổ Gội dưỡng thư giãn');

-- ---------------------------------------------------------------------
-- 2. stylists (7 bản ghi)
--    Stylist 6: chưa có lịch hẹn nào
--    Stylist 7: chỉ có lịch hẹn năm 2024 (chưa có giao dịch năm 2025)
-- ---------------------------------------------------------------------
INSERT INTO stylists (stylist_id, full_name, email, skill, team_id) VALUES
(1, 'Nguyễn Minh Anh', 'minhanh@salon.test', 'Cắt tóc nam, fade, undercut',   1),
(2, 'Trần Thu Hà',     'thuha@salon.test',   'Cắt tạo kiểu tóc nữ, layer',    1),
(3, 'Lê Hoàng Nam',    'hoangnam@salon.test','Nhuộm highlight, balayage',     2),
(4, 'Phạm Thị Lan',    'thilan@salon.test',  'Uốn setting, duỗi, ép phồng',   3),
(5, 'Vũ Đức Huy',      'duchuy@salon.test',  'Phục hồi keratin, hấp dầu',     4),
(6, 'Đỗ Ngọc Mai',     'ngocmai@salon.test', 'Gội dưỡng, massage da đầu',     5),
(7, 'Bùi Quang Khải',  'quangkhai@salon.test','Nhuộm phủ bạc, nhuộm thời trang', 2);

-- ---------------------------------------------------------------------
-- 3. customers (12 bản ghi)
--    KH 1 và KH 7 trùng họ tên (phân biệt bằng customer_id)
--    KH 1 : hơn 3 lịch Completed trong năm 2025
--    KH 8 : có lịch sử giao dịch Completed nhưng chưa thanh toán
--    KH 11: chưa có giao dịch nào
-- ---------------------------------------------------------------------
INSERT INTO customers (customer_id, full_name, phone, preference_note) VALUES
(1,  'Nguyễn Văn An',   '0912000001', 'Thích kiểu tóc ngắn gọn gàng'),
(2,  'Trần Thị Bình',   '0912000002', 'Da đầu nhạy cảm, dùng thuốc nhuộm dịu nhẹ'),
(3,  'Lê Văn Cường',    '0912000003', NULL),
(4,  'Phạm Thị Dung',   '0912000004', 'Thích tóc layer dài'),
(5,  'Hoàng Minh Đức',  '0912000005', 'Hay đặt lịch buổi chiều'),
(6,  'Ngô Thị Hoa',     '0912000006', NULL),
(7,  'Nguyễn Văn An',   '0912000007', 'Trùng tên khách hàng số 1'),
(8,  'Đặng Thu Trang',  '0912000008', 'Tóc yếu, cần phục hồi'),
(9,  'Bùi Thanh Tùng',  '0912000009', NULL),
(10, 'Lý Thị Kim',      '0912000010', 'Khách nhận ưu đãi hấp dầu'),
(11, 'Mai Quốc Bảo',    '0912000011', 'Khách mới, chưa đặt lịch'),
(12, 'Đinh Thị Ngọc',   '0912000012', NULL);

-- ---------------------------------------------------------------------
-- 4. appointments (21 bản ghi)
--    Năm 2024 (ngoài năm 2025): 1, 2
--    Tháng 01/2025: 3 - 7          Tháng 02/2025: 8 - 10
--    Tháng 03/2025: 11 - 13        Ngoài quý I/2025: 14 - 18
--    Năm 2026 (ngoài năm 2025): 19 - 21
--    Completed: 15 | Cancelled: 4 (5, 9, 12, 16) | Pending: 2 (20, 21)
-- ---------------------------------------------------------------------
INSERT INTO appointments (appointment_id, customer_id, stylist_id, appointment_date, status) VALUES
(1,  2,  7, '2024-12-10 10:00:00', 'Completed'),
(2,  1,  1, '2024-12-20 09:00:00', 'Completed'),
(3,  1,  1, '2025-01-05 09:00:00', 'Completed'),
(4,  3,  3, '2025-01-10 14:00:00', 'Completed'),
(5,  4,  2, '2025-01-15 10:30:00', 'Cancelled'),
(6,  7,  1, '2025-01-20 16:00:00', 'Completed'),
(7,  5,  4, '2025-01-28 13:00:00', 'Completed'),
(8,  1,  2, '2025-02-08 10:00:00', 'Completed'),
(9,  6,  3, '2025-02-14 15:00:00', 'Cancelled'),
(10, 8,  4, '2025-02-20 09:30:00', 'Completed'),
(11, 1,  3, '2025-03-12 14:00:00', 'Completed'),
(12, 9,  1, '2025-03-25 11:00:00', 'Cancelled'),
(13, 2,  4, '2025-03-30 10:00:00', 'Completed'),
(14, 1,  1, '2025-05-10 09:00:00', 'Completed'),
(15, 3,  5, '2025-05-18 14:00:00', 'Completed'),
(16, 10, 5, '2025-10-05 10:00:00', 'Cancelled'),
(17, 6,  2, '2025-11-12 15:00:00', 'Completed'),
(18, 10, 5, '2025-12-20 13:00:00', 'Completed'),
(19, 4,  2, '2026-01-15 10:00:00', 'Completed'),
(20, 12, 4, '2026-11-20 09:00:00', 'Pending'),
(21, 5,  1, '2026-11-25 14:00:00', 'Pending');

-- ---------------------------------------------------------------------
-- 5. service_records (15 bản ghi) - đúng 1 phiếu cho mỗi lịch Completed
--    Phiếu 14 có cost = 0 (dịch vụ bảo hành miễn phí)
-- ---------------------------------------------------------------------
INSERT INTO service_records (record_id, appointment_id, service_summary, product_note, cost) VALUES
(1,  1,  'Nhuộm phủ bạc toàn đầu',          'Thuốc nhuộm không amoniac', 650000.00),
(2,  2,  'Cắt tóc nam, gội sấy',             NULL,                        150000.00),
(3,  3,  'Cắt tóc nam, gội sấy',             NULL,                        150000.00),
(4,  4,  'Nhuộm balayage, hấp dưỡng',        'Thuốc tẩy và màu nâu khói', 1200000.00),
(5,  6,  'Cắt tóc nam kiểu undercut',        NULL,                        120000.00),
(6,  7,  'Uốn setting, dưỡng phục hồi',      'Thuốc uốn cho tóc yếu',     900000.00),
(7,  8,  'Cắt tạo kiểu layer, sấy',          NULL,                        250000.00),
(8,  10, 'Duỗi tóc, ép phồng chân tóc',      'Kem duỗi phục hồi',         800000.00),
(9,  11, 'Nhuộm highlight, tẩy tóc',         'Thuốc tẩy, màu bạch kim',   1500000.00),
(10, 13, 'Duỗi cúp đuôi',                    NULL,                        350000.00),
(11, 14, 'Cắt tóc, cạo mặt',                 NULL,                        180000.00),
(12, 15, 'Phục hồi keratin',                 'Keratin phục hồi chuyên sâu', 700000.00),
(13, 17, 'Cắt tạo kiểu, hấp dầu',            'Dầu hấp dưỡng ẩm',          300000.00),
(14, 18, 'Hấp dầu bảo hành miễn phí',        'Dầu hấp dưỡng ẩm',          0.00),
(15, 19, 'Cắt tạo kiểu tóc nữ',              NULL,                        200000.00);

-- ---------------------------------------------------------------------
-- 6. payments (15 bản ghi)
--    Lịch 4 và 11: trả nhiều lần (đã trả đủ)
--    Lịch 7 : trả một phần -> còn nợ 500.000
--    Lịch 10: chưa trả     -> còn nợ 800.000
--    Lịch 18: chi phí 0    -> không cần thu tiền
-- ---------------------------------------------------------------------
INSERT INTO payments (payment_id, appointment_id, amount, payment_date, method) VALUES
(1,  1,  650000.00,  '2024-12-10 11:30:00', 'Cash'),
(2,  2,  150000.00,  '2024-12-20 09:45:00', 'Cash'),
(3,  3,  150000.00,  '2025-01-05 09:40:00', 'Cash'),
(4,  4,  500000.00,  '2025-01-10 16:30:00', 'Card'),
(5,  4,  700000.00,  '2025-01-25 10:00:00', 'BankTransfer'),
(6,  6,  120000.00,  '2025-01-20 16:40:00', 'Card'),
(7,  7,  400000.00,  '2025-01-28 15:30:00', 'Cash'),
(8,  8,  250000.00,  '2025-02-08 11:00:00', 'BankTransfer'),
(9,  11, 1000000.00, '2025-03-12 17:00:00', 'Card'),
(10, 11, 500000.00,  '2025-04-02 09:00:00', 'BankTransfer'),
(11, 13, 350000.00,  '2025-03-30 12:00:00', 'Cash'),
(12, 14, 180000.00,  '2025-05-10 09:45:00', 'Cash'),
(13, 15, 700000.00,  '2025-05-18 16:00:00', 'Card'),
(14, 17, 300000.00,  '2025-11-12 16:30:00', 'Cash'),
(15, 19, 200000.00,  '2026-01-15 11:00:00', 'BankTransfer');

COMMIT;

-- =====================================================================
-- MINH HỌA CÁC INSERT VI PHẠM RÀNG BUỘC
-- (để trong chú thích để toàn bộ tệp vẫn chạy được)
-- =====================================================================
-- (a) Vi phạm khóa ngoại: khách hàng 999 không tồn tại
-- INSERT INTO appointments (customer_id, stylist_id, appointment_date, status)
-- VALUES (999, 1, '2025-06-01 09:00:00', 'Pending');
--
-- (b) Vi phạm ENUM: trạng thái không hợp lệ
-- INSERT INTO appointments (customer_id, stylist_id, appointment_date, status)
-- VALUES (1, 1, '2025-06-01 09:00:00', 'Done');
--
-- (c) Vi phạm CHECK: chi phí âm
-- INSERT INTO service_records (appointment_id, service_summary, cost)
-- VALUES (20, 'Cắt tóc', -50000);
--
-- (d) Vi phạm UNIQUE: lịch hẹn 3 đã có phiếu dịch vụ
-- INSERT INTO service_records (appointment_id, service_summary, cost)
-- VALUES (3, 'Phiếu thứ hai cho cùng lịch hẹn', 100000);
--
-- (e) Vi phạm CHECK: số tiền thanh toán phải > 0
-- INSERT INTO payments (appointment_id, amount, payment_date, method)
-- VALUES (7, 0, '2025-02-01 10:00:00', 'Cash');
--
-- (f) Vi phạm ENUM: phương thức thanh toán không hợp lệ
-- INSERT INTO payments (appointment_id, amount, payment_date, method)
-- VALUES (7, 100000, '2025-02-01 10:00:00', 'Momo');
--
-- (g) Vi phạm khóa ngoại fk_payments_service_record: lịch 20 (Pending)
--     chưa có phiếu dịch vụ nên chưa được thu tiền
-- INSERT INTO payments (appointment_id, amount, payment_date, method)
-- VALUES (20, 100000, '2026-11-20 10:00:00', 'Cash');
--
-- (h) Vi phạm UNIQUE: trùng email nhân viên
-- INSERT INTO stylists (full_name, email, skill, team_id)
-- VALUES ('Nhân viên mới', 'minhanh@salon.test', 'Cắt tóc', 1);
--
-- (i) Vi phạm nghiệp vụ "tổng thu không vượt chi phí" (không chặn bằng
--     CHECK được vì phải cộng nhiều dòng; được phát hiện bởi truy vấn
--     kiểm tra số 3 bên dưới): lịch 7 có chi phí 900.000, đã thu 400.000
-- INSERT INTO payments (appointment_id, amount, payment_date, method)
-- VALUES (7, 600000, '2025-02-01 10:00:00', 'Cash');

-- =====================================================================
-- TRUY VẤN KIỂM TRA DỮ LIỆU
-- Mỗi truy vấn trả về số dòng lỗi; dữ liệu hợp lệ khi so_dong_loi = 0
-- =====================================================================

-- Kiểm tra 1: Khóa ngoại (bản ghi con không có bản ghi cha)
SELECT 'stylists.team_id -> service_teams' AS kiem_tra, COUNT(*) AS so_dong_loi
FROM stylists s
LEFT JOIN service_teams t ON t.team_id = s.team_id
WHERE t.team_id IS NULL
UNION ALL
SELECT 'appointments.customer_id -> customers', COUNT(*)
FROM appointments a
LEFT JOIN customers c ON c.customer_id = a.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 'appointments.stylist_id -> stylists', COUNT(*)
FROM appointments a
LEFT JOIN stylists s ON s.stylist_id = a.stylist_id
WHERE s.stylist_id IS NULL
UNION ALL
SELECT 'service_records.appointment_id -> appointments', COUNT(*)
FROM service_records sr
LEFT JOIN appointments a ON a.appointment_id = sr.appointment_id
WHERE a.appointment_id IS NULL
UNION ALL
SELECT 'payments.appointment_id -> appointments', COUNT(*)
FROM payments p
LEFT JOIN appointments a ON a.appointment_id = p.appointment_id
WHERE a.appointment_id IS NULL;

-- Kiểm tra 2: Quan hệ trạng thái - phiếu dịch vụ
SELECT 'Completed nhưng chưa có phiếu dịch vụ' AS kiem_tra, COUNT(*) AS so_dong_loi
FROM appointments a
LEFT JOIN service_records sr ON sr.appointment_id = a.appointment_id
WHERE a.status = 'Completed' AND sr.record_id IS NULL
UNION ALL
SELECT 'Có phiếu dịch vụ nhưng trạng thái khác Completed', COUNT(*)
FROM service_records sr
JOIN appointments a ON a.appointment_id = sr.appointment_id
WHERE a.status <> 'Completed'
UNION ALL
SELECT 'Lịch hẹn có nhiều hơn 1 phiếu dịch vụ', COUNT(*)
FROM (
    SELECT appointment_id
    FROM service_records
    GROUP BY appointment_id
    HAVING COUNT(*) > 1
) x
UNION ALL
SELECT 'Thanh toán cho lịch chưa có chi phí xác nhận', COUNT(*)
FROM payments p
LEFT JOIN service_records sr ON sr.appointment_id = p.appointment_id
WHERE sr.record_id IS NULL
UNION ALL
SELECT 'Thanh toán cho lịch không ở trạng thái Completed', COUNT(*)
FROM payments p
JOIN appointments a ON a.appointment_id = p.appointment_id
WHERE a.status <> 'Completed';

-- Kiểm tra 3: Tổng tiền đã thu của mỗi lịch hẹn không vượt chi phí đã xác nhận
--             (cộng thanh toán trong truy vấn con để không cộng lặp chi phí)
SELECT 'Tổng thu vượt chi phí' AS kiem_tra, COUNT(*) AS so_dong_loi
FROM service_records sr
JOIN (
    SELECT appointment_id, SUM(amount) AS total_paid
    FROM payments
    GROUP BY appointment_id
) p ON p.appointment_id = sr.appointment_id
WHERE p.total_paid > sr.cost;

-- Kiểm tra 3b: Đối chiếu chi tiết chi phí - đã thu - còn nợ theo từng lịch hẹn
SELECT sr.appointment_id,
       sr.cost                                   AS chi_phi,
       COALESCE(p.total_paid, 0)                 AS da_thu,
       COALESCE(p.so_lan_tra, 0)                 AS so_lan_tra,
       sr.cost - COALESCE(p.total_paid, 0)       AS con_no,
       CASE WHEN COALESCE(p.total_paid, 0) > sr.cost THEN 'LỖI: thu vượt'
            ELSE 'Hợp lệ' END                    AS ket_qua
FROM service_records sr
LEFT JOIN (
    SELECT appointment_id, SUM(amount) AS total_paid, COUNT(*) AS so_lan_tra
    FROM payments
    GROUP BY appointment_id
) p ON p.appointment_id = sr.appointment_id
ORDER BY sr.appointment_id;

-- Kiểm tra 4 (bổ sung): ngày thanh toán không trước ngày lịch hẹn
SELECT 'Thanh toán trước ngày lịch hẹn' AS kiem_tra, COUNT(*) AS so_dong_loi
FROM payments p
JOIN appointments a ON a.appointment_id = p.appointment_id
WHERE p.payment_date < a.appointment_date;

-- Kiểm tra 5: Dữ liệu mẫu có đủ các tình huống đề yêu cầu (mong đợi: tất cả = 'Đạt')
SELECT 'Có giao dịch tháng 01/2025' AS tinh_huong,
       CASE WHEN EXISTS (SELECT 1 FROM appointments
                         WHERE appointment_date >= '2025-01-01' AND appointment_date < '2025-02-01')
            THEN 'Đạt' ELSE 'Chưa đạt' END AS ket_qua
UNION ALL
SELECT 'Có giao dịch tháng 02 và 03/2025',
       CASE WHEN EXISTS (SELECT 1 FROM appointments
                         WHERE appointment_date >= '2025-02-01' AND appointment_date < '2025-03-01')
             AND EXISTS (SELECT 1 FROM appointments
                         WHERE appointment_date >= '2025-03-01' AND appointment_date < '2025-04-01')
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có giao dịch năm 2025 ngoài quý I',
       CASE WHEN EXISTS (SELECT 1 FROM appointments
                         WHERE appointment_date >= '2025-04-01' AND appointment_date < '2026-01-01')
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có giao dịch ngoài năm 2025',
       CASE WHEN EXISTS (SELECT 1 FROM appointments
                         WHERE appointment_date < '2025-01-01' OR appointment_date >= '2026-01-01')
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có đủ 3 trạng thái Completed, Pending, Cancelled',
       CASE WHEN (SELECT COUNT(DISTINCT status) FROM appointments) = 3
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có khách hàng > 3 lịch Completed năm 2025',
       CASE WHEN EXISTS (SELECT customer_id FROM appointments
                         WHERE status = 'Completed'
                           AND appointment_date >= '2025-01-01' AND appointment_date < '2026-01-01'
                         GROUP BY customer_id HAVING COUNT(*) > 3)
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có khách có lịch sử giao dịch nhưng chưa thanh toán',
       CASE WHEN EXISTS (SELECT 1 FROM customers c
                         WHERE EXISTS (SELECT 1 FROM appointments a WHERE a.customer_id = c.customer_id)
                           AND NOT EXISTS (SELECT 1 FROM appointments a
                                           JOIN payments p ON p.appointment_id = a.appointment_id
                                           WHERE a.customer_id = c.customer_id))
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có giao dịch trả nhiều lần',
       CASE WHEN EXISTS (SELECT appointment_id FROM payments
                         GROUP BY appointment_id HAVING COUNT(*) > 1)
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có giao dịch còn nợ',
       CASE WHEN EXISTS (SELECT 1 FROM service_records sr
                         WHERE sr.cost > COALESCE((SELECT SUM(p.amount) FROM payments p
                                                   WHERE p.appointment_id = sr.appointment_id), 0))
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có tổ dịch vụ chưa có giao dịch trong quý I/2025',
       CASE WHEN EXISTS (SELECT 1 FROM service_teams t
                         WHERE NOT EXISTS (SELECT 1 FROM stylists s
                                           JOIN appointments a ON a.stylist_id = s.stylist_id
                                           WHERE s.team_id = t.team_id
                                             AND a.appointment_date >= '2025-01-01'
                                             AND a.appointment_date <  '2025-04-01'))
            THEN 'Đạt' ELSE 'Chưa đạt' END
UNION ALL
SELECT 'Có nhân viên chưa có giao dịch trong năm 2025',
       CASE WHEN EXISTS (SELECT 1 FROM stylists s
                         WHERE NOT EXISTS (SELECT 1 FROM appointments a
                                           WHERE a.stylist_id = s.stylist_id
                                             AND a.appointment_date >= '2025-01-01'
                                             AND a.appointment_date <  '2026-01-01'))
            THEN 'Đạt' ELSE 'Chưa đạt' END;

-- Kiểm tra 6: Số bản ghi mỗi bảng (tối thiểu: 5, 6, 10, 12, 10, 10)
SELECT 'service_teams' AS bang, COUNT(*) AS so_ban_ghi FROM service_teams
UNION ALL SELECT 'stylists',        COUNT(*) FROM stylists
UNION ALL SELECT 'customers',       COUNT(*) FROM customers
UNION ALL SELECT 'appointments',    COUNT(*) FROM appointments
UNION ALL SELECT 'service_records', COUNT(*) FROM service_records
UNION ALL SELECT 'payments',        COUNT(*) FROM payments;
