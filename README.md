# Zabbix template for Windows Storage Spaces
##Monitoring params:
  - pools (size, allocated size, operational status, health status)
  - enclosure (firmware version, number of slots, operational status, health status)
  - virtual disks (size, write cache size, is tiered, ssd tier size, hdd tier size, operational status, health status)
  - physical disks (manufacturer, model, slot number, media type, size, firmware, usage, operational status, health status, read latency, write latency, read errors, write errors, power on hours, temperature, max temperature)
  
## Install

  1. Import template in zabbix web ui
  2. Add UserParameter lines to zabbix agent config file
  3. Copy PS scripts to c:/zabbix/scripts
  4. Connect template to host
  
P.S. If you have any additional 
  
