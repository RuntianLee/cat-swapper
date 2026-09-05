---
name: pet-swapper
description: Choose the cat or dog wallpaper replacement workflow when the user asks to replace a pet in an existing image without selecting a species-specific skill, or explicitly requests Pet Swapper. Respect a direct cat-swapper or dog-swapper selection.
license: MIT
metadata:
  author: RuntianLee
  version: "0.2.0"
---

# Pet Swapper

Route the request to exactly one species-specific skill in this same conversation. This entry has no image prompt and does not generate images itself or spawn another agent.

## Select the workflow

1. Honor an explicit `cat-swapper` or `dog-swapper` selection. If the user instead states a target species, use that choice. If explicit choices conflict with each other or with the supplied images, explain the conflict and ask which choice or input to correct; do not silently switch.
2. Otherwise inspect the supplied base image and identity references to identify the species. The first image is the base and later images are identity references unless the user assigns other roles. Route cats to Cat Swapper and dogs to Dog Swapper.
3. If the species, target subject, or image roles remain ambiguous, or references mix different animals, ask only for the missing decision. Cat-to-dog, dog-to-cat, and other-species replacement are outside these workflows; explain the unsupported case without starting generation.

## Continue with the selected skill

- Cat: read [Cat Swapper](../cat-swapper/SKILL.md) completely.
- Dog: read [Dog Swapper](../dog-swapper/SKILL.md) completely.

Resolve these paths relative to this `SKILL.md`, not the working directory. All three skill folders must be installed as siblings for this entry to work. If a selected sibling is missing, report the exact missing path and request installation; do not invent or substitute a prompt.

Follow the selected skill in this same local sibling set, preserving the user's attachments, image roles, chosen provider, request limits, and existing authorization. Do not ask the user to repeat an already clear choice or authorization. The specialist must inspect the current base and compose its per-image expression paragraph followed by the complete unchanged `prompt.txt`. Do not reuse another wallpaper's expression paragraph, concatenate cat and dog prompts, or add this routing text to the image instruction. Do not silently use an installed specialist from a different version.

Selecting a workflow does not authorize image generation. If the user requested only inspection or prompt preparation, complete that work without calling an image tool. The selected skill owns the image call and result handling; do not generate a second result from this entry.
