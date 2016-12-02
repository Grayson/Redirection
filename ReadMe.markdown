# Redirection

Redirection is a very simple application to intercept URLs and open
them in specific browsers.  Basically, if you assume that you have some
links that you like to open in one browser (say, open Google Hangouts in
Chrome) and other links that you'd like to open in Safari, Redirection
can make that happen.

## Known issues

Currently, the following issues are known:

* Links open *behind* Redirection.app.
* The default browser is Safari.
* There is no app icon.
* This app is not localized.

Sorry.  I'll see about fixing these soon.  Except maybe localization. If
you prefer a non-English UI for this app, please let me know.  Contact info
below.

## How to use Redirection

First, you'll need to download and compile this project.  Assuming that
you're already on Github, I'll also assume that you can do that.
You can compile using Xcode.  Just open the project and build and run.
If you want to install... well I assume you know enough to do that as well.

Second (and I'm assuming the important part for most tech-minded people
who have stumbled onto this), you'll need to change the default web browser
to Redirection.  You can do that in the General pane of System Preferences.

## Future plans

* Use a background application for redirection (avoid having to keep
Redirection running; also potentially allow links to go straight to intended
browser).
* Improve the "match" characteristics.  This includes matching URL scheme,
path, extension, etc.
* Perhaps allow users to decide behavior based on a script (Javascript?
Applescript? Lua?).
* Add Applescript support.

## Contact info

Grayson Hansard
grayson.hansard@gmail.com

## License information

Uh.  Wow.  Didn't really give this much thought.  Let's go with an
[MIT license](https://opensource.org/licenses/MIT)

Copyright (c) 2016 Grayson Hansard

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
