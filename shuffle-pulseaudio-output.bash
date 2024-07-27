#!/bin/bash
#
## This is a script made for Debian with XFCE4 that automatically selects the currently active
## window and then switches the audio output sink to a different output device for that window.
#
#
#
#
#    PulseAudio-ActiveWindowOutput-Shuffler to change audio output sinks for the active window.
#    Copyright (C) 2024 GitHub.com/Zeph53
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#
#
#
## Parse command-line options
invalid_option_message="Use \""$(basename "$0")" --help\" for help"
if
  [[ "$#" -eq 0 ]]
then
  printf "Script must be executed with a command option. \n"
  printf "$invalid_option_message. \n"
  exit 1
else
  while
    [[ "$#" -gt 0 ]]
  do
    case "$1" in
      (--)
        shift
        break 1
      ;;
      ('-?'|'-h'|'--help')
        show_help="true"
      ;;
      ('-c'|'--current')
        switch_current_sink="true"
      ;;
      ('-n'|'--next')
        switch_next_sink="true"
      ;;
      (*)
        if
          [[ "${1:0:1}" == "-" ]] ||
          [[ -e "$*" ]]
        then
          printf "%s is an invalid command option. \n" "\"$1\""
          printf "$invalid_option_message \n"
          exit 1
        fi
      ;;
    esac
    shift
  done
fi
#
#
#
#
### Show help menu
if
  [[ "$show_help" == "true" ]]
then
  printf "\
Switch the audio output sink associated with the current 
or next active process to the next available audio output sink.

Usage: 
  "$(basename "$0")" [OPTION]

Options:
  --next (-n)        Monitor active window changes and switch to the next sink when an audio window becomes active.
  --current (-c)     Switch the audio output sink associated with the current process to the next available sink.
  --help (-h)        Display this help menu.

Shuffle-Pulseaudio-Output.bash
Copyright (C) 2024 GitHub.com/Zeph53
This program comes with ABSOLUTELY NO WARRANTY!
This is free software, and you are welcome to
redistribute it under certain conditions.
See \"https://www.gnu.org/licenses/gpl-3.0.txt\"
"
  exit 0
fi
#
#
#
#
## Disclaimer GNU General Public License v3.0 (gpl-3.0)
printf \
'This program comes with ABSOLUTELY NO WARRANTY! \n'
printf \
'This is free software, and you are welcome to redistribute it under certain conditions. \n\n'
#
#
#
#
## List of functions
# Function to get the active process ID
get_active_pid() {
  xprop -id "$(xprop -root "_NET_ACTIVE_WINDOW" | cut -d ' ' -f 5)" "_NET_WM_PID" | cut -d ' ' -f 3
}
## Function to get the active index ID
get_active_index() {
  local pid="$1"
  pacmd list-sink-inputs | awk -v pid="$pid" '
    $1 == "index:" { idx = $2; app_id = 0 }
    $1 == "application.process.id" && $3 == "\""pid"\"" {
      print idx
      exit
    }
  '
}
## Function to get the active sink ID
get_active_sink() {
  local active_index="$1"
  pacmd list-sink-inputs | awk -v active_idx="$active_index" '$1 == "index:" {idx = $2} $1 == "sink:" && idx == active_idx {printf "%s", $2}'
}
## Function to get the available sink IDs
get_available_sinks() {
  pacmd list-sinks | awk '/index:/{printf "%s ",$NF}'
}
## Function to switch the current process to the next available sink
switch_current_to_next_sink() {
  active_proc_id="$(get_active_pid)"
  active_index_id="$(get_active_index "$active_proc_id")"
  active_sink_id="$(get_active_sink "$active_index_id")"
  if
    [ -n "$active_sink_id" ]
  then
    avail_sink_ids="$(get_available_sinks)"
    num_sinks="$(echo "$avail_sink_ids" | wc -w)"
    current_index="0"
    for sink_id in $avail_sink_ids
    do
      if
        [ "$sink_id" == "$active_sink_id" ]
      then
        break
      fi
      ((current_index++))
    done
    ((current_index++))
    next_index="$((current_index % num_sinks + 1))"
    next_sink_id="$(echo "$avail_sink_ids" | awk -v idx="$next_index" '{print $idx}')"
    if
      [ "$next_sink_id" != "$active_sink_id" ]
    then
      pacmd move-sink-input "$active_index_id" "$next_sink_id"
      echo "Audio output for the currently active window switched to the next available output device."
      exit 0
    elif
      [ "$next_sink_id" == "$active_sink_id" ]
    then
      printf "There is no other available audio output device to switch to. \n"
      no_device_prompt_displayed="true"
    fi
  else
    echo "No active audio found for the current window."
    exit 1
  fi
}
## Function to monitor active window changes and switch to the next sink when an audio window becomes active
monitor_window_and_switch_to_next_sink() {
  terminal_pid="$(get_active_pid)"
  audio_detected="false"
  prompt_displayed="false"
  last_active_window_pid=""
  while
    :
  do
    active_window_pid="$(get_active_pid)"
    if
      [ "$active_window_pid" != "$terminal_pid" ]
    then
      sleep 0.10
      terminal_pid="$(get_active_pid)"
      continue
    fi
    active_index_id="$(get_active_index "$active_window_pid")"
    active_sink_id="$(get_active_sink "$active_index_id")"
    if
      [ "$last_active_window_pid" != "$active_window_pid" ]
    then
      last_active_window_pid="$active_window_pid"
      if
        [ -z "$active_sink_id" ]
      then
        if
          ! "$prompt_displayed"
          [[ -z "$no_device_prompt_displayed" ]]
        then
          echo "Please select a window with audio. ^C to exit."
          prompt_displayed="true"
        fi
        echo "The selected window has no audio. "
        audio_detected="false"
      else
        if
          ! "$audio_detected"
        then
          audio_detected="true"
          switch_current_to_next_sink
        fi
        prompt_displayed="false"
      fi
    fi
  sleep 0.10
  done
}
#
#
#
#
## Switch current audio output sink to a different device
if
  [[ "$switch_current_sink" == "true" ]]
then
  switch_current_to_next_sink
  exit 0
fi
## Switch next selected audio window's output sink to a different device
if
  [[ "$switch_next_sink" == "true" ]]
then
  monitor_window_and_switch_to_next_sink
  exit 0
fi




