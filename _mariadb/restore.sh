#!/bin/bash

# 복원 스크립트
# 백업 파일을 MariaDB에 복원

# 설정
BACKUP_DIR="./backup/mariadb"

# 사용법 출력
usage() {
    echo "사용법: $0 <백업파일명>"
    echo "예시: $0 20241201-120000-testdb.sql"
    echo ""
    echo "사용 가능한 백업 파일:"
    ls -la "$BACKUP_DIR"/*.sql 2>/dev/null | awk '{print $9}' | sed 's|.*/||' || echo "백업 파일이 없습니다."
}

# 인수 확인
if [ $# -eq 0 ]; then
    echo "오류: 백업 파일명을 지정해주세요."
    usage
    exit 1
fi

BACKUP_FILE="$BACKUP_DIR/$1"

# 백업 파일 존재 확인
if [ ! -f "$BACKUP_FILE" ]; then
    echo "오류: 백업 파일 '$BACKUP_FILE'을 찾을 수 없습니다."
    usage
    exit 1
fi

# MariaDB 컨테이너가 실행 중인지 확인
if ! docker ps | grep -q mariadb-server; then
    echo "오류: MariaDB 컨테이너가 실행 중이 아닙니다."
    exit 1
fi

echo "복원 시작: $BACKUP_FILE"

# 데이터베이스명 추출 (파일명에서)
DB_NAME=$(echo "$1" | sed 's/.*-\([^.]*\)\.sql$/\1/')

echo "데이터베이스명: $DB_NAME"
echo "복원을 계속하시겠습니까? (y/N)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    # 복원 실행
    echo "복원 중..."
    docker exec -i mariadb-server mariadb -u root -pkmhtest < "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "복원 완료: $BACKUP_FILE"
    else
        echo "오류: 복원 실패"
        exit 1
    fi
else
    echo "복원이 취소되었습니다."
fi 