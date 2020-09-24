# Bazarr with sc0ty's subsync

[hotio/bazarr](https://hub.docker.com/r/hotio/bazarr) (latest dev branch) with [subsync](https://github.com/sc0ty/subsync) - synchronize your subtitles when downloaded.

## Usage
Place subsync command into Bazarr's Post-Processing field. An example:
`subsync --cli sync --sub-lang "{{subtitles_language_code3}}" --sub "{{subtitles}}" --ref "{{episode}}" --out "{{subtitles}}" --overwrite` 

## Available SubSync options
Sync command
Specify single synchronization task. Several tasks could be specified in single subsync invocation.

Usage: subsync [OPTIONS] sync [TASK OPTIONS] sync [TASK2 OPTIONS] ...

Where [TASK OPTIONS] are:

* --sub PATH, --sub-file PATH / --ref PATH, --ref-file PATH - path to sub/ref file;
* --sub-stream NO / --ref-stream NO - stream number (optional);
* --sub-stream-by-lang LANG / --ref-stream-by-lang LANG - select stream by 3-letter language code (optional);
* --ref-stream-by-type TYPE - select stream by type (sub or audio);
* --sub-lang LANG / --ref-lang LANG - language 3-letter code defined by ISO 639-3 (optional);
* --sub-enc ENC / --ref-enc ENC - character encoding (optional);
* --sub-fps FPS / --ref-fps FPS- framerate (optional);
* --ref-channels CHANNELS - ref audio channels to listen to (optional). Could be specified as comma separated channel codes, auto or all (default).
* --out OUT, --out-file OUT - output file path (optional in GUI, required in headless);
* --out-fps FPS - output framerate (for fps-based subtitles);
* --out-enc ENC - output character encoding (optional).
Options --ref-stream-by-lang and --ref-stream-by-type could be combined together.

In headless mode output must be specified, in GUI it is ignored.

If stream is not specified, first subtitle/audio stream will be selected automatically (subtitles are preferred over audio, also for ref).

Language must be known only for audio ref stream. If not specified explicitly, it will be read from file metadata (if available). It should be also known if sub is of different language than ref, allowing SubSync to use appropriate dictionary. Language information also improves character encoding detection.

## Available Bazarr variables
Variables you can use in your command (include the double curly brace):
* {{directory}}
The full path of the episode file parent directory.

* {{episode}}
The full path of the episode file.

* {{episode_name}}
The filename of the episode without parent directory or extension.

* {{subtitles}}
The full path of the subtitles file.

* {{subtitles_language}}
The language of the subtitles file.

* {{subtitles_language_code2}}
The 2-letter ISO-639 language code of the subtitles language.

* {{subtitles_language_code3}}
The 3-letter ISO-639 language code of the subtitles language.

* {{episode_language}}
The audio language of the episode file.

* {{episode_language_code2}}
The 2-letter ISO-639 language code of the episode audio language.

* {{episode_language_code3}}
The 3-letter ISO-639 language code of the episode audio language.

* {{score}}
The score of the subtitles file.
