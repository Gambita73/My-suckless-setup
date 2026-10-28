#!/bin/bash

read cpu user nice system idle iowait irq softirq steal _ < /proc/stat
prev_idle=$((idle + iowait))
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))


cpu_usage() {
    read cpu user nice system idle iowait irq softirq steal _ < /proc/stat

    idle_now=$((idle + iowait))
    total_now=$((user + nice + system + idle + iowait + irq + softirq + steal))

    idle_diff=$((idle_now - prev_idle))
    total_diff=$((total_now - prev_total))

    usage=$((100 * (total_diff - idle_diff) / total_diff))

    prev_idle=$idle_now
    prev_total=$total_now

    echo "$usage"
}


while true;do

    #It defines the variable
    memtotal="$(cat /proc/meminfo | grep "MemTotal" | tr -d " MmetalkBTo:")"
    memfree="$(cat /proc/meminfo | grep "MemAvailable" | tr -d "MemAvailb:kB ")"
    
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)


    #Calculates the memory
    mem=$(( (memtotal - memfree) * 100 / memtotal))
    date=$(date)

    #CPU usage
    cpu=$(cpu_usage)

    #Display 
    xsetroot -name " CPU $cpu% | RAM $mem% | Battery $battery% | $date"
    sleep 1
done 
