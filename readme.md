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

## Licenses
The following third-party libraries may be included in the final build:

- [Love](https://love2d.org)
    - Licensed under the zlib license
    - Copyright © 2006-2023 LOVE Development Team

- [Lua](https://www.lua.org/)
    - Licensed under the MIT license
    - Copyright © 1994–2023 Lua.org, PUC-Rio.

- [MPG123](http://www.mpg123.de/)
    - Licensed under the LGPL 2.1 license
    - Copyright © 1995-2013 by Michael Hipp and others

- [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2013-vc-120--no-longer-supported)
    - Licensed under the Microsoft Visual C++ End User License Agreement (EULA)
    - Copyright © Microsoft Corporation

- [OpenAL](https://openal-soft.org/)
    - Licensed under the LGPL 2.1 license
    - Copyright © 1999-2014, the OpenAL Team and contributors

- [SDL2](https://www.libsdl.org/)
    - Licensed under the zlib license
    - Copyright © 2013-2023 Sam Lantinga and the SDL development team

- [Roboto](https://fonts.google.com/specimen/Roboto/)
    - Licensed under the SIL Open Font license
    - Copyright © 2011 The Roboto Project Authors

You may find a list of all license texts in ``/LICENSE``.

## Contributing
Feel free to submit bug reports, feature requests, or contribute via pull requests.