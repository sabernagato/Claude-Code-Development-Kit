#!/bin/bash
# Gemini 上下文注入器钩子
# 自动将项目上下文文件添加到新的 Gemini 咨询会话中：
# - docs/ai-context/project-structure.md
# - MCP-ASSISTANT-RULES.md
#
# 此钩子通过自动包含项目的结构文档和助手规则来增强 Gemini 咨询，
# 确保 AI 拥有完整的上下文。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROJECT_STRUCTURE_FILE="$PROJECT_ROOT/docs/ai-context/project-structure.md"
MCP_RULES_FILE="$PROJECT_ROOT/MCP-ASSISTANT-RULES.md"
LOG_FILE="$SCRIPT_DIR/../logs/context-injection.log"

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"

# 从标准输入读取输入
INPUT_JSON=$(cat)

# 记录注入事件的函数
log_injection_event() {
    local event_type="$1"
    local details="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"timestamp\": \"$timestamp\", \"event\": \"$event_type\", \"details\": \"$details\"}" >> "$LOG_FILE"
}

# 主逻辑
main() {
    # 从标准输入提取工具信息
    local tool_name=$(echo "$INPUT_JSON" | jq -r '.tool_name // ""')
    
    # 仅处理 Gemini 咨询请求
    if [[ "$tool_name" != "mcp__gemini__consult_gemini" ]]; then
        echo '{"continue": true}'
        exit 0
    fi
    
    # 提取工具参数
    local tool_args=$(echo "$INPUT_JSON" | jq -r '.tool_input // "{}"')
    
    # 检查这是否为新会话（未提供 session_id）
    local session_id=$(echo "$tool_args" | jq -r '.session_id // ""' 2>/dev/null || echo "")
    
    if [[ -z "$session_id" || "$session_id" == "null" ]]; then
        log_injection_event "new_session_detected" "preparing_context_injection"
        
        # 检查必需文件是否存在
        local missing_files=""
        if [[ ! -f "$PROJECT_STRUCTURE_FILE" ]]; then
            missing_files="$missing_files project_structure.md"
        fi
        if [[ ! -f "$MCP_RULES_FILE" ]]; then
            missing_files="$missing_files MCP-ASSISTANT-RULES.md"
        fi
        
        # 如果任一文件缺失，记录警告但继续执行
        if [[ -n "$missing_files" ]]; then
            log_injection_event "warning" "missing_files:$missing_files"
        fi
        
        # 如果两个文件都缺失，提前退出
        if [[ ! -f "$PROJECT_STRUCTURE_FILE" ]] && [[ ! -f "$MCP_RULES_FILE" ]]; then
            echo '{"continue": true}'
            exit 0
        fi
        
        # 提取当前的 attached_files（如果有）
        local current_files=$(echo "$tool_args" | jq -c '.attached_files // []' 2>/dev/null || echo "[]")
        
        # 检查文件是否已经包含
        local has_project_structure=$(echo "$current_files" | jq -e ".[] | select(. == \"$PROJECT_STRUCTURE_FILE\")" > /dev/null 2>&1 && echo "true" || echo "false")
        local has_mcp_rules=$(echo "$current_files" | jq -e ".[] | select(. == \"$MCP_RULES_FILE\")" > /dev/null 2>&1 && echo "true" || echo "false")
        
        # 如果两个文件都存在且已包含，跳过
        if [[ -f "$PROJECT_STRUCTURE_FILE" ]] && [[ "$has_project_structure" == "true" ]] && \
           [[ -f "$MCP_RULES_FILE" ]] && [[ "$has_mcp_rules" == "true" ]]; then
            log_injection_event "skipped" "all_required_files_already_included"
            echo '{"continue": true}'
            exit 0
        fi
        
        # 将缺失的文件添加到 attached_files
        local modified_args="$tool_args"
        local files_added=""
        
        if [[ -f "$PROJECT_STRUCTURE_FILE" ]] && [[ "$has_project_structure" == "false" ]]; then
            modified_args=$(echo "$modified_args" | jq --arg file "$PROJECT_STRUCTURE_FILE" '
                .attached_files = ((.attached_files // []) + [$file])
            ' 2>/dev/null)
            files_added="$files_added project_structure.md"
        fi
        
        if [[ -f "$MCP_RULES_FILE" ]] && [[ "$has_mcp_rules" == "false" ]]; then
            modified_args=$(echo "$modified_args" | jq --arg file "$MCP_RULES_FILE" '
                .attached_files = ((.attached_files // []) + [$file])
            ' 2>/dev/null)
            files_added="$files_added MCP-ASSISTANT-RULES.md"
        fi
        
        if [[ -n "$modified_args" ]] && [[ "$modified_args" != "$tool_args" ]]; then
            log_injection_event "context_injected" "added_files:$files_added"
            
            # 使用修改后的 tool_input 更新输入 JSON
            local output_json=$(echo "$INPUT_JSON" | jq --argjson new_args "$modified_args" '.tool_input = $new_args')
            
            # 将修改后的输入返回到标准输出
            echo "$output_json"
            exit 0
        else
            log_injection_event "error" "failed_to_modify_arguments"
            # 出错时继续执行而不进行修改
            echo '{"continue": true}'
            exit 0
        fi
    else
        log_injection_event "existing_session" "session_id:$session_id"
        # 对于现有会话，继续执行而不进行修改
        echo '{"continue": true}'
        exit 0
    fi
}

# 运行主函数
main