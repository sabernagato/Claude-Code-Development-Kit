# API 集成规范：示例外部服务

## 概述

本文档概述了与外部服务 API 的集成。这作为 API 集成规范文档的模板。

### 集成目标
- 连接外部服务进行数据处理
- 实现错误处理和重试逻辑
- 确保安全的 API 通信
- 保持性能和可靠性

### 外部服务详情
- **服务**：示例数据处理 API
- **版本**：v2.1
- **身份验证**：API 密钥 + OAuth2
- **速率限制**：1000 请求/分钟
- **文档**：https://api.example.com/docs

## 架构

### 集成流程
```
客户端请求 → 输入验证 → 外部 API 调用 → 响应处理 → 客户端响应
```

### 错误处理流程
```
API 错误 → 重试逻辑 → 回退策略 → 错误日志 → 客户端错误响应
```

## 技术规范

### 1. API 客户端实现

#### 配置
```python
# 配置设置
API_BASE_URL = "https://api.example.com/v2"
API_KEY = "your-api-key"
OAUTH_CLIENT_ID = "your-client-id"
OAUTH_CLIENT_SECRET = "your-client-secret"
REQUEST_TIMEOUT = 30  # 秒
MAX_RETRIES = 3
RETRY_DELAY = 1  # 秒
```

#### 客户端类
```python
import aiohttp
import asyncio
from typing import Dict, Any, Optional

class ExternalAPIClient:
    def __init__(self, api_key: str, base_url: str):
        self.api_key = api_key
        self.base_url = base_url
        self.session: Optional[aiohttp.ClientSession] = None
        self.access_token: Optional[str] = None
    
    async def __aenter__(self):
        self.session = aiohttp.ClientSession(
            timeout=aiohttp.ClientTimeout(total=REQUEST_TIMEOUT)
        )
        await self.authenticate()
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        if self.session:
            await self.session.close()
    
    async def authenticate(self) -> None:
        """使用 OAuth2 进行身份验证以获取访问令牌"""
        auth_url = f"{self.base_url}/oauth/token"
        auth_data = {
            "grant_type": "client_credentials",
            "client_id": OAUTH_CLIENT_ID,
            "client_secret": OAUTH_CLIENT_SECRET
        }
        
        async with self.session.post(auth_url, data=auth_data) as response:
            if response.status == 200:
                auth_response = await response.json()
                self.access_token = auth_response["access_token"]
            else:
                raise APIAuthenticationError("无法与外部 API 进行身份验证")
```

### 2. API 操作

#### 数据处理操作
```python
async def process_data(
    self, 
    data: Dict[str, Any], 
    options: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """使用外部 API 处理数据"""
    endpoint = f"{self.base_url}/process"
    headers = {
        "Authorization": f"Bearer {self.access_token}",
        "X-API-Key": self.api_key,
        "Content-Type": "application/json"
    }
    
    payload = {
        "data": data,
        "options": options or {}
    }
    
    for attempt in range(MAX_RETRIES):
        try:
            async with self.session.post(
                endpoint, 
                json=payload, 
                headers=headers
            ) as response:
                
                if response.status == 200:
                    return await response.json()
                elif response.status == 429:
                    # 超出速率限制
                    await asyncio.sleep(RETRY_DELAY * (2 ** attempt))
                    continue
                elif response.status == 401:
                    # 令牌过期，重新身份验证
                    await self.authenticate()
                    continue
                else:
                    response.raise_for_status()
                    
        except aiohttp.ClientError as e:
            if attempt == MAX_RETRIES - 1:
                raise ExternalAPIError(f"API 请求在 {MAX_RETRIES} 次尝试后失败: {str(e)}")
            await asyncio.sleep(RETRY_DELAY * (2 ** attempt))
    
    raise ExternalAPIError("超出最大重试次数")
```

### 3. 错误处理

#### 自定义异常
```python
class ExternalAPIError(Exception):
    """外部 API 错误的基础异常"""
    pass

class APIAuthenticationError(ExternalAPIError):
    """与外部 API 的身份验证失败"""
    pass

class APIRateLimitError(ExternalAPIError):
    """超出速率限制"""
    pass

class APITimeoutError(ExternalAPIError):
    """请求超时"""
    pass
```

#### 错误响应映射
```python
def map_api_error(status_code: int, response_data: Dict[str, Any]) -> ExternalAPIError:
    """将 API 错误响应映射到自定义异常"""
    error_mapping = {
        400: ("Bad Request", ExternalAPIError),
        401: ("Unauthorized", APIAuthenticationError),
        429: ("Rate Limit Exceeded", APIRateLimitError),
        500: ("Internal Server Error", ExternalAPIError),
        503: ("Service Unavailable", ExternalAPIError)
    }
    
    error_message, exception_class = error_mapping.get(
        status_code, 
        (f"未知错误 (状态: {status_code})", ExternalAPIError)
    )
    
    # 如果可用，包含 API 错误详情
    if "error" in response_data:
        error_message += f": {response_data['error']}"
    
    return exception_class(error_message)
```

## 实施计划

### 第 1 阶段：基础集成（第 1 周）
- [ ] API 客户端实现
- [ ] 身份验证流程
- [ ] 基本数据处理端点
- [ ] 错误处理结构
- [ ] 配置管理

### 第 2 阶段：高级功能（第 2 周）
- [ ] 指数退避的重试逻辑
- [ ] 速率限制处理
- [ ] 连接池
- [ ] 响应缓存
- [ ] 监控和日志

### 第 3 阶段：测试与优化（第 3 周）
- [ ] API 客户端的单元测试
- [ ] 使用模拟 API 的集成测试
- [ ] 性能测试
- [ ] 错误场景测试
- [ ] 文档更新

### 第 4 阶段：生产部署（第 4 周）
- [ ] 生产配置
- [ ] 监控设置
- [ ] 性能优化
- [ ] 安全审计
- [ ] 部署和推出

## API 端点

### 处理数据
```http
POST /api/external/process
Content-Type: application/json
Authorization: Bearer {access_token}

{
    "data": {
        "input": "data to process",
        "format": "json"
    },
    "options": {
        "async": false,
        "callback_url": "https://yourapp.com/callback"
    }
}
```

**响应：**
```json
{
    "success": true,
    "result": {
        "processed_data": "...",
        "metadata": {
            "processing_time": 1.5,
            "version": "v2.1"
        }
    },
    "request_id": "req_abc123"
}
```

### 获取处理状态
```http
GET /api/external/status/{request_id}
Authorization: Bearer {access_token}
```

**响应：**
```json
{
    "request_id": "req_abc123",
    "status": "completed",
    "result": {
        "processed_data": "...",
        "metadata": {}
    },
    "created_at": "2024-01-15T10:30:00Z",
    "completed_at": "2024-01-15T10:30:15Z"
}
```

## 性能考虑

### 连接管理
- 为多个请求使用连接池
- 实现连接超时
- 监控连接健康状态

### 缓存策略
- 缓存身份验证令牌
- 缓存频繁请求的数据
- 实现缓存失效

### 速率限制
- 实现客户端速率限制
- 在速率限制期间对请求进行排队
- 监控速率限制状态

## 安全考虑

### 身份验证
- API 密钥和秘密的安全存储
- 令牌刷新机制
- 定期凭据轮换

### 数据保护
- 加密传输中的敏感数据
- 验证所有输入数据
- 清理 API 响应

### 监控
- 记录所有 API 交互
- 监控可疑活动
- 跟踪错误率和模式

## 测试策略

### 单元测试
```python
import pytest
from unittest.mock import AsyncMock, patch

@pytest.mark.asyncio
async def test_successful_data_processing():
    with patch('aiohttp.ClientSession') as mock_session:
        mock_response = AsyncMock()
        mock_response.status = 200
        mock_response.json.return_value = {"result": "processed"}
        
        mock_session.return_value.__aenter__.return_value.post.return_value.__aenter__.return_value = mock_response
        
        client = ExternalAPIClient("test-key", "https://api.test.com")
        result = await client.process_data({"input": "test"})
        
        assert result["result"] == "processed"
```

### 集成测试
- 使用实际 API 端点进行测试（暂存环境）
- 测试错误场景和恢复
- 测试速率限制行为
- 测试身份验证流程

## 监控和日志

### 需要跟踪的指标
- 请求成功/失败率
- 响应时间
- 速率限制状态
- 身份验证失败
- 错误分布

### 日志格式
```json
{
    "timestamp": "2024-01-15T10:30:00Z",
    "level": "INFO",
    "event": "external_api_request",
    "request_id": "req_abc123",
    "endpoint": "/process",
    "method": "POST",
    "status_code": 200,
    "response_time": 1.5,
    "retry_count": 0
}
```

## 配置

### 环境变量
```bash
# 外部 API 配置
EXTERNAL_API_BASE_URL=https://api.example.com/v2
EXTERNAL_API_KEY=your-api-key
EXTERNAL_OAUTH_CLIENT_ID=your-client-id
EXTERNAL_OAUTH_CLIENT_SECRET=your-client-secret

# 请求配置
EXTERNAL_API_TIMEOUT=30
EXTERNAL_API_MAX_RETRIES=3
EXTERNAL_API_RETRY_DELAY=1

# 缓存
EXTERNAL_API_CACHE_TTL=300
REDIS_URL=redis://localhost:6379
```

## 相关文件

实施后，使用实际文件路径更新此列表：
- `src/integrations/external_api.py` - 主 API 客户端
- `src/integrations/exceptions.py` - 自定义异常
- `src/api/routes/external.py` - 集成端点
- `tests/test_external_api.py` - 集成测试
- `config/external_api.py` - 配置设置

## 成功标准

- [ ] 所有 API 操作正常运行
- [ ] 错误处理健壮
- [ ] 满足性能要求
- [ ] 满足安全要求
- [ ] 实施监控和日志
- [ ] 测试通过（单元和集成）
- [ ] 文档完整

---

*本 API 集成规范模板提供了一种全面的方法来记录外部服务集成。根据您的具体 API 要求和集成需求进行自定义。*