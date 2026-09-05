---
name: cat-swapper
description: Replace the cat in an existing wallpaper or image with the same real cat shown in one or more identity reference photos while preserving the base scene, composition, pose, camera, and non-cat content. Use when the user asks to swap or replace a cat in an image or make a wallpaper feature their cat.
license: MIT
metadata:
  author: RuntianLee
  version: "0.3.0"
---

# Cat Swapper

Use the canonical instructions in `prompt.txt` to replace the cat in a base image with the cat identified by the user's reference photos.

## Required inputs

- Exactly one base wallpaper or base image containing the source cat to replace.
- One or more original photos of the same target cat.
- An explicit request from the user to generate or edit the image.

Treat the first image as the base image and every later image as an identity reference unless the user explicitly assigns different roles.

## Workflow

1. Resolve attachment roles only when they are ambiguous. If the order is already clear, do not add an unnecessary confirmation step.
2. Verify that the current platform exposes an image-generation or image-editing tool that can accept the base image plus all identity references. If it does not, explain the missing capability; the user can manually provide the images and this directory's complete `prompt.txt` to a suitable image tool.
3. Read `prompt.txt` completely from this skill directory. Do not shorten, translate, rewrite, summarize, or append cat-specific facts to it.
4. Give the platform's native image tool the attachments in this order: base image first, then all identity-reference photos. Send the complete, unchanged contents of `prompt.txt` as the image instruction.
5. Request exactly one result unless the user explicitly requests more. Do not retry automatically and do not switch models, providers, or tools silently.
6. Return or display the saved result. Report any surfaced model/tool name and any visible format or dimension drift. Wait for the user before retrying a failed or rejected result.

## Boundaries

- This skill contains instructions only. It does not supply an image model, API key, paid-call authorization, or provider configuration.
- Skill activation, attachment inspection, or prompt preparation is not authorization to make a paid model call.
- Do not use a generated image, wallpaper composite, or an image containing a different cat as an identity reference.
- This workflow is for cat-to-cat identity replacement. If the base subject or identity references are another species, explain the conflict and ask for clarification; do not silently switch skills or attempt cross-species replacement.
- If the base image is unclear, the references contain different cats, or the user has not requested generation, stop and ask for the missing decision.
- Preserve privacy and usage rights for every supplied image.
- The prompt asks for strict preservation, but exact pixel-level preservation of non-cat regions is not guaranteed by generative models.
