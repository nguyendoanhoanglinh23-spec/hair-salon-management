-- =====================================================================
-- ĐỀ 07 - QUẢN LÝ SALON CHĂM SÓC TÓC
-- Tệp 1/4: schema.sql  - Tạo CSDL, tạo bảng và ràng buộc
-- Yêu cầu: MySQL 8.0.16 trở lên (để CHECK constraint được thực thi)
-- Thứ tự chạy: schema.sql -> seed.sql -> queries.sql -> views.sql
-- Khóa ngoại dùng ON DELETE/UPDATE RESTRICT: không cho xóa/sửa mã của
-- bản ghi cha khi còn bản ghi con, giữ nguyên lịch sử giao dịch.
-- =====================================================================

SET NAMES utf8mb4;

-- Xóa CSDL cũ (nếu có) để tệp có thể chạy lại nhiều lần trên CSDL mới
DROP DATABASE IF EXISTS salon_mini;
CREATE DATABASE salon_mini
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE salon_mini;

-- ---------------------------------------------------------------------
-- 1. service_teams: tổ dịch vụ (tổ chuyên môn)
-- ---------------------------------------------------------------------
CREATE TABLE service_teams (
    team_id   INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL,
    CONSTRAINT pk_service_teams PRIMARY KEY (team_id),
    CONSTRAINT uq_service_teams_name UNIQUE (name),
    CONSTRAINT ck_service_teams_name CHECK (CHAR_LENGTH(TRIM(name)) > 0)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2. stylists: nhân viên làm tóc; mỗi nhân viên thuộc đúng một tổ
-- ---------------------------------------------------------------------
CREATE TABLE stylists (
    stylist_id  INT          NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL,
    skill       VARCHAR(150) NULL,
    team_id     INT          NOT NULL,
    CONSTRAINT pk_stylists PRIMARY KEY (stylist_id),
    CONSTRAINT uq_stylists_email UNIQUE (email),
    CONSTRAINT ck_stylists_full_name CHECK (CHAR_LENGTH(TRIM(full_name)) > 0),
    CONSTRAINT ck_stylists_email CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT fk_stylists_team
        FOREIGN KEY (team_id) REFERENCES service_teams (team_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 3. customers: khách hàng
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id      INT          NOT NULL AUTO_INCREMENT,
    full_name        VARCHAR(100) NOT NULL,
    phone            VARCHAR(15)  NOT NULL,
    preference_note  VARCHAR(255) NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_phone UNIQUE (phone),
    CONSTRAINT ck_customers_full_name CHECK (CHAR_LENGTH(TRIM(full_name)) > 0),
    CONSTRAINT ck_customers_phone CHECK (phone REGEXP '^0[0-9]{9,10}$')
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 4. appointments: lịch hẹn; thuộc đúng 1 khách hàng và 1 nhân viên
--    status: Pending (chờ thực hiện), Completed (đã hoàn tất),
--            Cancelled (đã hủy)
-- ---------------------------------------------------------------------
CREATE TABLE appointments (
    appointment_id    INT       NOT NULL AUTO_INCREMENT,
    customer_id       INT       NOT NULL,
    stylist_id        INT       NOT NULL,
    appointment_date  DATETIME  NOT NULL,
    status            ENUM('Pending', 'Completed', 'Cancelled')
                                NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_appointments PRIMARY KEY (appointment_id),
    CONSTRAINT fk_appointments_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_stylist
        FOREIGN KEY (stylist_id) REFERENCES stylists (stylist_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    INDEX idx_appointments_date (appointment_date),
    INDEX idx_appointments_status (status)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 5. service_records: phiếu dịch vụ (chi phí đã xác nhận)
--    Mỗi lịch hẹn có tối đa 1 phiếu -> UNIQUE(appointment_id)
--    cost >= 0
-- ---------------------------------------------------------------------
CREATE TABLE service_records (
    record_id        INT            NOT NULL AUTO_INCREMENT,
    appointment_id   INT            NOT NULL,
    service_summary  VARCHAR(255)   NOT NULL,
    product_note     VARCHAR(255)   NULL,
    cost             DECIMAL(12, 2) NOT NULL,
    CONSTRAINT pk_service_records PRIMARY KEY (record_id),
    CONSTRAINT uq_service_records_appointment UNIQUE (appointment_id),
    CONSTRAINT ck_service_records_cost CHECK (cost >= 0),
    CONSTRAINT ck_service_records_summary CHECK (CHAR_LENGTH(TRIM(service_summary)) > 0),
    CONSTRAINT fk_service_records_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointments (appointment_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 6. payments: mỗi dòng là một lần thu tiền thực tế
--    amount > 0; method: Cash, BankTransfer, Card
--    Khóa ngoại thứ 2 (fk_payments_service_record) tham chiếu
--    service_records(appointment_id) để bảo đảm "chỉ thu tiền khi đã có
--    chi phí được xác nhận" (lịch hẹn phải có phiếu dịch vụ).
--    Điều kiện "tổng đã thu <= chi phí" được kiểm chứng bằng truy vấn
--    trong seed.sql (không dùng CHECK để truy vấn bảng khác).
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INT            NOT NULL AUTO_INCREMENT,
    appointment_id  INT            NOT NULL,
    amount          DECIMAL(12, 2) NOT NULL,
    payment_date    DATETIME       NOT NULL,
    method          ENUM('Cash', 'BankTransfer', 'Card') NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT ck_payments_amount CHECK (amount > 0),
    CONSTRAINT fk_payments_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointments (appointment_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_payments_service_record
        FOREIGN KEY (appointment_id) REFERENCES service_records (appointment_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    INDEX idx_payments_date (payment_date)
) ENGINE = InnoDB;
