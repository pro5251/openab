#!/bin/bash

# ==============================================================================
# OpenAB 多 Agent 啟動腳本
# ==============================================================================
#
# 說明:
#   啟動 5 個分工 agent 容器（梅長蘇、簡晨、言豫津、蒙摯、夏冬）
#   每個 agent 使用獨立的 Discord Bot Token 與 config
#
#   梅長蘇  → openab-copilot  (Copilot CLI + Claude Sonnet 4.6) Architect
#   簡晨    → openab-gemini   (Gemini CLI + gemini-2.5-pro)     Backend
#   言豫津  → openab-gemini   (Gemini CLI + gemini-2.5-pro)     Frontend
#   蒙摯    → openab-gemini   (Gemini CLI + gemini-2.5-pro)     Ops
#   夏冬    → openab-gemini   (Gemini CLI + gemini-2.5-pro)     QA
#
# 使用方式:
#   ./run-agents.sh                    # 建置並啟動全部
#   ./run-agents.sh --skip-build|-s    # 跳過建置，直接啟動
#   ./run-agents.sh --agent|-a 梅長蘇  # 只啟動指定 agent
#   ./run-agents.sh --stop             # 停止全部
#   ./run-agents.sh --status           # 查看狀態
#
# 前置條件:
#   - .env 已填入 DISCORD_BOT_TOKEN_* 與 PROJECT_DIR
#   - GEMINI_API_KEY 與 COPILOT_GITHUB_TOKEN 已設定
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 自動載入 .env
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "📄 載入 .env 環境變數..."
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
fi

# ------------------------------------------------------------------------------
# 參數解析
# ------------------------------------------------------------------------------
SKIP_BUILD=false
ONLY_AGENT=""
ACTION="start"

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-build|-s)
            SKIP_BUILD=true
            shift ;;
        --agent|-a)
            ONLY_AGENT="$2"
            shift 2 ;;
        --stop)
            ACTION="stop"
            shift ;;
        --status)
            ACTION="status"
            shift ;;
        *)
            shift ;;
    esac
done

# ------------------------------------------------------------------------------
# Docker Compose 設定
# ------------------------------------------------------------------------------
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.multi-agent.yml"
PROJECT_NAME="openab-agents"
COMPOSE_CMD="docker compose -p $PROJECT_NAME -f $COMPOSE_FILE"

# ------------------------------------------------------------------------------
# Agent 定義表  (name  service  dockerfile  image)
# ------------------------------------------------------------------------------
AGENT_NAMES=("梅長蘇" "簡晨" "言豫津" "蒙摯" "夏冬")
declare -A AGENT_SERVICE=(
    ["梅長蘇"]="meichangsu"
    ["簡晨"]="jianchen"
    ["言豫津"]="yanyujin"
    ["蒙摯"]="mengzhi"
    ["夏冬"]="xiadong"
)
declare -A AGENT_DOCKERFILE=(
    ["梅長蘇"]="Dockerfile.copilot"
    ["簡晨"]="Dockerfile.gemini"
    ["言豫津"]="Dockerfile.gemini"
    ["蒙摯"]="Dockerfile.gemini"
    ["夏冬"]="Dockerfile.gemini"
)
declare -A AGENT_IMAGE=(
    ["梅長蘇"]="openab-copilot"
    ["簡晨"]="openab-gemini"
    ["言豫津"]="openab-gemini"
    ["蒙摯"]="openab-gemini"
    ["夏冬"]="openab-gemini"
)

# ------------------------------------------------------------------------------
# --status
# ------------------------------------------------------------------------------
if [ "$ACTION" = "status" ]; then
    echo "=== Agent 狀態 (Project: $PROJECT_NAME) ==="
    $COMPOSE_CMD ps
    exit 0
fi

# ------------------------------------------------------------------------------
# --stop
# ------------------------------------------------------------------------------
if [ "$ACTION" = "stop" ]; then
    echo "🛑 停止所有 agent 容器 (Project: $PROJECT_NAME)..."
    $COMPOSE_CMD down
    echo "完成。"
    exit 0
fi

# ------------------------------------------------------------------------------
# 決定要啟動哪些 agents
# ------------------------------------------------------------------------------
if [ -n "$ONLY_AGENT" ]; then
    if [ -z "${AGENT_SERVICE[$ONLY_AGENT]+_}" ]; then
        echo "❌ 未知的 agent: $ONLY_AGENT"
        echo "   可用: ${AGENT_NAMES[*]}"
        exit 1
    fi
    TARGET_SERVICES=("${AGENT_SERVICE[$ONLY_AGENT]}")
else
    TARGET_SERVICES=("${AGENT_NAMES[@]}") # 這裡其實是指所有服務
    TARGET_SERVICES=()
    for name in "${AGENT_NAMES[@]}"; do
        TARGET_SERVICES+=("${AGENT_SERVICE[$name]}")
    done
fi

# ------------------------------------------------------------------------------
# 前置檢查
# ------------------------------------------------------------------------------
echo "=== 前置檢查 ==="

# PROJECT_DIR
if [ -z "$PROJECT_DIR" ]; then
    echo "❌ PROJECT_DIR 未設定，請在 .env 填入專案路徑"
    exit 1
fi
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ PROJECT_DIR 不存在: $PROJECT_DIR"
    exit 1
fi
echo "  ✓ PROJECT_DIR: $PROJECT_DIR"

# ------------------------------------------------------------------------------
# 建置與啟動
# ------------------------------------------------------------------------------
if [ "$SKIP_BUILD" = false ]; then
    echo
    echo "=== 建置映像檔 ==="
    # 收集需要建置的 (dockerfile, image) 組合（去重）
    declare -A BUILD_DONE=()
    for name in "${AGENT_NAMES[@]}"; do
        # 只建置目標 agent 的 image
        svc="${AGENT_SERVICE[$name]}"
        target_svc=false
        for ts in "${TARGET_SERVICES[@]}"; do
            [ "$ts" = "$svc" ] && target_svc=true && break
        done
        $target_svc || continue

        dockerfile="${AGENT_DOCKERFILE[$name]}"
        image="${AGENT_IMAGE[$name]}"
        key="${dockerfile}:${image}"
        if [ -z "${BUILD_DONE[$key]+_}" ]; then
            echo "  🔨 docker build -f $dockerfile -t $image ."
            docker build -f "$SCRIPT_DIR/$dockerfile" -t "$image" "$SCRIPT_DIR"
            BUILD_DONE[$key]=1
        fi
    done
fi

echo
echo "=== 啟動 Agents (Project: $PROJECT_NAME) ==="
$COMPOSE_CMD up -d --force-recreate "${TARGET_SERVICES[@]}"

# ------------------------------------------------------------------------------
# 結果
# ------------------------------------------------------------------------------
echo
echo "=== 全部完成 ==="
echo "💡 查看日誌："
echo "   $COMPOSE_CMD logs -f"
echo
echo "💡 停止全部："
echo "   ./run-agents.sh --stop"
