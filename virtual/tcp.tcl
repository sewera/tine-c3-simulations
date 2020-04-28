###################################################
# Simulation parameters

# Simulation time
set sim_time     180
set ini_time     60

# Sampling interval
set interval     0.01

# Enable/disable ftp1 application
set enable_tcp1   1

# Enable/disable ftp2 application
set enable_tcp2   0

# Enable/disable ftp3 application
set enable_tcp3   0

# Window size (in segments) for tcp1 source
set window_tcp1   50

# Window size (in segments) for tcp2 source
set window_tcp2   5000

# Window size (in segments) for tcp3 source
set window_tcp3   5000

# Delay on R1-R2 link
set delay_R1R2    50ms

# Capacity of R1-R2 link
set capacity_R1R2 10Mb

# Buffer on R1-R2 link
set buffer_R1R2   5

# TCP segment size
set segment_size  1460

###################################################

# Create new simulator object
set ns [new Simulator]

# Create new output file "out.csv"
set outfile [open out.csv w]

# Delays on access links
set delay_z1R1    10ms
set delay_z2R1    10ms
set delay_z3R1    10ms

set delay_R2o1    10ms
set delay_R2o2    10ms
set delay_R2o3    10ms

# Enable/disable UDP app
set enable_udp    1

# Write header to output file
puts  $outfile  "time;cwnd1;cwnd2;cwnd3;rtt1;rtt2;rtt3;bytes1;bytes2;bytes3"

# Create network nodes
set z1 [$ns node]
set z2 [$ns node]
set z3 [$ns node]
set z4 [$ns node]
set o1 [$ns node]
set o2 [$ns node]
set o3 [$ns node]
set o4 [$ns node]
set R1 [$ns node]
set R2 [$ns node]

# Create network links
$ns duplex-link $z1 $R1 100Mb $delay_z1R1 DropTail
$ns duplex-link $z2 $R1 100Mb $delay_z2R1 DropTail
$ns duplex-link $z3 $R1 100Mb $delay_z3R1 DropTail
$ns duplex-link $z4 $R1 100Mb 10ms DropTail
# --- bottleneck link
$ns duplex-link $R1 $R2 $capacity_R1R2 $delay_R1R2 DropTail
$ns duplex-link $R2 $o1 100Mb delay_R2o1 DropTail
$ns duplex-link $R2 $o2 100Mb delay_R2o2 DropTail
$ns duplex-link $R2 $o3 100Mb delay_R2o3 DropTail
$ns duplex-link $R2 $o4 100Mb 10ms DropTail

# R1-R2 link buffer size
$ns queue-limit $R1 $R2 $buffer_R1R2

#####################################
# Configure TCP connection z1->o1
set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $z1 $tcp1
set sink1 [new Agent/TCPSink/DelAck]
$ns attach-agent $o1 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1
$tcp1 set window_ $window_tcp1
$tcp1 set packetSize_ $segment_size

# Configure FTP app for connection z1->o1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#####################################
# Configure TCP connection z2->o2
set tcp2 [new Agent/TCP/Newreno]
$ns attach-agent $z1 $tcp2
set sink2 [new Agent/TCPSink/DelAck]
$ns attach-agent $o2 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 2
$tcp2 set window_ $window_tcp2
$tcp2 set packetSize_ $segment_size

# Configure FTP app for connection z2->o2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

#####################################
# Configure TCP connection z3->o3
set tcp3 [new Agent/TCP/Newreno]
$ns attach-agent $z3 $tcp3
set sink3 [new Agent/TCPSink/DelAck]
$ns attach-agent $o3 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 3
$tcp3 set window_ $window_tcp3
$tcp3 set packetSize_ $segment_size

# Configure FTP app for connection z3->o3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP


#####################################
# Configure UDP flow z4->o4
set udp [new Agent/UDP]
$ns attach-agent $z4 $udp
set null [new Agent/Null]
$ns attach-agent $o4 $null
$ns connect $udp $null
$udp set fid_ 4


set vbr [new Application/Traffic/Exponential]
$vbr set packetSize_ 1460
$vbr set burst_time_ 50ms
$vbr set idle_time_ 50ms
$vbr set rate_ 200k
$vbr attach-agent $udp

set tick1 [$tcp1 set tcpTick_]
set tick2 [$tcp2 set tcpTick_]
set tick3 [$tcp3 set tcpTick_]
set count 0
set s_bytes1 0
set s_bytes2 0
set s_bytes3 0
set s_time 0

#####################################
# Start and stop FTP app
if { $enable_tcp1 >0}  {
	$ns at 0 "$ftp1 start"
	$ns at $sim_time "$ftp1 stop"
}

if { $enable_tcp2 >0} {
	$ns at 0 "$ftp2 start"
	$ns at $sim_time  "$ftp2 stop"
}

if { $enable_tcp3 >0} {
	$ns at 0 "$ftp3 start"
	$ns at $sim_time  "$ftp3 stop"
}

if { $enable_udp >0} {
	$ns at 0 "$vbr start"
	$ns at $sim_time  "$vbr stop"
}


# Finalization of the simulation
proc finish {} {
    global ns TraceFile NamFile
    global ns outfile
    global ns sink1
    global ns sink2
    global ns sink3
    global segment_size
    global ini_bytes1
    global ini_bytes2
    global ini_bytes3
    global s_time
    global enable_udp
    global enable_tcp1
    global enable_tcp2
    global enable_tcp3
    global window_tcp1
    global window_tcp2
    global window_tcp3
    global delay_R1R2
    global capacity_R1R2
    global buffer_R1R2
    global sim_time
    global ini_time


    $ns flush-trace
    #close $TraceFile
    #close $NamFile
    close $outfile

    set now [$ns now]
    set bytes1 [$sink1 set bytes_]
    set bytes2 [$sink2 set bytes_]
    set bytes3 [$sink3 set bytes_]

    set systemTime [clock seconds]
    puts ""
    puts ""
    puts "Simulation time      $sim_time"
    puts "Initialization time  $ini_time"
    puts "Active sources       \[$enable_tcp1 $enable_tcp2 $enable_tcp3\ $enable_udp\]"
    puts "TCP Windows          \[$window_tcp1 $window_tcp2 $window_tcp3\]"
    puts "Link delay           $delay_R1R2"
    puts "Link capacity        $capacity_R1R2"
    puts "Link buffer          $buffer_R1R2"
    puts ""

    puts "TCP1 Average Throughput = [expr $bytes1*8.0/$now/1000000.0] \[Mbps\]"
    puts "      Stable Throughput = [expr ($bytes1-$ini_bytes1)*8.0/($now-$s_time)/1000000.0] \[Mbps\]"
    puts "TCP2 Average Throughput = [expr $bytes2*8.0/$now/1000000.0] \[Mbps\]"
    puts "      Stable Throughput = [expr ($bytes2-$ini_bytes2)*8.0/($now-$s_time)/1000000.0] \[Mbps\]"
    puts "TCP3 Average Throughput = [expr $bytes3*8.0/$now/1000000.0] \[Mbps\]"
    puts "      Stable Throughput = [expr ($bytes3-$ini_bytes3)*8.0/($now-$s_time)/1000000.0] \[Mbps\]"

    flush stdout

    exit 0
}

# Simulation end time
$ns at $sim_time "finish"


# Saving data to output file
proc plotWindow {Tcp1 Tcp2 Tcp3 Sink1 Sink2 Sink3 outfile} {
    global ns
    global tick1
    global tick2
    global tick3
    global segment_size
    global ini_bytes1
    global ini_bytes2
    global ini_bytes3
    global ini_time
    global sim_time
    global s_time
    global interval

    set now [$ns now]
    set cwnd1 [$Tcp1 set cwnd_]
    set cwnd2 [$Tcp2 set cwnd_]
    set cwnd3 [$Tcp3 set cwnd_]

    set rtt1 [$Tcp1 set rtt_]
    set rtt2 [$Tcp2 set rtt_]
    set rtt3 [$Tcp3 set rtt_]

    set nbytes1 [$Sink1 set bytes_]
    set nbytes2 [$Sink2 set bytes_]
    set nbytes3 [$Sink3 set bytes_]

    puts  $outfile  "$now;[expr $cwnd1*$segment_size];[expr $cwnd2*$segment_size];[expr $cwnd3*$segment_size];[expr $rtt1*$tick1];[expr $rtt2*$tick2];[expr $rtt3*$tick3];$nbytes1;$nbytes2;$nbytes3"

    if { $now >$ini_time} {
        if { $s_time <$ini_time} {
            set s_time [expr $now]
            set ini_bytes1 [expr $nbytes1]
            set ini_bytes2 [expr $nbytes2]
            set ini_bytes3 [expr $nbytes3]
            puts  ""
        }
    }

    $ns at [expr $now+$interval] "plotWindow $Tcp1 $Tcp2 $Tcp3 $Sink1 $Sink2 $Sink3 $outfile"
}

proc plotDot {} {
     global ns

     set now [$ns now]
     puts -nonewline "."
     flush stdout
     $ns at [expr $now+1.0] "plotDot"
}


# Start logging of simulation data
$ns  at  0.0  "plotWindow $tcp1 $tcp2 $tcp3 $sink1 $sink2 $sink3 $outfile"
$ns  at  0.0  "plotDot"

$defaultRNG seed 0

# Start simulation
$ns run
