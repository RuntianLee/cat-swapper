# Cat Swapper

Cat Swapper 是一个基于开放 [Agent Skills](https://agentskills.io/specification) 格式的猫咪换图 Skill：把基础壁纸里的猫替换成参考照片中的同一只真实猫，同时尽量保持场景、构图、机位、动作和其他内容不变。

仓库保留了完整原始 [`prompt.txt`](prompt.txt)，Skill 每次调用都读取该文件，不复制、不缩写，也不改写提示词。

## 仓库结构

```text
cat-swapper/
├── SKILL.md              # 跨平台 Skill 入口和执行边界
├── prompt.txt            # 完整、未改写的生图提示词
├── agents/
│   └── openai.yaml       # Codex 可选界面元数据
├── README.md
└── LICENSE
```

## 使用前提

运行该 Skill 的 Agent 必须能够：

- 接收图片附件；
- 调用支持“一张基础图 + 一张或多张身份参考图”的图像生成或编辑工具；
- 把完整提示词和附件按指定顺序传给该工具。

Cat Swapper 本身不附带模型、API Key、额度或付费调用授权。如果当前 Agent 没有合适的图像工具，Skill 会停止并说明缺少的能力，而不会假装已经生成。

## 输入约定

请按以下顺序上传：

1. **图片 1：唯一基础壁纸**——要保留场景、构图和动作的原图；
2. **图片 2 起：目标猫身份参考**——必须是同一只猫的原始照片，可提供多个角度。

不要把生成图、已经合成过的壁纸或其他猫的照片当作身份参考。

## 安装

### 通用安装：Codex、Cursor、Gemini CLI、GitHub Copilot

这些平台都能发现 `.agents/skills` 下的开放格式 Skill。全局安装：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git ~/.agents/skills/cat-swapper
```

只在当前项目使用：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git .agents/skills/cat-swapper
```

### Claude Code

Claude Code 使用同一份 `SKILL.md`，安装到其 Skills 目录：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git ~/.claude/skills/cat-swapper
```

项目级安装则把目标路径改为 `.claude/skills/cat-swapper`。

### Gemini CLI 安装命令

也可以让 Gemini CLI 直接安装此仓库：

```bash
gemini skills install https://github.com/RuntianLee/cat-swapper.git
```

## 调用

安装并重新启动 Agent 后，上传图片，再用平台支持的方式调用：

| 平台 | 调用方式 |
| --- | --- |
| OpenAI Codex | 输入 `$cat-swapper`，或直接描述换猫任务让 Codex 自动匹配 |
| Claude Code | 输入 `/cat-swapper`，或直接描述任务 |
| Cursor | 输入 `/cat-swapper`，或直接描述任务 |
| Gemini CLI | 直接描述任务；可先用 `/skills list` 确认已发现 |
| GitHub Copilot CLI | 输入 `/cat-swapper`，或让 Agent 自动匹配 |

建议请求：

```text
使用 cat-swapper：图1是唯一基础壁纸，图2开始是同一只目标猫的原始身份参考。生成一张结果，不要自动重试。
```

Skill 会：

1. 确认附件角色；
2. 完整读取 `prompt.txt`；
3. 按“基础壁纸在前、身份参考在后”的顺序调用当前平台的原生图像工具；
4. 默认只生成一张，不自动重试，也不静默切换模型或服务商；
5. 返回结果，并等待用户决定是否重试。

## 不安装 Skill，手动使用

如果所用 Agent 尚不支持 Agent Skills，也可以：

1. 先上传基础壁纸；
2. 再上传同一只目标猫的原始参考照片；
3. 把 [`prompt.txt`](prompt.txt) 的完整内容原样粘贴给具备多图参考能力的图像工具；
4. 明确要求只生成一张，失败后不要自动重试。

## 提示词完整性

当前 `prompt.txt` 的 SHA-256：

```text
43e3919a1aa03b9c6b8d33451277c65837a78b0bfd6f5df695b8826cf34f1e55
```

更新或审计时可运行：

```bash
shasum -a 256 prompt.txt
```

## 更新

以通用全局路径为例：

```bash
git -C ~/.agents/skills/cat-swapper pull --ff-only
```

## 平台格式依据

- [Agent Skills Specification](https://agentskills.io/specification)
- [OpenAI Codex Skills](https://developers.openai.com/codex/skills/)
- [Claude Code Skills](https://code.claude.com/docs/en/slash-commands)
- [Cursor Agent Skills](https://cursor.com/docs/skills)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/skills.md)
- [GitHub Copilot Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

## License

[MIT](LICENSE)
