#!/bin/bash

echo "buf_size,avg_spd" > zad4_avg_spd.csv
sed -i -E "s/^set enable_tcp1 +[0-9]+/set enable_tcp1 1/" tcp.tcl
sed -i -E "s/^set enable_tcp2 +[0-9]+/set enable_tcp2 1/" tcp.tcl
sed -i -E "s/^set enable_tcp3 +[0-9]+/set enable_tcp3 1/" tcp.tcl
sed -i -E "s/^set window_tcp1 +[0-9]+/set window_tcp1 5000/" tcp.tcl

for buf_size in 5 200; do
	sed -i -E "s/^set buffer_R1R2 +[0-9]+/set buffer_R1R2 ${buf_size}/" tcp.tcl
	ns tcp.tcl 2>/dev/null | grep -E "TCP1 Average Throughput = [0-9.]+" | sed -E "s/^TCP1 Average Throughput = ([0-9.]+) \[Mbps\]/${buf_size},\1/" >> zad4_avg_spd.csv
	mv out.csv zad4_${buf_size}.csv
	echo -ne "."
done

echo
mkdir -p zad4
mv zad4_*.csv zad4/
