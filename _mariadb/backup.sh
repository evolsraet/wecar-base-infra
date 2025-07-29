#!/bin/bash

# 백업 스크립트 (Docker 컨테이너 내부에서 실행)
# 매일 0시에 실행되어 스키마별로 덤프를 생성하고 7일이 지난 백업을 삭제

# 한국 시간대 설정
export TZ=Asia/Seoul

# 설정
BACKUP_DIR="/backup"
LOG_DIR="/backup"
DATE_FORMAT=$(date +"%Y%m%d-%H%M%S")
RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-7}

# 로그 함수
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S KST')] $1" | tee -a "$LOG_DIR/backup.log"
}

# 백업 디렉토리 생성
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# 백업 시작 로그
log "백업 시작: $DATE_FORMAT (KST)"

# 데이터베이스 목록 가져오기
DATABASES=$(mysql -h mariadb -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

# 각 데이터베이스별 백업 생성
for DB in $DATABASES; do
    if [ -n "$DB" ]; then
        BACKUP_FILE="$BACKUP_DIR/${DATE_FORMAT}-${DB}.sql"
        log "백업 중: $DB -> $BACKUP_FILE"
        
        # mysqldump로 백업 생성
        mysqldump -h mariadb -u root -p${MYSQL_ROOT_PASSWORD} \
            --single-transaction \
            --routines \
            --triggers \
            --events \
            --add-drop-database \
            --add-drop-table \
            "$DB" > "$BACKUP_FILE"
        
        if [ $? -eq 0 ]; then
            log "백업 완료: $DB (크기: $(du -h "$BACKUP_FILE" | cut -f1))"
        else
            log "오류: $DB 백업 실패"
        fi
    fi
done

# 7일이 지난 백업 파일 삭제
log "오래된 백업 파일 정리 중..."
find "$BACKUP_DIR" -name "*.sql" -type f -mtime +$RETENTION_DAYS -delete
log "정리 완료: $RETENTION_DAYS일 이상 된 백업 파일 삭제됨"

# 백업 완료 로그
log "백업 완료: $DATE_FORMAT (KST)"
log "----------------------------------------" 