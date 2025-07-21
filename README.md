# MariaDB + Redis Docker Compose 서버

공용으로 사용할 수 있는 MariaDB와 Redis 서버를 Docker Compose로 구성한 설정입니다.

## 📋 포함된 서비스

- **MariaDB**: 최신 버전, 기본 포트 3306
- **Redis**: 최신 버전, 기본 포트 6379

## 🚀 시작하기

### 1. 서비스 시작

```bash
# 백그라운드에서 서비스 시작
docker compose up -d

# 로그와 함께 서비스 시작
docker compose up
```

### 2. 서비스 상태 확인

```bash
# 실행 중인 컨테이너 확인
docker compose ps

# 서비스 로그 확인
docker compose logs

# 특정 서비스 로그 확인
docker compose logs mariadb
docker compose logs redis
```

### 3. 서비스 중지

```bash
# 서비스 중지
docker compose stop

# 서비스 중지 및 컨테이너 삭제
docker compose down

# 볼륨까지 삭제
docker compose down -v
```

## 🔧 설정 정보

### MariaDB 설정

- **호스트**: localhost
- **포트**: 3306
- **사용자**: root
- **비밀번호**: kmhtest
- **데이터베이스**: testdb
- **데이터 저장 경로**: ./mysql_data

### Redis 설정

- **호스트**: localhost
- **포트**: 6379
- **비밀번호**: 없음
- **최대 메모리**: 2GB
- **정책**: allkeys-lru

## 🌐 외부 접속

### MariaDB 외부 접속

```bash
# 명령줄에서 접속
mysql -h localhost -P 3306 -u root -p

# 다른 서버에서 접속
mysql -h YOUR_SERVER_IP -P 3306 -u root -p
```

### Redis 외부 접속

```bash
# 명령줄에서 접속
redis-cli -h localhost -p 6379

# 다른 서버에서 접속
redis-cli -h YOUR_SERVER_IP -p 6379
```

## 📂 파일 구조

```
.
├── docker-compose.yml    # Docker Compose 설정
├── .env                  # 환경 변수 설정
├── init.sql             # MariaDB 초기화 스크립트
├── mysql_data/          # MariaDB 데이터 저장 폴더
└── README.md            # 사용법 안내
```

## 🔒 보안 설정

- MariaDB는 `--bind-address=0.0.0.0`으로 설정되어 외부 접속이 가능합니다
- Redis는 `--protected-mode no`로 설정되어 외부 접속이 가능합니다
- 프로덕션 환경에서는 적절한 보안 설정을 추가해주세요

## 🛠️ 사용자 정의 설정

### 환경 변수 수정

`.env` 파일을 편집하여 설정을 변경할 수 있습니다:

```env
# MariaDB 설정
MYSQL_ROOT_PASSWORD=your_password
MYSQL_DATABASE=your_database
MYSQL_USER=root
MYSQL_PASSWORD=your_password

# 포트 설정
MARIADB_PORT=3306
REDIS_PORT=6379

# Redis 설정
REDIS_MAXMEMORY=2gb
REDIS_MAXMEMORY_POLICY=allkeys-lru
```

### 초기 SQL 스크립트 수정

`init.sql` 파일을 편집하여 초기 데이터베이스 설정을 변경할 수 있습니다.

## 🧪 테스트 연결

### MariaDB 연결 테스트

```bash
# 컨테이너 내부에서 연결 테스트
docker compose exec mariadb mysql -u root -p

# 외부에서 연결 테스트
docker compose exec mariadb mysql -h mariadb -u root -p
```

### Redis 연결 테스트

```bash
# 컨테이너 내부에서 연결 테스트
docker compose exec redis redis-cli

# 외부에서 연결 테스트
docker compose exec redis redis-cli -h redis
```

## 📊 모니터링

### 헬스체크 확인

```bash
# 헬스체크 상태 확인
docker compose ps

# 컨테이너 상태 확인
docker inspect <container_name>
```

### 리소스 사용량 확인

```bash
# 실시간 리소스 사용량
docker compose top

# 통계 정보
docker stats
```

## 🚨 문제 해결

### 포트 충돌 문제

포트가 이미 사용 중인 경우 `.env` 파일에서 포트를 변경하세요:

```env
MARIADB_PORT=3307
REDIS_PORT=6380
```

### 권한 문제

MariaDB 접속 권한 문제가 있는 경우:

```bash
# 컨테이너 재시작
docker compose restart mariadb

# 초기화 스크립트 재실행
docker compose down -v
docker compose up -d
```

### 볼륨 초기화

데이터를 완전히 초기화하려면:

```bash
# 모든 볼륨 삭제
docker compose down -v

# 다시 시작
docker compose up -d
```

## 📞 지원

문제가 발생하거나 추가 설정이 필요한 경우, 관리자에게 문의하세요. 