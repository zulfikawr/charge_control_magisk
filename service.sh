function boot_wait() {
  while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done
}

function write_file_lock() {
  if [[ -f "$2" ]]; then
    chmod 0666 "$2"
    echo "$1" > "$2"
    chmod 0444 "$2"
  fi
}

function read_charge() {
  local nodes="/sys/class/power_supply/battery/constant_charge_current_max
               /sys/class/power_supply/main/constant_charge_current_max
               /sys/class/power_supply/battery/current_max
               /sys/class/power_supply/main/current_max
               /sys/class/power_supply/usb/current_max
               /sys/class/power_supply/battery/input_current_limit
               /sys/class/power_supply/battery/input_current_max
               /sys/class/power_supply/usb/input_current_max"
  for node in $nodes; do
    if [[ -f "$node" ]]; then
      local val=$(cat "$node")
      if [[ "$val" =~ ^[0-9]+$ ]] && [[ "$val" -gt 0 ]]; then
        echo "$val"
        return
      fi
    fi
  done
  echo "0"
}

function write_charge() {
  [[ -z "$1" ]] && return
  write_file_lock "$1" "/sys/class/power_supply/usb/current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/hw_current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/pd_current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/ctm_current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/sdp_current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/input_current_max"
  write_file_lock "$1" "/sys/class/power_supply/usb/input_current_settled"
  write_file_lock "$1" "/sys/class/power_supply/usb/input_current_now"
  write_file_lock "$1" "/sys/class/power_supply/main/current_max"
  write_file_lock "$1" "/sys/class/power_supply/main/constant_charge_current_max"
  write_file_lock "$1" "/sys/class/power_supply/battery/current_max"
  write_file_lock "$1" "/sys/class/power_supply/battery/constant_charge_current_max"
  write_file_lock "$1" "/sys/class/power_supply/battery/input_current_max"
  write_file_lock "$1" "/sys/class/power_supply/pc_port/current_max"
  write_file_lock "$1" "/sys/class/power_supply/constant_charge_current_max"
  write_file_lock "$1" "/sys/class/qcom-battery/restricted_current"
}

function get_save_charge_current() {
  local current=$(read_charge)
  [[ "$current" == "0" ]] && return
  resetprop -n "default.charge.current" "$current"
}

function last_set_all() {
  local lastset=$(resetprop charge.current.lastset)
  if [[ "$lastset" ]]; then
    write_charge "$lastset"
  fi
}

function other_charge_opt() {
write_file_lock "1" "/sys/kernel/fast_charge/force_fast_charge"
write_file_lock "1" "/sys/class/power_supply/battery/system_temp_level"
write_file_lock "1" "/sys/kernel/fast_charge/failsafe"
write_file_lock "1" "/sys/class/power_supply/battery/allow_hvdcp3"
write_file_lock "1" "/sys/class/power_supply/usb/pd_allowed"
write_file_lock "1" "/sys/class/power_supply/battery/subsystem/usb/pd_allowed"
write_file_lock "0" "/sys/class/power_supply/battery/input_current_limited"
write_file_lock "1" "/sys/class/power_supply/battery/input_current_settled"
write_file_lock "0" "/sys/class/qcom-battery/restricted_charging"
write_file_lock "100" "/sys/class/power_supply/bms/temp_cool"
write_file_lock "500" "/sys/class/power_supply/bms/temp_hot"
write_file_lock "450" "/sys/class/power_supply/bms/temp_warm"
}

boot_wait
get_save_charge_current
last_set_all
other_charge_opt