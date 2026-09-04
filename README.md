# Cat Swapper

这个仓库提供两套基于开放 [Agent Skills](https://agentskills.io/specification) 格式的宠物换图 Skill：

- **Cat Swapper**：把基础壁纸里的猫替换成参考照片中的同一只真实猫；
- **Dog Swapper**：把基础壁纸里的狗替换成参考照片中的同一只真实狗。

两套 Skill 都要求尽量保持基础图的场景、构图、机位、动作和非目标动物内容不变。仓库名称暂时保留为 `cat-swapper`，根目录也继续作为 `$cat-swapper` 入口，以兼容现有安装。

## 仓库结构

```text
cat-swapper/
├── SKILL.md                    # Cat Swapper 入口和执行边界
├── prompt.txt                  # 猫咪专用完整提示词
├── agents/openai.yaml          # Cat Swapper 界面元数据
├── dog-swapper/
│   ├── SKILL.md                # Dog Swapper 独立入口和执行边界
│   ├── prompt.txt              # 狗狗专用完整提示词
│   ├── agents/openai.yaml      # Dog Swapper 界面元数据
│   └── LICENSE
├── README.md
└── LICENSE
```

每个 Skill 调用时只读取自己目录中的 `prompt.txt`，不复制、不缩写，也不改写提示词。

## 选择入口

| 基础图主体 | 身份参考 | 使用入口 | 提示词 |
| --- | --- | --- | --- |
| 猫 | 同一只目标猫的原始照片 | `$cat-swapper` | [`prompt.txt`](prompt.txt) |
| 狗 | 同一只目标狗的原始照片 | `$dog-swapper` | [`dog-swapper/prompt.txt`](dog-swapper/prompt.txt) |

两套入口都只支持同物种身份替换。猫底图换成狗、狗底图换成猫不属于本仓库当前工作流，因为严格保留原动作拓扑与跨物种解剖通常互相冲突。

## 使用前提

运行 Skill 的 Agent 必须能够：

- 接收图片附件；
- 调用支持“一张基础图 + 一张或多张身份参考图”的图像生成或编辑工具；
- 把完整提示词和附件按指定顺序传给该工具。

本仓库不附带模型、API Key、额度或付费调用授权。如果当前 Agent 没有合适的图像工具，Skill 会停止并说明缺少的能力。

## 输入约定

两套入口都按以下顺序上传：

1. **图片 1：唯一基础壁纸**——猫入口要求图中存在待替换的猫，狗入口要求图中存在待替换的狗；
2. **图片 2 起：目标宠物身份参考**——必须是同一只目标猫或目标狗的原始照片，可提供多个角度。

不要把生成图、已经合成过的壁纸或其他宠物的照片当作身份参考。

## 安装

### 通用安装：Codex、Cursor、Gemini CLI、GitHub Copilot

这些平台可从 `.agents/skills` 发现开放格式 Skill。仓库根目录保留 Cat Swapper；Dog Swapper 位于仓库内的独立目录，因此在 macOS/Linux 上用一个符号链接把它暴露为第二个 Skill：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git ~/.agents/skills/cat-swapper
ln -s cat-swapper/dog-swapper ~/.agents/skills/dog-swapper
```

只在当前项目使用：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git .agents/skills/cat-swapper
ln -s cat-swapper/dog-swapper .agents/skills/dog-swapper
```

如果已经安装过旧版 Cat Swapper：

```bash
git -C ~/.agents/skills/cat-swapper pull --ff-only
ln -s cat-swapper/dog-swapper ~/.agents/skills/dog-swapper
```

Codex 若没有立即显示新入口，请重启；Gemini CLI 可运行 `/skills reload`。

### Claude Code

Claude Code 使用同一份 `SKILL.md`。macOS/Linux 全局安装：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git ~/.claude/skills/cat-swapper
ln -s cat-swapper/dog-swapper ~/.claude/skills/dog-swapper
```

项目级安装则把 `~/.claude/skills` 改为项目内的 `.claude/skills`。

## 调用

| 平台 | 猫咪入口 | 狗狗入口 |
| --- | --- | --- |
| OpenAI Codex | `$cat-swapper` | `$dog-swapper` |
| Claude Code | `/cat-swapper` | `/dog-swapper` |
| Cursor | `/cat-swapper` | `/dog-swapper` |
| Gemini CLI | 直接描述换猫任务 | 直接描述换狗任务 |
| GitHub Copilot CLI | `/cat-swapper` | `/dog-swapper` |

猫咪请求示例：

```text
使用 cat-swapper：图1是包含原猫的唯一基础壁纸，图2开始是同一只目标猫的原始身份参考。生成一张结果，不要自动重试。
```

狗狗请求示例：

```text
使用 dog-swapper：图1是包含原狗的唯一基础壁纸，图2开始是同一只目标狗的原始身份参考。生成一张结果，不要自动重试。
```

每套 Skill 都会：

1. 确认附件角色；
2. 完整读取对应的 `prompt.txt`；
3. 按“基础壁纸在前、身份参考在后”的顺序调用当前平台的原生图像工具；
4. 默认只生成一张，不自动重试，也不静默切换模型或服务商；
5. 返回结果，并等待用户决定是否重试。

## 不安装 Skill，手动使用

如果所用 Agent 尚不支持 Agent Skills，可以上传基础壁纸和同一只目标宠物的原始参考照片，再把对应提示词完整原样粘贴给具备多图参考能力的图像工具：

- 猫咪：[`prompt.txt`](prompt.txt)
- 狗狗：[`dog-swapper/prompt.txt`](dog-swapper/prompt.txt)

## 提示词完整性

```text
cat-swapper/prompt.txt
43e3919a1aa03b9c6b8d33451277c65837a78b0bfd6f5df695b8826cf34f1e55

cat-swapper/dog-swapper/prompt.txt
62a979a88391e7fb2d5a6066231eef9bc53a627d746c7fd3a2fb2acac109235f
```

更新或审计时可运行：

```bash
shasum -a 256 prompt.txt dog-swapper/prompt.txt
```

## 当前验证边界

- 猫咪提示词保留现有冻结文本及哈希；
- 狗狗提示词已完成 Skill 结构、物种用词和 YAML 元数据检查；
- 狗狗提示词尚未经过真实图片模型与主人身份判断，不能据此声称跨狗稳定或效果已验收；
- 生成模型可能改变非目标区域，提示词中的严格保持不等于像素级保证。

## 更新

```bash
git -C ~/.agents/skills/cat-swapper pull --ff-only
```

Dog Swapper 使用符号链接安装时会随同一次更新生效。

## 平台格式依据

- [Agent Skills Specification](https://agentskills.io/specification)
- [OpenAI Codex Skills](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code Skills](https://code.claude.com/docs/en/slash-commands)
- [Cursor Agent Skills](https://cursor.com/docs/skills)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
- [GitHub Copilot Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

## License

[MIT](LICENSE)
