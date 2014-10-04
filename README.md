# Captioner

## Overview

This is a very simple utility for creating slide decks from images and videos. Images can have an optional caption. That's it!

## Dependencies

This project has been tested with Ruby 2.1. It may work with older versions.

There are no gem dependencies for this utility. However, it does depend on [imagemagick](http://www.imagemagick.org/) being available on the command line.

## Usage

`ruby caption.rb [caption_config_file].yml`

## Caveats

Currently there is absolutely 0 attempt to be responsive. This was designed to caption screenshots on my 13" Retina Macbook Pro and captions are placed using absolute coordinates, so images at alternative resolutions are unlikely to work well with the captioning functionality.

## Config File

### Example

```yaml
---

in_dir: media
out_dir: media_out

format:
  image: jpg

media:
  - image: homepage.png
    caption: Memorials are public and searchable from the homepage.
  - image: memorial.png
    caption: Each memorial includes a collection of videos from friends and family.
  - image: memorial_admin.png
    caption: Administrators can change memorial settings and hide recordings.
  - image: home_record.png
    caption: Loved ones can also record videos from home on a phone or tablet.
  - video: mark_cluff.mp4
  - image: fh_admin.png
    caption: The funeral home admin interface allows you to edit memorials and export data.
```

### Description

 * `in_dir` [optional] the root directory your media is found in. By default this is "_media"
 * `out_dir` [optional] the directory you wish your slide deck to be saved to. Any existing files in this directory will be deleted. Default is `_media_out`.
 * `format` [optional] the default export format for images. Can be any format supported by the imagemagick `convert` utility.
 * `media`: An in-order list of media files (video or audio) to use in the slide deck
 * `image` or `video`: the name/path to the image or video within the input directory
 * `caption` [image only] the text you wish to 