#!/bin/bash

echo "=== 1. 최신 코드 가져오기 ==="
git checkout main
git pull origin main

echo "=== 2. 새로운 버전 채번 ==="
# Audit 문서(v0.25.4 등) 양식을 참고하여, 시간 기반으로 유니크한 마이너 버전을 자동 생성합니다.
PATCH_VER=$(date +%M%S)
NEW_VERSION="v0.26.$PATCH_VER"
echo "새로운 배포 버전: $NEW_VERSION"

echo "=== 3. 앱 소스(버전 정보) 변경 시뮬레이션 ==="
# VERSION 파일 생성/수정
echo "$NEW_VERSION" > cmdb-convert/VERSION

# Dockerfile 내용이 변경되어야 새 이미지가 빌드되므로 최하단에 버전 라벨 추가
echo "LABEL version=\"$NEW_VERSION\"" >> cmdb-convert/Dockerfile

echo "=== 4. Git 커밋 및 태그(Release) 생성 ==="
git add .
git commit -m "Release: update image version to $NEW_VERSION"

# 버전 관리를 증명하기 위해 Git Tag도 함께 생성합니다.
git tag $NEW_VERSION

echo "=== 5. GitHub으로 자동 배포 트리거 (Push) ==="
git push origin main
git push origin $NEW_VERSION

echo "=========================================================="
echo " 배포 트리거 완료! GitHub의 Actions 탭을 확인해 보세요."
echo "=========================================================="
