# SHUFFLE-PULSEAUDIO-OUTPUT.BASH  
This is a keyboard shortcut Bash script that allows the user to instantly switch between PulseAudio output audio adapters for the currently active window. No more crashing games to change the audio output to headphones.  

## Requirements  
Debian12 with PulseAudio.  
Atleast two output audio sinks to shuffle through.  
Any types of output audio sinks should work, headphones, speakers, line-out, bluetooth, etc..  

## Installation  
Just download the ZIP and extract it somewhere, or clone the repository.  
#### Open the terminal and enter:  
    sudo git clone https://github.com/Zeph53/PulseAudio-ActiveWndowOutput-Shuffler/

## Uninstallation  
To uninstall the script, simply remove the script from your system.  
#### Open the terminal and enter:  
    sudo gio trash --force ~/shuffle-pulseaudio-output/
And then remove your keyboard shortcut.  

## Usage  
#### Simply assign a keyboard shortcut for your specific desktop environmnet or window manager:  
    Access DE/WM settings.  
    Navigate to keyboard settings.  
#### Enter the following into the command box. Make sure it actually points to the script:  
    PulseAudio-ActiveWndowOutput-Shuffler/shuffle-pulseaudio-output.bash
#### Assign a key when prompted, below works for me:  
    LCTRL+LSHIFT+S

## Updates  
    Fixed endless process loop with single output sink.
    A readme.md.
## Update Queue:  
    It would be nice if you could put a delay in the command to switch windows. To run the command then pick a window.
    Put a window title in the command and switch the audio like that.
    Use this script as a wrapper for another command so you dont even need to use the shortcut.
    Shuffle audio output for all windows, with an argument.
    Maybe switch the audio output for the NEXT active window, allowing the user to leave the terminal.
##  





