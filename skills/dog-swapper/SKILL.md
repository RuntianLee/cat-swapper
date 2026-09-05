---
name: dog-swapper
description: Replace the dog in an existing wallpaper or image with the same real dog shown in one or more identity reference photos while preserving the base scene, composition, pose, camera, and non-dog content. Use when the user asks to swap or replace a dog in an image or make an existing dog wallpaper feature their dog.
license: MIT
metadata:
  author: RuntianLee
  version: "0.4.0"
---

# Dog Swapper

Use the canonical instructions in `prompt.txt` to replace the dog in a base image with the dog identified by the user's reference photos.

## Required inputs

- Exactly one base wallpaper or base image containing the source dog to replace.
- One or more original photos of the same target dog.
- An explicit request to generate/edit, or a preparation-only request. Only generation requires image-call authorization.

Treat the first image as the base image and every later image as an identity reference unless the user explicitly assigns different roles.

## Workflow

1. Resolve attachment roles only when they are ambiguous. If the order is already clear, do not add an unnecessary confirmation step.
2. Read this directory's complete `prompt.txt` and visually inspect the resolved base image and original identity references. Distinguish the base's temporary expression from the target's stable facial anatomy; do not treat fur volume, perspective or an identity photo's temporary expression as head shape. Do not change the generic prompt file. If a required image cannot be inspected, request the missing image/capability rather than inventing features. Preparation alone does not require an image-generation tool.
3. 根据输入的壁纸图片中的宠物表情，重新生成本次宠物表情描述。不得沿用其他壁纸的具体描述，也不得只把这句改写指令交给生图模型。 Follow “Per-image expression” below to produce the actual description before the image call.
4. Compose the image instruction as the resolved per-image expression paragraph, a blank line, then the complete unchanged bytes of `prompt.txt`. Keep observations and the final instruction in the current job directory when local files are available; never overwrite the installed template or an earlier job. Check that the generic suffix is unchanged and the paragraph agrees with the current base. For preparation-only requests, return this instruction and stop without an image call.
5. Before generation, verify that the chosen tool accepts every input and that the user's current authorization covers the model/provider, request count and any paid cost. Preserve already-clear choices; an exhausted prior authorization cannot be reused. Send the base first, followed by all original identity references in their resolved order. Request one result unless explicitly authorized otherwise; zero automatic retries and no silent tool/provider substitution. If capability or authorization is missing, return the prepared instruction and explain the blocker.
6. Return or display the saved result and report surfaced model/tool and dimensions. Check expression against the base and prepared paragraph, and facial identity against the original identity references, allowing for the base's viewing angle and expression. Record these as separate checks: a matching expression cannot compensate for a face-shape mismatch, and likeness cannot compensate for an expression mismatch. Keep technical findings separate from owner judgment; do not mark overall success when either check fails or cannot be assessed. Prompt-level “failure” is not an API rejection guarantee; do not conceal an imperfect result, retry or repair it without new authorization.

## Per-image expression

- Describe only clearly visible features of the base subject: eyelid position and eye aperture, gaze, mouth/tongue state, and temporary ear posture where distinguishable from ear anatomy. Usually 2–4 salient observations suffice; do not invent features to fill a quota or give unsupported numeric ratios.
- Write a short, resolved paragraph headed “本次基础图的表情要求”. Use concrete visible structure first; emotional labels are optional interpretations, never substitutes for structure. Open eyes, closed eyes, half-lidded eyes and an open mouth must follow the actual image, not a default cute, calm or impatient expression.
- For occluded or unclear features, state that they cannot be determined and preserve the occlusion; do not infer them from identity photos or expose them to make checking easier. If no expression features are readable, describe only that limitation, not a guessed mood.
- The generated paragraph must explicitly state that the base supplies expression state, not facial geometry. Face contour, head width-to-length proportions, cheek/jowl fullness, jaw/chin and muzzle length/width must come from the target's original identity references, together with stable eye shape/color and natural ear anatomy. Describe target-specific facial features only when supported by clear references; if unclear, flag that limit rather than filling it from the base pet or a breed template.
- 表情迁移只调整当前可见的眼睑开合、视线、嘴巴／舌头状态及可辨认的临时耳位；不得为匹配表情而套用原宠物整张脸的轮廓、拉宽／压扁头脸、扩大腮部或缩短口鼻。把这条边界明确写进当次发送给模型的表情段，而不只留在作业说明中。张嘴等表情造成的自然局部软组织变化与下颌运动可以保留，但不能改变目标宠物稳定的头脸结构；头部方向、透视、主体占位和遮挡仍服从基础图。Do not force one ear type into another. If the expression requires violating target anatomy, flag the conflict before generation rather than sacrificing either constraint.
- 本段只描述当次可见表情及其与目标宠物身份结构的边界。 Do not import base-pet identity, identity-photo expressions, pet names, scene changes or new style/size instructions. The complete generic scene, pose, anatomy and identity constraints still apply.

## Boundaries

- This skill contains instructions only. It does not supply an image model, API key, paid-call authorization, or provider configuration.
- Skill activation, attachment inspection, or prompt preparation is not authorization to make a paid model call.
- Do not use a generated image, wallpaper composite, or an image containing a different dog as an identity reference.
- This workflow is for dog-to-dog identity replacement. If the base subject or identity references are another species, explain the conflict and ask for clarification; do not silently switch skills or attempt cross-species replacement.
- If the target subject or input roles are unclear, or references contain different dogs, stop and ask for the missing decision. An unreadable expression feature alone is handled by the uncertainty rule above. If generation was not requested, complete preparation only.
- Preserve privacy and usage rights for every supplied image.
- The prompt asks for strict preservation, but exact pixel-level preservation of non-dog regions is not guaranteed by generative models.
