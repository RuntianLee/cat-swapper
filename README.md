# Cat Swapper

基于开放 [Agent Skills](https://agentskills.io/specification) 格式的宠物壁纸身份替换工具。仓库名称保留为 `cat-swapper`，提供三个并列入口：

| 入口 | 用途 | 安装要求 |
| --- | --- | --- |
| [`pet-swapper`](skills/pet-swapper/SKILL.md) | 公共入口，根据用户选择或图片物种进入猫/狗 Skill | 三个 Skill 并列安装 |
| [`cat-swapper`](skills/cat-swapper/SKILL.md) | 手动选择猫咪专用工作流 | 可单独安装 |
| [`dog-swapper`](skills/dog-swapper/SKILL.md) | 手动选择狗狗专用工作流 | 可单独安装 |

目标是把基础壁纸里的猫或狗替换成参考照片中的同一只真实宠物，同时尽量保持场景、构图、机位、动作和其他内容。当前支持猫换猫、狗换狗；跨物种替换不在这两套提示词的适用范围内。

## 仓库结构

```text
cat-swapper/
├── README.md
├── LICENSE
└── skills/
    ├── pet-swapper/
    │   ├── SKILL.md
    │   ├── agents/openai.yaml
    │   └── LICENSE
    ├── cat-swapper/
    │   ├── SKILL.md
    │   ├── prompt.txt
    │   ├── agents/openai.yaml
    │   └── LICENSE
    └── dog-swapper/
        ├── SKILL.md
        ├── prompt.txt
        ├── agents/openai.yaml
        └── LICENSE
```

根目录是仓库说明，已不再作为可安装的 Skill。公共入口没有生图提示词，只在当前对话中读取一个专用 Skill；两份 `prompt.txt` 各自只有一个文件真源。

## 分流规则

1. 用户明确选择猫/狗 Skill 或目标物种时，优先遵循该选择。
2. 没有明确选择时，检查基础图和身份参考，猫进入 `cat-swapper`，狗进入 `dog-swapper`。
3. 手动选择与图片冲突、物种或目标不清楚、参考包含不同宠物时，说明具体问题并询问；不擅自切换。
4. 选定后完整读取对应 Skill 和提示词，由该 Skill 执行一次工作流；不启动子 Agent、不拼接两份提示词、不重复生成。

## 输入与执行

图片 1 是唯一基础壁纸；图片 2 起是同一只目标猫或目标狗的原始照片。用户明确指定其他图片职责时遵循该指定。身份参考只提供宠物身份，不提供最终构图与姿势；不要使用生成图、合成壁纸或其他宠物的照片作为身份参考。

运行环境必须支持图片附件和接受全部输入图片的图像生成/编辑工具。本仓库不附带模型、API Key 或付费调用授权。用户要求仅检查或准备提示词时，不调用模型；明确要求生成时，默认一张、零自动重试，不静默切换模型或服务商。

## 安装

先把源码克隆到普通工作目录，例如在自己的项目目录中执行；**不要把整个仓库克隆到 Agent 的 Skills 目录中**：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git
cd cat-swapper
```

下面的 macOS/Linux shell 命令均从这个源码仓库根目录运行。将三个子目录直接复制到同一个 Skills 目录，避免依赖嵌套发现或符号链接：

```bash
(
  set -eu
  swapper_dest="$HOME/.agents/skills"
  mkdir -p "$swapper_dest"
  for name in pet-swapper cat-swapper dog-swapper; do
    if [ -e "$swapper_dest/$name" ] || [ -L "$swapper_dest/$name" ]; then
      echo "已存在 $swapper_dest/$name，请先执行下方迁移步骤。" >&2
      exit 1
    fi
  done
  for name in pet-swapper cat-swapper dog-swapper; do
    cp -R "skills/$name" "$swapper_dest/$name"
  done
)
```

按使用的平台修改 `swapper_dest`：

| 范围 | 目标目录 |
| --- | --- |
| Codex、Gemini CLI、GitHub Copilot CLI 的用户级 Skills | `$HOME/.agents/skills` |
| Claude Code 用户级 Skills | `$HOME/.claude/skills` |
| 项目级共享 Skills | 目标项目的绝对路径下 `.agents/skills` |
| Claude Code 项目级 Skills | 目标项目的绝对路径下 `.claude/skills` |

其他支持 Agent Skills 的平台（如 Cursor）也可使用这三个独立目录，具体安装位置与调用方式以对应平台文档为准。Windows 可手动复制这三个文件夹，保持它们并列。只需要猫或狗时，可只复制对应目录；使用公共入口时必须安装全部三个目录。

安装后确认平台的 Skill 列表包含所需入口。Codex 若未显示，可重启；Gemini CLI 可运行 `/skills reload` 后用 `/skills list` 检查。文件安装与格式兼容不代表各平台的图像工具已完成实测。

## 从旧版迁移与后续更新

旧版根目录猫 Skill 和嵌套狗目录已迁移：

| 原路径 | 新路径 |
| --- | --- |
| `SKILL.md`、`prompt.txt`、`agents/` | `skills/cat-swapper/` 下对应文件 |
| `dog-swapper/` | `skills/dog-swapper/` |
| 无公共入口 | `skills/pet-swapper/` |

旧版直接克隆到 Skills 目录的安装不能只靠 `git pull` 完成迁移。先在 Skills 目录之外取得上述新源码，旧目录尚未迁移前不要覆盖它。后续更新时，在这个独立源码目录运行 `git pull --ff-only`，再执行以下步骤。

从新源码根目录运行以下命令，先检查三个源目录，再将旧安装（包括符号链接）移到 Skills 扫描范围之外备份，最后复制新版本。备份保留本地修改，不会被自动删除：

```bash
(
  set -eu
  swapper_dest="$HOME/.agents/skills"
  for name in pet-swapper cat-swapper dog-swapper; do
    test -f "skills/$name/SKILL.md"
  done
  mkdir -p "$swapper_dest"
  swapper_backup=$(mktemp -d "${swapper_dest%/skills}/pet-swapper-backup.XXXXXX")
  echo "旧版备份：$swapper_backup"
  for name in pet-swapper cat-swapper dog-swapper; do
    if [ -e "$swapper_dest/$name" ] || [ -L "$swapper_dest/$name" ]; then
      mv "$swapper_dest/$name" "$swapper_backup/$name"
    fi
  done
  for name in pet-swapper cat-swapper dog-swapper; do
    cp -R "skills/$name" "$swapper_dest/$name"
  done
)
```

其他安装范围替换同一个 `swapper_dest`，其最后一级目录应为 `skills`。如需回退，先将新安装移出 Skills 目录，再将备份里的旧目录放回原位置；不要把备份放在 Skills 目录里，以免出现重名入口。复制安装不会自动随源码更新，之后仍需执行上述备份与复制步骤。

## 调用示例

在 Codex 中上传基础壁纸及身份参考，然后选择以下任一入口：

```text
使用 $pet-swapper，根据我的基础壁纸和宠物参考照片选择猫或狗工作流，生成一张结果。
```

```text
使用 $cat-swapper。图1是基础猫壁纸，图2起是同一只目标猫的原始照片，生成一张结果。
```

```text
使用 $dog-swapper。图1是基础狗壁纸，图2起是同一只目标狗的原始照片，生成一张结果。
```

Claude Code 可使用 `/pet-swapper`、`/cat-swapper`、`/dog-swapper`；其他平台使用其 Skill 选择器或直接描述任务。明确选猫或狗可直接进入专用 Skill，无需先调用公共入口。

## 手动使用提示词与完整性

无需安装 Skill 也可上传基础壁纸及同一只宠物的原始参考照片，再把对应提示词完整粘贴给支持多图输入的图像工具。明确要求只生成一张、失败后不自动重试。

| 提示词 | SHA-256 |
| --- | --- |
| [猫咪](skills/cat-swapper/prompt.txt) | `43e3919a1aa03b9c6b8d33451277c65837a78b0bfd6f5df695b8826cf34f1e55` |
| [狗狗](skills/dog-swapper/prompt.txt) | `62a979a88391e7fb2d5a6066231eef9bc53a627d746c7fd3a2fb2acac109235f` |

```bash
shasum -a 256 skills/cat-swapper/prompt.txt skills/dog-swapper/prompt.txt
```

本次目录调整保留两份提示词的全部字节。狗版尚未经过真实图片模型与主人身份判断；Skill 结构和分流规则不证明跨宠物稳定或效果已验收。生成模型也不保证非目标区域像素级保持。

## 平台格式依据

- [Agent Skills Specification](https://agentskills.io/specification)
- [OpenAI Codex Skills](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code Skills](https://code.claude.com/docs/en/slash-commands)
- [Cursor Agent Skills](https://cursor.com/docs/skills)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
- [GitHub Copilot Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

## License

[MIT](LICENSE)。每个可安装 Skill 目录也包含相同许可，便于单独分发。
