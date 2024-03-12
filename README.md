# SHUFFLE-PULSEAUDIO-OUTPUT.BASH  
This Bash script that allows the user to instantly switch between PulseAudio output audio adapters for the currently active window. No more crashing games to change the audio output to headphones.  

## Requirements  
Debian with XPROP and PulseAudio.  
Atleast two output audio sinks to shuffle through.  
Any types of output audio sinks should work, headphones, speakers, line-out, bluetooth, etc..  

## Installation  
Just download the ZIP and extract it somewhere, or clone the repository.  
#### Open the terminal and enter:  
    git clone https://github.com/Zeph53/PulseAudio-ActiveWindowOutput-Shuffler/

## Uninstallation  
To uninstall the script, simply remove the script from your system.  
#### Open the terminal and enter:  
    gio trash --force ~/shuffle-pulseaudio-output/
And then remove your keyboard shortcut.  

## Usage  
#### Use "--help" (-h) argument to show a help menu:  
    .~/PulseAudio-ActiveWindowOutput-Shuffler/shuffle-pulseaudio-output.bash --help

#### Use "--next" (-n) argument to manually select the window with audio playing:  
    .~/PulseAudio-ActiveWindowOutput-Shuffler/shuffle-pulseaudio-output.bash --next
Utilizing the "--next" argument forces the user make active an inactive window, and then waits until the user selects a window with audio playing, then shuffles the audio output for that newly active window.  

#### Use "--current" (-c) argument to select the currently active window:  
    .~/PulseAudio-ActiveWindowOutput-Shuffler/shuffle-pulseaudio-output.bash --current
Using the "--current" argument instantly selects the currently active window. Presumably a terminal, without audio playing. Allows the user to set the command and it's arguments as a keyboard shortcut, then the user can shuffle the audio output for any active window. Can also be used with a "sleep 3" command preceding it, then the user would manually switch to an inactive window, with audio playing, which then would shuffle to a different output device.  

#### To use a keyboard shortcut with "--current" (-c): Simply assign a keyboard shortcut for your specific desktop environmnet or window manager:  
    Access DE/WM settings.  
    Navigate to keyboard settings.  
#### Enter the following into the command box. Make sure it actually points to the script:  
    "PulseAudio-ActiveWindowOutput-Shuffler/shuffle-pulseaudio-output.bash --current"
#### Assign a key when prompted, below works for me:  
    LCTRL+LALT+S

## Updates  
    Updated readme.md
    The user can now use --current to switch the output sink for the current window. Use with keyboard shortcuts.
    The user can now do "/path/to/script.bash --next" to switch the audio sink of the next active window.
    Added a --help menu, along with -h alias.
    Fixed endless process loop when used with single output sink.
    A readme.md.
## Update Queue:  
    It would be nice if you could put a delay in the command to switch windows. To run the command then pick a window.
    Put a window title in the command and switch the audio like that.
    Use this script as a wrapper for another command so you dont even need to use the shortcut.
    Shuffle audio output for all windows, with an argument.
    **Maybe switch the audio output for the NEXT active window, allowing the user to leave the terminal.
##  





