# Cat Swapper

基于开放 [Agent Skills](https://agentskills.io/specification) 格式的宠物壁纸身份替换工具。仓库名称保留为 `cat-swapper`，提供三个并列入口：

| 入口 | 用途 | 安装要求 |
| --- | --- | --- |
| [`pet-swapper`](skills/pet-swapper/SKILL.md) | 公共入口，根据用户选择或图片物种进入猫/狗 Skill | 三个 Skill 并列安装 |
| [`cat-swapper`](skills/cat-swapper/SKILL.md) | 手动选择猫咪专用工作流 | 可单独安装 |
| [`dog-swapper`](skills/dog-swapper/SKILL.md) | 手动选择狗狗专用工作流 | 可单独安装 |

目标是把基础壁纸里的猫或狗替换成参考照片中的真实宠物，同时尽量保持场景、构图、机位、动作和其他内容。猫咪流程支持单猫替换，以及多只基础猫与多组目标猫之间的一对一替换；狗狗流程当前只支持单狗替换。跨物种替换不在这两套流程的适用范围内。

## 仓库结构

```text
cat-swapper/
├── README.md
├── LICENSE
├── scripts/check.sh
└── skills/
    ├── pet-swapper/
    │   ├── SKILL.md
    │   ├── agents/openai.yaml
    │   └── LICENSE
    ├── cat-swapper/
    │   ├── SKILL.md
    │   ├── prompt.txt
    │   ├── prompt-multi.txt
    │   ├── references/
    │   │   ├── single-cat.md
    │   │   └── multi-cat.md
    │   ├── agents/openai.yaml
    │   └── LICENSE
    └── dog-swapper/
        ├── SKILL.md
        ├── prompt.txt
        ├── agents/openai.yaml
        └── LICENSE
```

根目录是仓库说明，已不再作为可安装的 Skill。公共入口没有生图提示词，只在当前对话中读取一个专用 Skill；猫咪单猫、多猫和狗狗提示词各自只有一个文件真源。

## 分流规则

1. 用户明确选择猫/狗 Skill 或目标物种时，优先遵循该选择。
2. 没有明确选择时，检查基础图和身份参考，猫进入 `cat-swapper`，狗进入 `dog-swapper`。
3. 基础图中有多只猫、且每只目标猫的参考组和猫位映射明确时，仍进入 `cat-swapper` 的多猫模式；不同目标猫的参考照片不构成物种冲突。
4. 手动选择与图片冲突、物种或目标不清楚、参考混有不同物种，或多猫身份分组／映射不清楚时，说明具体问题并询问；不擅自切换。
5. 选定后完整读取对应 Skill，并按模式读取恰好一份提示词，由该 Skill 执行一次工作流；不启动子智能体、不拼接提示词、不重复生成。

## 输入与执行

图片 1 是唯一基础壁纸，也是最终姿势与表情的来源。单猫／单狗模式中，图片 2 起是同一只目标宠物的原始照片。多猫模式中，图片 2 起按目标猫分成连续且互不重叠的身份组，每个基础猫位与一个身份组一对一绑定。用户明确指定其他图片职责时遵循该指定。身份参考只提供稳定身份，不提供最终构图、姿势与表情；不要使用生成图或合成壁纸作为身份参考。

准备提示词需要能查看基础图和身份参考；实际生成还需要接受全部输入图片的图像生成／编辑工具。本仓库不附带模型、API 密钥或付费调用授权。多猫输入超过工具上限时必须停止，不静默删图、合并身份组或拆分请求。用户要求仅检查或准备提示词时，不调用模型；明确要求生成时，默认一张、零自动重试，不静默切换模型或服务商。

## 动态表情与身份边界（猫 v0.5.0、狗 v0.4.1、公共入口 v0.3.0）

猫咪 Skill 会先根据图 1 中待替换猫的数量选择模式。恰好一只时只读取原有单猫流程和 `prompt.txt`，不加载多猫规则；两只或更多时只读取多猫流程和 `prompt-multi.txt`，先建立完整猫位／身份组映射。单猫提示词保持字节不变。

单猫和单狗继续使用原有 6 步流程，身份特征仍按各自物种的提示词处理：

1. 确认基础图和身份参考的职责；顺序清楚时不重复询问。
2. 阅读完整通用提示词并查看当前图片，分清基础图的临时表情与目标宠物稳定的脸型。
3. 根据当前基础图，写出具体可见的眼睑、视线、嘴巴等表情状态；同时写清脸型来自目标原照，不继承基础图宠物的脸部轮廓。不套用上一张壁纸或上一只宠物的描述，不臆测遮挡部位。
4. 将当次描述、一个空行和完整不变的 `prompt.txt` 组合为最终提示词。可保存当次观察及提示词，不覆盖旧作业；仅准备时到此停止。
5. 核对当前授权、模型、费用和请求次数，再按基础图在前、原始身份参考在后的顺序生成。已用完的授权不能复用；默认一张、零自动重试，不擅自换模型。
6. 展示结果并报告模型与尺寸：表情对照基础图，脸型与身份对照目标原照，分别记录检查结果及主人判断；任何一项失败或无法判断，不标记为整体成功，不自动修复。

“本次基础图的表情要求”描述单只宠物的当次可见表情及其与目标身份结构的边界。睁眼、闭眼、半眯或张嘴都按当前图片决定，不统一套用半眯、可爱或不耐烦的描述；允许表情造成的自然局部变化，不改变稳定的头脸结构。

多猫模式改用“本次基础图的多猫映射与表情要求”。每个猫位区块必须包含稳定定位、目标猫参考图片编号和独立表情描述；参考组之间不得混合、交换或补齐特征。生成后逐猫检查身份、表情和动作，再检查猫的总数、猫际关系和非猫内容。

“表情不匹配即失败”是验收要求，不是模型服务的程序级拦截，也不会触发自动重试。多猫文本支持也不证明模型能够稳定接受任意数量的图片或保持多个身份，生成后仍需检查实际结果。

## 安装

可通过 Skills CLI 命令行工具安装三个同级入口（运行命令前确认信任本仓库）：

```bash
npx -y skills add RuntianLee/cat-swapper -g --all
```

也可以手动安装。先把源码克隆到普通工作目录，例如在自己的项目目录中执行；**不要把整个仓库克隆到智能体的 Skill 安装目录中**：

```bash
git clone https://github.com/RuntianLee/cat-swapper.git
cd cat-swapper
```

下面的 macOS／Linux 终端命令均从这个源码仓库根目录运行。将三个子目录直接复制到同一个 Skill 安装目录，避免依赖嵌套发现或符号链接：

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
| Codex、Gemini CLI、GitHub Copilot CLI 的用户级 Skill 目录 | `$HOME/.agents/skills` |
| Claude Code 用户级 Skill 目录 | `$HOME/.claude/skills` |
| 项目级共享 Skill 目录 | 目标项目的绝对路径下 `.agents/skills` |
| Claude Code 项目级 Skill 目录 | 目标项目的绝对路径下 `.claude/skills` |

其他支持 Agent Skills 的平台（如 Cursor）也可使用这三个独立目录，具体安装位置与调用方式以对应平台文档为准。Windows 可手动复制这三个文件夹，保持它们并列。只需要猫或狗时，可只复制对应目录；使用公共入口时必须安装全部三个目录。

安装后确认平台的 Skill 列表包含所需入口。Codex 若未显示，可重启；Gemini CLI 可运行 `/skills reload` 后用 `/skills list` 检查。文件安装与格式兼容不代表各平台的图像工具已完成实测。

## 从旧版迁移与后续更新

旧版根目录猫 Skill 和嵌套狗目录已迁移：

| 原路径 | 新路径 |
| --- | --- |
| `SKILL.md`、`prompt.txt`、`agents/` | `skills/cat-swapper/` 下对应文件 |
| `dog-swapper/` | `skills/dog-swapper/` |
| 无公共入口 | `skills/pet-swapper/` |

旧版直接克隆到 Skill 安装目录的安装不能只靠 `git pull` 完成迁移。先在 Skill 安装目录之外取得上述新源码，旧目录尚未迁移前不要覆盖它。后续更新时，在这个独立源码目录运行 `git pull --ff-only`，再执行以下步骤。

从新源码根目录运行以下命令，先检查三个源目录，再将旧安装（包括符号链接）移到 Skill 扫描范围之外备份，最后复制新版本。备份保留本地修改，不会被自动删除：

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

其他安装范围替换同一个 `swapper_dest`，其最后一级目录应为 `skills`。如需回退，先将新安装移出 Skill 安装目录，再将备份里的旧目录放回原位置；不要把备份放在 Skill 安装目录里，以免出现重名入口。复制安装不会自动随源码更新，之后仍需执行上述备份与复制步骤。

## 调用示例

在 Codex 中上传基础壁纸及身份参考，然后选择以下任一入口：

```text
使用 $pet-swapper，根据我的基础壁纸和宠物参考照片选择猫或狗工作流，生成一张结果。
```

```text
使用 $cat-swapper。图1是基础猫壁纸，图2起是同一只目标猫的原始照片，生成一张结果。
```

```text
使用 $cat-swapper。图1有7只待替换的猫；按图1猫位A到G，将图2-3、图4-5、图6-7、图8-9、图10-11、图12-13、图14-15分别作为目标猫A到G的身份参考组，生成一张结果。
```

```text
使用 $dog-swapper。图1是基础狗壁纸，图2起是同一只目标狗的原始照片，生成一张结果。
```

Claude Code 可使用 `/pet-swapper`、`/cat-swapper`、`/dog-swapper`；其他平台使用其 Skill 选择器或直接描述任务。明确选猫或狗可直接进入专用 Skill，无需先调用公共入口。

## 手动使用提示词与完整性

无需安装 Skill 也可上传基础壁纸及原始身份参考照片，再把对应提示词完整粘贴给支持多图输入的图像工具。单猫／单狗模式只使用对应 `prompt.txt`；多猫模式必须先写清猫位、参考图片分组及一对一映射，再接上完整 `prompt-multi.txt`。明确要求只生成一张、失败后不自动重试。

只粘贴任一提示词文件都不包含上述读图与当次描述步骤。需要动态表情流程时，先按对应 `SKILL.md` 和模式引用文件准备当次描述，再接上完整通用提示词。

| 提示词 | SHA-256 |
| --- | --- |
| [猫咪单猫](skills/cat-swapper/prompt.txt) | `c4a5bc29660791242df2c49fbda6576208baaaea00e94fca12fd4efc008dbe96` |
| [猫咪多猫](skills/cat-swapper/prompt-multi.txt) | `23bb0b2a20d751a8eb83a414247cf2be1b6dc92aa2fc7ef625c902b33751c554` |
| [狗狗](skills/dog-swapper/prompt.txt) | `a354867f9b97a48dc7f3457204b6d672e3b62bd80f6f528482ef71ffd79f3fb6` |

从仓库根目录运行内置检查，可以同时核对模式引用、必需文件和 README 中的哈希：

```bash
./scripts/check.sh
```

```bash
shasum -a 256 skills/cat-swapper/prompt.txt skills/cat-swapper/prompt-multi.txt skills/dog-swapper/prompt.txt
```

猫咪单猫动态描述在同一基础壁纸、两只目标猫分别进行的有限测试中获得正向反馈，也出现过表情接近但脸型失真的情况；加入脸型边界后的单次结果获得用户接受。这些测试不是一张图中同时替换多只猫。多猫模式尚未经过真实图片模型和逐猫主人身份判断，不得宣称七猫或其他数量已验证。狗版同样尚未经过真实图片模型与主人身份判断；文本规则一致不代表生成效果一致。生成模型也不保证非目标区域像素级保持。

公开仓库只分发通用规则、提示词、安装说明和许可；私人照片、当次专有描述、授权账目、状态记录和测试资料不随本次更新发布。

## 平台格式依据

- [Agent Skills 格式规范](https://agentskills.io/specification)
- [OpenAI Codex 技能文档](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code 技能文档](https://code.claude.com/docs/en/slash-commands)
- [Cursor 技能文档](https://cursor.com/docs/skills)
- [Gemini CLI 技能文档](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
- [GitHub Copilot 技能文档](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)

## 许可证

[MIT](LICENSE)。每个可安装 Skill 目录也包含相同许可，便于单独分发。
