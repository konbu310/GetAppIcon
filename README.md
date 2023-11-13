# GetAppIcon

Get app icons by Application Path on macOS. Returns a `base64` encoded data string which can be used for displaying or manipulating the resulting image.

## Usage

```bash
$ swift build -c release
```

```bash
$ .build/release/GetAppIcon --help
Usage:

    $ .build/release/GetAppIcon <path>

Arguments:

    appPath - Path of the app

Options:
    --size [default: 32] - Size of the output icon
    --encoding [default: base64] - Encoding of output icon
```

## Example

```bash
$ .build/release/GetAppIcon /Applications/Safari.app --size 512
data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAA...

$ .build/release/GetAppIcon /Applications/Safari.app --size 512 --encoding buffer > icon.png
```
