-- MariaDB 초기화 스크립트
-- root 사용자가 모든 호스트에서 접속할 수 있도록 권한 부여

-- 기본 사용자 생성 및 권한 부여
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'kmhtest';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- 기본 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS testdb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 테스트용 사용자 생성
CREATE USER IF NOT EXISTS 'testuser'@'%' IDENTIFIED BY 'kmhtest';
GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';

-- 권한 플러시
FLUSH PRIVILEGES;

-- 초기화 완료 메시지
SELECT 'MariaDB initialization completed successfully' AS message; 