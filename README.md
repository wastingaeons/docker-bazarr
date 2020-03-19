# Bazarr with sc0ty's subsync

[linuxserver/bazarr](https://hub.docker.com/r/linuxserver/bazarr) (latest) with [subsync](https://github.com/sc0ty/subsync) - useful as a Bazarr post-processing command to make sure your subtitles are always synced.

## Usage

1. Setup container according to [linuxserver/bazarr](https://hub.docker.com/r/linuxserver/bazarr) - changing image to `janpfo/bazarr_subsync_sc0ty`
2. Put `subsync --cli --logfile /config/subsync_1.log sync --sub-lang '{{subtitles_language_code3}}' --sub '{{subtitles}}' --ref '{{episode}}' --out '{{subtitles}}' --overwrite` in Bazarr post-processing command setting
