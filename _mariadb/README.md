# MariaDB 서비스 가이드

MariaDB 데이터베이스 서비스의 상세 설정 및 사용법을 안내합니다.

## 📋 서비스 정보

- **이미지**: mariadb:latest
- **포트**: 3306
- **데이터 저장**: ./mysql_data
- **백업 저장**: ./backup/mariadb

## 🔧 설정 정보

### 기본 설정

- **호스트**: localhost
- **포트**: 3306
- **사용자**: root
- **비밀번호**: kmhtest (환경변수에서 설정)
- **데이터베이스**: testdb (환경변수에서 설정)

### 환경 변수

`.env` 파일에서 다음 설정을 변경할 수 있습니다:

```env
MYSQL_ROOT_PASSWORD=kmhtest
MYSQL_DATABASE=testdb
MYSQL_USER=testuser
MYSQL_PASSWORD=kmhtest
MARIADB_PORT=3306
```

## 🌐 외부 접속

### 명령줄에서 접속

```bash
# 로컬 접속
mysql -h localhost -P 3306 -u root -p

# 컨테이너 내부 접속
docker compose exec mariadb mariadb -u root -p

# 다른 서버에서 접속
mysql -h YOUR_SERVER_IP -P 3306 -u root -p
```

### 데이터베이스 목록 확인

```bash
docker compose exec mariadb mariadb -u root -pkmhtest -e "SHOW DATABASES;"
```

## 📂 파일 구조

```
_mariadb/              # MariaDB 설정 관련 파일들
├── backup.sh          # 자동 백업 스크립트
├── restore.sh         # 복원 스크립트
└── README.md          # 이 파일

backup/mariadb/        # 백업 파일 저장소
├── *.sql             # 데이터베이스 백업 파일들
└── backup.log        # 백업 로그
```

## 🔄 백업 및 복원

### 자동 백업

매일 0시에 자동으로 백업이 실행됩니다:

```bash
# 백업 스케줄러 상태 확인
docker compose ps backup-scheduler

# 백업 로그 확인
cat backup/mariadb/backup.log
```

### 수동 백업 실행

```bash
# 방법 1: 백업 스케줄러 컨테이너에서 직접 실행
docker compose exec backup-scheduler /scripts/backup.sh

# 방법 2: 특정 데이터베이스만 백업
docker compose exec mariadb mysqldump -u root -pkmhtest testdb > backup.sql

# 방법 3: 모든 데이터베이스 백업
docker compose exec mariadb mysqldump -u root -pkmhtest --all-databases > all_backup.sql
```

### 복원

```bash
# 방법 1: 복원 스크립트 사용
./_mariadb/restore.sh 20250729-073357-testdb.sql

# 방법 2: 직접 복원
docker compose exec -i mariadb mariadb -u root -pkmhtest < backup.sql

# 방법 3: 특정 데이터베이스 복원
docker compose exec -i mariadb mariadb -u root -pkmhtest testdb < backup.sql
```

## 🛠️ 관리 명령어

### 서비스 관리

```bash
# 서비스 시작
docker compose up -d mariadb

# 서비스 중지
docker compose stop mariadb

# 서비스 재시작
docker compose restart mariadb

# 로그 확인
docker compose logs mariadb
```

### 데이터베이스 관리

```bash
# 데이터베이스 생성
docker compose exec mariadb mariadb -u root -pkmhtest -e "CREATE DATABASE newdb;"

# 사용자 생성
docker compose exec mariadb mariadb -u root -pkmhtest -e "CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';"

# 권한 부여
docker compose exec mariadb mariadb -u root -pkmhtest -e "GRANT ALL PRIVILEGES ON newdb.* TO 'newuser'@'%';"
```

## 🔒 보안 설정

### 현재 설정

- **바인딩 주소**: 0.0.0.0 (모든 인터페이스)
- **최대 연결수**: 1000
- **문자셋**: utf8mb4
- **바이너리 로그**: 활성화

### 프로덕션 환경 권장사항

1. **방화벽 설정**: 필요한 IP만 허용
2. **강력한 비밀번호**: 환경변수에서 설정
3. **SSL/TLS**: 필요시 활성화
4. **백업 암호화**: 중요 데이터는 암호화

## 🚨 문제 해결

### 연결 문제

```bash
# 컨테이너 상태 확인
docker compose ps mariadb

# 포트 확인
netstat -tlnp | grep 3306

# 로그 확인
docker compose logs mariadb
```

### 권한 문제

```bash
# 컨테이너 재시작
docker compose restart mariadb

# 데이터 초기화 (주의: 모든 데이터 삭제)
docker compose down -v
docker compose up -d
```

### 백업 문제

```bash
# 백업 스케줄러 재시작
docker compose restart backup-scheduler

# 수동 백업 테스트
docker compose exec backup-scheduler /scripts/backup.sh

# 백업 로그 확인
tail -f backup/mariadb/backup.log
```

## 📊 모니터링

### 성능 확인

```bash
# 프로세스 확인
docker compose top mariadb

# 리소스 사용량
docker stats mariadb-server

# 데이터베이스 상태
docker compose exec mariadb mariadb -u root -pkmhtest -e "SHOW STATUS;"
```

### 로그 모니터링

```bash
# 실시간 로그 확인
docker compose logs -f mariadb

# 백업 로그 확인
tail -f backup/mariadb/backup.log
```

## 📞 지원

추가 설정이나 문제 해결이 필요한 경우 관리자에게 문의하세요. 