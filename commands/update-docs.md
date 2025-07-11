您刚刚完成了 VR 语言学习应用项目的工作。根据提供的上下文分析更改并自动更新相关文档。

## 自动加载的项目上下文：
@/CLAUDE.md
@/docs/ai-context/project-structure.md
@/docs/ai-context/docs-overview.md

## 核心文档原则：仅记录当前状态

**关键：始终记录系统的当前"是"状态。永远不要引用遗留实现、描述所做的改进或解释发生了什么变化。文档应该读起来就像当前实现一直存在一样。**

### 要避免的文档反模式：
- ❌ "重构了语音管道以使用流式处理而不是批处理"
- ❌ "通过实现缓存提高了性能"
- ❌ "以前使用 X，现在使用 Y 以获得更好的结果"
- ❌ "遗留实现已被替换为..."

### 文档最佳实践：
- ✅ "语音管道使用流式处理进行实时处理"
- ✅ "为频繁访问的数据实现缓存"
- ✅ "使用 Y 以获得最佳结果"
- ✅ "系统架构遵循..."

## 步骤 1：基于输入分析更改

### 确定分析模式：
- **无输入（默认）**：分析最近的对话上下文
- **Git 提交 ID**（例如，"3b8d24e" 或完整哈希）：分析特定提交
- **"uncommitted"/"staged"/"working"**：分析未提交的更改
- **"last N commits"**（例如，"last 3 commits"）：分析最近的提交

### 执行分析：
基于输入参数：

#### 对于 Git 提交分析：
```bash
# 获取提交详情
git show --name-status [COMMIT_ID]
git diff [COMMIT_ID]^ [COMMIT_ID]
```

#### 对于未提交的更改：
```bash
# 获取暂存和未暂存的更改
git status --porcelain
git diff HEAD
git diff --cached
```

#### 对于最近的提交：
```bash
# 获取最近的提交历史
git log --oneline -n [N]
git diff HEAD~[N] HEAD
```

#### 对于会话上下文（默认）：
回顾您最近的对话和工具使用以查找重要更改。

**查找文档相关更改的证据：**
- **新功能或组件**（需要记录的功能）
- **架构决策**（新模式、结构更改、设计决策）
- **技术栈更改**（新依赖项、框架添加、集成更改）
- **API 更改**（新端点、修改的接口、破坏性更改）
- **配置更改**（新环境变量、设置、部署要求）
- **文件结构更改**（新目录、移动的组件、重组的代码）

**从文档更新中排除：**
- 没有架构影响的性能优化
- 不改变接口或模式的错误修复
- 不影响使用的代码清理、重构
- 日志改进、调试增强
- 没有新功能的测试添加

**生成完成内容的简要摘要**：
```
分析来源：[会话上下文/提交 ID/未提交的更改]
检测到的更改：[主要工作的 1-2 句话摘要]
```

## 步骤 2：理解项目上下文和文档结构

分析自动加载的基础文件：
1. `/CLAUDE.md` - **关键：**理解管理项目的 AI 指令、编码标准和开发协议
2. `/docs/ai-context/project-structure.md` - **基础：**技术栈、完整文件树和架构概述
3. `/docs/ai-context/docs-overview.md` - 理解：
   - 存在哪些文档文件及其用途
   - 文档是如何组织的
   - 哪些类型的更改映射到哪些文档

**AI 优先文档原则**：记住文档主要供 AI 使用 - 优化文件路径引用、清晰的结构标记和机器可读模式，以实现高效的上下文加载。

## 步骤 3：智能更新策略决策

基于自动加载的项目上下文和检测到的更改，深入思考所需的文档更新。基于步骤 1 检测到的更改和自动加载的项目上下文，智能决定最佳方法：

### 策略选项：

**直接更新**（0-1 个子代理）：
- 具有明确文档映射的简单文件修改
- 不影响架构的错误修复或小增强
- 限于单个组件或功能区域的更改
- 项目中已经有良好记录的标准模式

**聚焦分析**（2-3 个子代理）：
- 影响多个文件的中等复杂度更改
- 引入新模式的新功能
- 跨越 2-3 个组件或文档层的更改
- 需要跨文档验证的技术栈更新

**全面分析**（3+ 个子代理）：
- 影响多个系统区域的复杂架构更改
- 重构组件关系的主要重构
- 创建跨系统依赖的新集成
- 需要大量文档级联更新的更改

## 步骤 4：执行选定策略

### 对于直接更新：
使用检测到的更改和自动加载的基础上下文进行直接文档更新。继续步骤 5（最终决策）。

### 对于子代理方法：
You have complete autonomy to design sub-agents based on the specific changes detected. Consider these investigation areas and design custom agents to cover what's most relevant:

**Core Investigation Areas to Consider:**
- **Change Impact Analysis**: Map file modifications to affected documentation across all tiers
- **Architecture Validation**: Verify existing architectural docs still reflect current implementation
- **Cross-Component Dependency Mapping**: Identify documentation updates needed due to integration changes
- **Documentation Accuracy Assessment**: Validate current docs against modified code patterns
- **Tier Cascade Requirements**: Determine which documentation levels need updates based on change scope
- **Technology Stack Verification**: Ensure tech stack changes are reflected across relevant documentation

**Autonomous Sub-Agent Design Principles:**
- **Custom Specialization**: Define agents based on the specific change complexity and documentation impact
- **Flexible Agent Count**: Use as many agents as needed - scale based on actual change scope
- **Adaptive Coverage**: Ensure all affected documentation areas are covered without unnecessary overlap
- **Update-Focused Analysis**: Prioritize investigation that directly supports accurate documentation updates

**Sub-Agent Task Template:**
```
Task: "Analyze [SPECIFIC_INVESTIGATION_AREA] for documentation updates based on changes from [SOURCE]: [DETECTED_CHANGES]"

Standard Investigation Workflow:
1. Review auto-loaded project context (CLAUDE.md, project-structure.md, docs-overview.md)
2. [CUSTOM_ANALYSIS_STEPS] - Investigate the specific area thoroughly
3. Return actionable findings that identify required documentation updates

Return comprehensive findings addressing this investigation area for documentation updates.
```

**CRITICAL: When using sub-agents, always launch them in parallel using a single message with multiple Task tool invocations.**

## 步骤 5：综合分析并规划更新

### For Sub-Agent Approaches:
Think deeply about integrating findings from all sub-agent investigations for optimal documentation updates. Combine findings from all agents to create optimal documentation update strategy:

**Integration Analysis:**
- **Change Impact**: Use Change Impact Agent's mapping of modifications to documentation
- **Architecture Validation**: Apply Architecture Validation Agent's findings on outdated information
- **Dependency Updates**: Implement Cross-Component Agent's integration change requirements
- **Accuracy Corrections**: Address Documentation Accuracy Agent's identified inconsistencies
- **Cascade Planning**: Execute Tier Cascade Agent's multi-level update requirements

**Update Strategy Decision:**
Based on synthesized analysis, determine:
- **Documentation scope**: Which files need updates and at what detail level
- **Update priority**: Critical architectural changes vs. minor pattern updates
- **Cascade requirements**: Which tier levels need coordinated updates
- **New file creation**: Whether new documentation files are warranted

## 步骤 6：最终决策

基于您的上下文分析和自动加载的文档结构（直接或从子代理综合），决定：
- **哪些文档需要更新**（将更改匹配到适当的文档）
- **什么类型的更新**（组件更改、架构决策、新模式等）
- **更新范围**（主要更改获得更多细节，次要更改获得简要更新）
- **是否需要新的文档文件**（请参见下面的智能文件创建准则）

## 步骤 7：智能文件创建（如需要）

Before updating existing documentation, assess if new documentation files should be created based on the 3-tier system:

### Guidelines for Creating New Documentation Files

**Create new Component CONTEXT.md when:**
- You detect an entirely new top-level component (new directory under `agents/`, `unity-client/`, `supabase-functions/`, etc.)
- The component has significant functionality (5+ meaningful files)
- Example: Adding `agents/lesson-generator/` → Create `agents/lesson-generator/CONTEXT.md`

**Create new Feature-Specific CONTEXT.md when:**
- You detect a new complex subsystem within an existing component
- The subsystem has 3+ files and represents a distinct functional area
- No existing granular CONTEXT.md file covers this area
- Example: Adding `agents/tutor-server/src/features/translation/` with multiple files → Create `agents/tutor-server/src/features/CONTEXT.md`

**When NOT to create new files:**
- Small additions (1-2 files) that fit existing documentation scope
- Bug fixes or minor modifications
- Temporary or experimental code

**File Creation Process:**
1. **Create the new CONTEXT.md file** with placeholder content following the pattern of existing granular docs
2. **Update `/docs/ai-context/docs-overview.md`** to include the new file in the appropriate tier
3. **Document the addition** in the current update process

### File Content Template for New Granular CONTEXT.md:
```markdown
# [Feature Area] Documentation

*This file documents [specific area] patterns and implementations within [component].*

## [Area] Architecture
- [Key architectural elements]

## Implementation Patterns
- [Key patterns used]

## Integration Points
- [How this integrates with other parts]

---

*This file was created as part of the 3-tier documentation system to document [brief reason].*
```

## 步骤 8：层级优先的文档更新

**CRITICAL: Always start with Tier 3 (feature-specific) documentation and work upward through the tiers. Never skip tiers.**

### Tier 3 (Feature-Specific) - START HERE
**Always begin with the most granular documentation closest to your changes:**
- **Identify affected Tier 3 files** (feature-specific CONTEXT.md files in subdirectories)
- **Update these granular files first** with specific implementation details, patterns, and integration points
- **Examples**: `agents/tutor-server/src/core/pipelines/CONTEXT.md`, `web-dashboard/src/lib/api/CONTEXT.md`, `agents/tutor-server/src/features/*/CONTEXT.md`
- **Update guidelines**: Be specific about file names, technologies, implementation patterns

### Tier 2 (Component-Level) - CASCADE UP
**After completing Tier 3 updates, evaluate if component-level changes are needed:**
- **Check parent component CONTEXT.md files** (e.g., `agents/tutor-server/CONTEXT.md` for changes in `agents/tutor-server/src/*/`)
- **Update if changes represent significant architectural shifts** affecting the overall component
- **Focus on**: How granular changes affect component architecture, new integration patterns, major feature additions
- **Examples**: `agents/tutor-server/CONTEXT.md`, `web-dashboard/CONTEXT.md`, `unity-client/CONTEXT.md`

### Tier 1 (Foundational) - CASCADE UP
**Finally, check if foundational documentation needs updates for system-wide impacts:**

#### Project Structure Updates (`/docs/ai-context/project-structure.md`)
Update for any of these changes:
- **File tree changes**: Created, moved, deleted files/directories; renamed components; restructured organization
- **Technology stack updates**: New dependencies (check pyproject.toml, package.json), major version updates, new frameworks, AI service changes, development tool modifications

#### Other Foundational Documentation
Update other `/docs/ai-context/` files if changes affect:
- **System-wide architectural patterns**
- **Cross-component integration approaches**
- **Development workflow or standards**

### Cascade Decision Logic
**What Constitutes "Significant Updates" Requiring Cascade:**
- **New major feature areas** (not just bug fixes or minor enhancements)
- **Architectural pattern changes** that affect how components integrate with others
- **New technologies or frameworks** introduced to a component
- **Major refactoring** that changes component structure or responsibilities
- **New integration points** between components or external systems

### Update Quality Guidelines (All Tiers)
- **Be concise** (max 3 sentences unless major architectural change)
- **Be specific** (include file names, technologies, key benefits)
- **Follow existing patterns** in each document
- **Avoid redundancy** (don't repeat what's already documented)
- **Co-locate knowledge** (keep documentation near relevant code)

## 步骤 9：更新文档概览

**IMPORTANT:** After updating any documentation files in steps 1-8, check if the documentation overview needs updates:
- Reference the auto-loaded `/docs/ai-context/docs-overview.md`
- If you added new documentation files (especially new CONTEXT.md files), update the overview to include them in the appropriate tier
- If you significantly changed the structure/purpose of existing documentation, update the overview to reflect these changes
- Keep the overview accurate and current so it serves as a reliable guide to the documentation architecture

### Special Note for New CONTEXT.md Files:
When you create new granular CONTEXT.md files, you MUST add them to the appropriate section in docs-overview.md:
- **Tier 2 (Component-Level)**: For new top-level components
- **Tier 3 (Feature-Specific)**: For new subsystem documentation within existing components

## 质量准则

- **简洁：**保持更新简短而专注
- **具体：**包括文件名、技术、关键优势
- **准确：**基于实际所做的更改，而非假设
- **有用：**对其他开发者有用的信息
- **当前：**确保文件树反映实际的项目结构
- **有序：**遵循三层文档系统原则

## 何时不更新或创建文档

跳过文档更新/创建的情况：
- 错误修复（除非它们改变架构）
- 小调整或清理
- 调试或临时更改
- 代码格式化或注释
- 琐碎的修改
- 适合现有文档范围的单文件添加

## 三层系统的优势

这种增强的方法利用三层文档系统来：
- **最小化级联效应**：大多数更改仅更新 1-2 个细粒度文件
- **智能扩展**：仅在必要时创建新文档
- **知识共置**：文档位于相关代码附近
- **保持一致性**：关于何时以及如何扩展文档的明确准则

现在分析指定的更改并相应地更新相关文档。