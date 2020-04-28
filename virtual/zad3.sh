#!/bin/bash

echo "buf_size,avg_spd" > zad3_avg_spd.csv
sed -i -E "s/^set window_tcp1 +[0-9]+/set window_tcp1 100/" tcp.tcl

for buf_size in {5..120..5}; do
	sed -i -E "s/^set buffer_R1R2 +[0-9]+/set buffer_R1R2 ${buf_size}/" tcp.tcl
	ns tcp.tcl 2>/dev/null | grep -E "TCP1 Average Throughput = [0-9.]+" | sed -E "s/^TCP1 Average Throughput = ([0-9.]+) \[Mbps\]/${buf_size},\1/" >> zad3_avg_spd.csv
	mv out.csv zad3_${buf_size}.csv
	echo -ne "."
done

echo
mkdir -p zad3
mv zad3_*.csv zad3/
