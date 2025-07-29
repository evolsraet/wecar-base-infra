# Base Infrastructure

Docker Compose를 사용한 기본 인프라 서비스입니다.

## 📋 포함된 서비스

- **MariaDB**: 데이터베이스 서버 (포트 3306)
- **Redis**: 캐시 서버 (포트 6379)

## 🚀 시작하기

```bash
# 서비스 시작
docker compose up -d

# 서비스 상태 확인
docker compose ps

# 서비스 중지
docker compose down
```

## 📂 프로젝트 구조

```
.
├── docker-compose.yml    # Docker Compose 설정
├── .env                  # 환경 변수 설정
├── _mariadb/            # MariaDB 설정 관련 파일들
├── backup/              # 백업 파일 저장소
│   └── mariadb/         # MariaDB 백업 파일들
│       ├── *.sql        # 백업 파일들
│       └── backup.log   # 백업 로그
├── mysql_data/          # MariaDB 데이터 저장 폴더
└── README.md            # 사용법 안내
```

## 🔧 설정

`.env` 파일에서 환경 변수를 수정할 수 있습니다:

```env
# MariaDB 설정
MYSQL_ROOT_PASSWORD=kmhtest
MYSQL_DATABASE=testdb
MYSQL_USER=testuser
MYSQL_PASSWORD=kmhtest
MARIADB_PORT=3306

# Redis 설정
REDIS_PORT=6379
REDIS_MAXMEMORY=256mb
REDIS_MAXMEMORY_POLICY=allkeys-lru
```

## 📞 지원

MariaDB 관련 상세 정보는 `_mariadb/README.md`를 참조하세요. 