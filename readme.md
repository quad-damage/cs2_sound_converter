# Counter-Strike 2 Sound Converter
Tool for converting different sound files to the .vsnd_c format used by Counter-Strike 2.

## Usage
Drag and drop your audio files into the program. The converted .vsnd_c will be saved next to the source files.

This program requires the Counter-Strike 2 Workshop Tools DLC to be installed.

![Showcase](https://i.imgur.com/SO9g7OD.gif)


## Building
Building this utility requires [Love2D](https://love2d.org/), [7-Zip](https://www.7-zip.org/) with the [LZMA SDK SFX modules](https://www.7-zip.org/sdk.html) and [ResourceHacker](https://www.angusj.com/resourcehacker/).

1) Set the paths to Love2D, 7-Zip and ResourceHacker in ``config.cmd``
2) Run ``build.bat`` to compile the project into an executable.
3) Alternatively, run ``run.bat`` to execute the converter directly without building.

## Troubleshooting
Create a shortcut to ``cs2_sound_converter.exe`` and add ``--console`` to the Target field.

This will print debug information to a console window.

## Contributing
Feel free to submit bug reports, feature requests, or contribute via pull requests.