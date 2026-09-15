# Cat Swapper

**English** | [中文](README.zh-CN.md)

![Two origami paper characters introduce MBTI personality co-creation](skills/mbti-origami-pet/assets/origami-cat-dog-style-reference.png)

**Co-create an origami cat or dog alter ego from your MBTI and personal history, or replace pets in an existing wallpaper with real pets from original photos.**

Cat Swapper is an open [Agent Skills](https://agentskills.io/specification) package. Its featured experience is personality-led origami character co-creation; three sibling Skills cover real-pet image replacement.

> **Important:** this repository contains workflows, prompts, and one style-reference asset, not an image model, API key, or paid-call authorization. Installing a Skill never authorizes image generation.

## Featured Skill: `mbti-origami-pet`

[`mbti-origami-pet`](skills/mbti-origami-pet/SKILL.md) turns a person's MBTI and authorized, accessible personal history into an origami cat or dog that feels like another version of them.

It asks one question at a time, recalls two or three traceable moments in a warm “memory time machine” voice, recommends three visually distinct breeds, and presents two role scenes whose headings reveal the whole idea at a glance. Scene names use a concrete setting, visible action, and real-world aspirational occupation; they never claim that occupation is part of the user's actual work history.

After the user chooses a proposal, the Skill generates one image with zero automatic retries. Technical quality, visual preference, and “does this feel like me?” remain separate judgments.

Install only the featured Skill:

```bash
npx -y skills add RuntianLee/cat-swapper -g --skill mbti-origami-pet -y
```

Use it:

```text
Use $mbti-origami-pet to co-create an origami cat or dog alter ego from my MBTI and the personal history available in this conversation.
```

The included [style reference](skills/mbti-origami-pet/assets/README.md) defines the large folded planes, separate paper components, matte fibers, and miniature paper set. Its text, layout, colors, accessories, poses, and exact composition are not templates.

## Real-pet replacement Skills

### `cat-swapper`

[`cat-swapper`](skills/cat-swapper/SKILL.md) replaces one cat, generates several mapped cats in one request, or builds a multi-cat wallpaper with a cat-free base and local layers. It uses original photos as identity evidence and keeps technical QC, owner identity judgment, and overall visual acceptance separate.

```bash
npx -y skills add RuntianLee/cat-swapper -g --skill cat-swapper -y
```

```text
Use $cat-swapper. Image 1 is the base cat wallpaper; the remaining images are original photos of the target cat. Generate one result.
```

### `dog-swapper`

[`dog-swapper`](skills/dog-swapper/SKILL.md) replaces one dog in an existing image with the same target dog from one or more original reference photos while preserving the base scene, composition, pose, camera, and non-dog content as far as the workflow allows.

```bash
npx -y skills add RuntianLee/cat-swapper -g --skill dog-swapper -y
```

```text
Use $dog-swapper. Image 1 is the base dog wallpaper; the remaining images are original photos of the target dog. Generate one result.
```

### `pet-swapper`

[`pet-swapper`](skills/pet-swapper/SKILL.md) is the routing entry for a pet-replacement request that has not selected cats or dogs. It delegates to `cat-swapper` or `dog-swapper`, so install all three replacement Skills together:

```bash
npx -y skills add RuntianLee/cat-swapper -g --skill pet-swapper cat-swapper dog-swapper -y
```

```text
Use $pet-swapper to choose the correct cat or dog workflow for my base image and original pet photos.
```

Explicit cat or dog selection takes priority. Mixed-species and cross-species replacement are out of scope.

## Install everything

Install all four Skills:

```bash
npx -y skills add RuntianLee/cat-swapper -g --all
```

For a manual installation, copy the required folders from `skills/` into your platform's Skill directory as peer folders.

## Multi-cat workflows

| Mode | Best for | Method |
| --- | --- | --- |
| [Layered multi-cat](skills/cat-swapper/references/layered-multi-cat.md) | Separable cat positions; identity isolation and background preservation matter most | Generate a cat-free base, generate each cat as a local crop, remove each crop's background locally, then composite by fixed coordinates. Reuses the single-cat prompt. |
| [One-shot multi-cat](skills/cat-swapper/references/multi-cat.md) | Cats touch, overlap, share shadows or props, or must be generated in one request | Map every base-image cat position to one reference group and use the dedicated multi-cat prompt. |

The layered workflow is preferred when its geometry fits. The one-shot prompt remains necessary for interactions that cannot be separated into independent alpha layers.

```text
Use $cat-swapper's layered multi-cat workflow. First prepare a zero-call preflight and freeze the canvas, cat positions, reference groups, request cap, and cost cap. Do not call an image API without my confirmation.
```

## Inputs and guardrails

- Image 1 is the only base image for replacement workflows and supplies the scene, composition, pose, expression, camera, and spatial relationships.
- Identity references must be original photos of one clearly assigned target pet. Generated images and composites are not identity references.
- Multi-cat references must be split into non-overlapping groups with a one-to-one position mapping.
- Each external model call needs current authorization. The default is one output and zero automatic retries; do not silently add calls, change models, or raise cost.
- Technical QC, owner identity judgment, and overall visual acceptance are recorded separately.
- MBTI co-creation uses only authorized, accessible history and memory, never claims complete account coverage, and keeps technical QC, preference, and self-recognition separate.
- Text prompts cannot guarantee pixel-identical non-pet regions. Use the layered workflow and verify pixels outside the combined alpha when that requirement is strict.

## Verify

```bash
./scripts/check.sh
```

The check validates required files, mode references, bilingual README links, prompt hashes, and the style-reference hash.

| Prompt | SHA-256 |
| --- | --- |
| [Single cat / layered cat](skills/cat-swapper/prompt.txt) | `c4a5bc29660791242df2c49fbda6576208baaaea00e94fca12fd4efc008dbe96` |
| [One-shot multi-cat](skills/cat-swapper/prompt-multi.txt) | `23bb0b2a20d751a8eb83a414247cf2be1b6dc92aa2fc7ef625c902b33751c554` |
| [Single dog](skills/dog-swapper/prompt.txt) | `a354867f9b97a48dc7f3457204b6d672e3b62bd80f6f528482ef71ffd79f3fb6` |

## Limits

- One separable seven-cat layered case received overall owner acceptance and passed composition-integrity checks, but strict pose/expression QC did not fully pass. It does not prove cross-wallpaper reliability or lossless fur matting.
- The one-shot multi-cat prompt has not produced an accepted final result in that case.
- The dog workflow has not completed a real-model, owner-identity validation.
- The MBTI origami workflow has repeated single-user interaction evidence, but no cross-user or cross-model validation.
- Private photos, run ledgers, authorization records, masks, and generated results are not included in this public repository.

## License

Code and text are MIT licensed — see [LICENSE](LICENSE). The origami [style-reference image](skills/mbti-origami-pet/assets/README.md) remains the property of its original rights holder and is not relicensed under MIT.
