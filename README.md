# nix-tabletop — archived

**Superseded by [anicolao/tabletop-os](https://github.com/anicolao/tabletop-os),
which is the authoritative source of tabletop images.**

This repository is archived and read-only. Nothing here builds.

## What this was

A first attempt (September 2025) at a NixOS browser kiosk for a Raspberry Pi 4
tabletop. It was hand-written and structurally on the right track — it used real
`nixos-hardware` APIs and drove Chromium under `services.cage` on Wayland, which
is still the approach `tabletop-os` takes.

It never built. Two reasons, both worth recording:

- `flake.lock` only ever contained `nixpkgs`, despite `flake.nix` declaring
  `nixos-hardware` as an input — the lock was never regenerated after that input
  was added.
- The final five commits on `feat/rpi4-gpu-acceleration` are escalating attempts
  to force a `dw-hdmi` kernel module via `boot.kernelPatches`. That discards the
  binary cache and forces a from-source aarch64 kernel build, which was
  unfinishable on the builder available at the time (1 vCPU, 3 GiB RAM). The
  missing module was a symptom of the `fkms-3d` display path, not something to
  patch around.

## What replaced it

`tabletop-os` targets the **Orange Pi 5 Plus** (RK3588, Mali-G610) as primary,
with Raspberry Pi 5 and 4 planned, and is built around the observation that
those boards share everything above the DRM device and nothing below it.

It also carries the lessons from here: never use `boot.kernelPatches` on these
targets, and fix the builder before blaming the configuration.
