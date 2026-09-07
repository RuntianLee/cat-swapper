# Cat Swapper

**English** | [中文](README.zh-CN.md)

**Replace one or more pets in an existing wallpaper with the pets from their original reference photos, while keeping the scene, composition, pose, and non-pet content as stable as the workflow allows.**

Cat Swapper is an open [Agent Skills](https://agentskills.io/specification) package with separate cat, dog, and routing entries.

> **Important:** this repository contains workflows and prompts, not an image model, API key, or paid-call authorization. Installing a Skill never authorizes image generation.

## What it includes

| Skill | Use it for |
| --- | --- |
| [`pet-swapper`](skills/pet-swapper/SKILL.md) | Route an unclear request to the cat or dog workflow. Install all three Skills when using this entry. |
| [`cat-swapper`](skills/cat-swapper/SKILL.md) | Replace one cat, generate multiple cats at once, or build a multi-cat wallpaper with local layers. |
| [`dog-swapper`](skills/dog-swapper/SKILL.md) | Replace one dog with one target dog. |

Explicit cat or dog selection takes priority. Mixed-species and cross-species replacement are out of scope.

## Multi-cat workflows

| Mode | Best for | Method |
| --- | --- | --- |
| [Layered multi-cat](skills/cat-swapper/references/layered-multi-cat.md) | Separable cat positions; identity isolation and background preservation matter most | Generate a cat-free base, generate each cat as a local crop, remove each crop's background locally, then composite by fixed coordinates. Reuses the single-cat prompt. |
| [One-shot multi-cat](skills/cat-swapper/references/multi-cat.md) | Cats touch, overlap, share shadows or props, or must be generated in one request | Map every base-image cat position to one reference group and use the dedicated multi-cat prompt. |

The layered workflow is preferred when its geometry fits. The one-shot prompt remains necessary for interactions that cannot be separated into independent alpha layers.

## Install

Install all three entries with the Skills CLI:

```bash
npx -y skills add RuntianLee/cat-swapper -g --all
```

For a manual installation, copy the required folders from `skills/` into your platform's Skill directory as peer folders. Install only `cat-swapper` or `dog-swapper` for direct specialist use; install all three when using `pet-swapper`.

## Usage

```text
Use $pet-swapper to choose the correct cat or dog workflow for my base image and original pet photos.
```

```text
Use $cat-swapper. Image 1 is the base cat wallpaper; the remaining images are original photos of the target cat. Generate one result.
```

```text
Use $cat-swapper's layered multi-cat workflow. First prepare a zero-call preflight and freeze the canvas, cat positions, reference groups, request cap, and cost cap. Do not call an image API without my confirmation.
```

```text
Use $dog-swapper. Image 1 is the base dog wallpaper; the remaining images are original photos of the target dog. Generate one result.
```

## Inputs and guardrails

- Image 1 is the only base image and supplies the scene, composition, pose, expression, camera, and spatial relationships.
- Identity references must be original photos of one clearly assigned target pet. Generated images and composites are not identity references.
- Multi-cat references must be split into non-overlapping groups with a one-to-one position mapping.
- Each external model call needs current authorization. The default is one output and zero automatic retries; do not silently add calls, change models, or raise cost.
- Technical QC, owner identity judgment, and overall visual acceptance are recorded separately.
- Text prompts cannot guarantee pixel-identical non-pet regions. Use the layered workflow and verify pixels outside the combined alpha when that requirement is strict.

## Verify

```bash
./scripts/check.sh
```

The check validates required files, mode references, bilingual README links, and prompt hashes.

| Prompt | SHA-256 |
| --- | --- |
| [Single cat / layered cat](skills/cat-swapper/prompt.txt) | `c4a5bc29660791242df2c49fbda6576208baaaea00e94fca12fd4efc008dbe96` |
| [One-shot multi-cat](skills/cat-swapper/prompt-multi.txt) | `23bb0b2a20d751a8eb83a414247cf2be1b6dc92aa2fc7ef625c902b33751c554` |
| [Single dog](skills/dog-swapper/prompt.txt) | `a354867f9b97a48dc7f3457204b6d672e3b62bd80f6f528482ef71ffd79f3fb6` |

## Limits

- One separable seven-cat layered case received overall owner acceptance and passed composition-integrity checks, but strict pose/expression QC did not fully pass. It does not prove cross-wallpaper reliability or lossless fur matting.
- The one-shot multi-cat prompt has not produced an accepted final result in that case.
- The dog workflow has not completed a real-model, owner-identity validation.
- Private photos, run ledgers, authorization records, masks, and generated results are not included in this public repository.

## License

MIT — see [LICENSE](LICENSE).
