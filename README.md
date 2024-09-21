# My vimrc

This repository contains my default vim configuration. It contains configuration for all of the plugins needed to get up and running with vim, using my desired settings. And, most importantly, it contains a very easy-to-use shell script that will setup vim on a fresh install of Ubuntu.

# Usage
- Yanks and pastes will now be synced with the same clipboard used across the rest of your programs.
- `<C+h>` will move the cursor to the next left-most window, and ditto for `j`, `k`, and `l`. This can move you to and between the directory listing on the left-hand side.
- While in the directory listing, typing `<Enter>` will open up the file you're hovering over. It'll open it up in the window you were most recently editing in. `<S+c>` will move the current working directory to whatever directory you're hovering over. `<S+i>` will toggle the visibility of hidden files. `\t` will open and close the directory listing.
- There are several automatic optimizations when it comes to using open-close-type characters `{`, `[`, `(`, `'`, `"`, etc. If you want to simply type a character like `{` without those optimizations, type `<C+v>{` while in insert mode. The same will work for any of the other optimized open-close characters.
- If you want to wrap parenthesis around a long word like `this_is_a_long_variable`, then type `(<A+e>` while your cursor is blinking over the initial letter `t`. The same applies to all of the other open-close characters.
- Vim will check for compiler errors everytime you save a `.cpp` file with `:w`. You can add the configuration file `.syntastic_cpp_config` with all of the compiler arguments you would like to use when compiling a `.cpp` file in that directory. An example would be `-I.\n-std=c++17`, for including header files in the root directory `.` and compiling with `C++17`.
- `<Space>ff` will fuzzy find for file names in your current working direcotry

# Setup
If you're on Ubuntu running Gnome, simply execute `./setup.sh`. If you're not running Gnome, then you'll have to personally figure out how to enable clipboard syncing in vim. If you're not using Ubuntu, then you'll have to potentially adjust all of the dependency install commands to your specific distribution.
