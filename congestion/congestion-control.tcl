set val(stop) 10.0 ;# time of simulation end
#===================================
# Initialization
#===================================
#Create a ns simulator
set ns [new Simulator]
#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile
#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
#===================================
# Nodes Definition
#===================================
#Create 12 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]
#===================================
# Links Definition
#===================================
#Createlinks between nodes
$ns duplex-link $n2 $n0 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n0 50
$ns duplex-link $n1 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 50
$ns duplex-link $n3 $n2 100.0Mb 10ms DropTail
$ns queue-limit $n3 $n2 50
$ns duplex-link $n2 $n4 100.0Mb 10ms DropTail
$ns queue-limit $n2 $n4 50
$ns duplex-link $n5 $n3 100.0Mb 10ms DropTail
$ns queue-limit $n5 $n3 50
$ns duplex-link $n4 $n5 100.0Mb 10ms DropTail
$ns queue-limit $n4 $n5 50
$ns duplex-link $n6 $n7 100.0Mb 10ms DropTail
$ns queue-limit $n6 $n7 50
$ns duplex-link $n6 $n8 100.0Mb 10ms DropTail
$ns queue-limit $n6 $n8 50
$ns duplex-link $n7 $n9 100.0Mb 10ms DropTail
$ns queue-limit $n7 $n9 50
$ns duplex-link $n8 $n9 100.0Mb 10ms DropTail
$ns queue-limit $n8 $n9 50
$ns duplex-link $n9 $n10 0.5Mb 10ms DropTail
$ns queue-limit $n9 $n10 50
$ns duplex-link $n9 $n11 0.5Mb 10ms DropTail
$ns queue-limit $n9 $n11 50
$ns simplex-link $n5 $n6 0.3Mb 10ms DropTail
$ns queue-limit $n5 $n6 50
$ns simplex-link $n6 $n5 0.3Mb 10ms DropTail
$ns queue-limit $n6 $n5 50
#Give node position (for NAM)
$ns duplex-link-op $n2 $n0 orient left-up
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n3 $n2 orient left-down
$ns duplex-link-op $n2 $n4 orient right-down
$ns duplex-link-op $n5 $n3 orient left-up
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n6 $n7 orient right-up
$ns duplex-link-op $n6 $n8 orient right-down
$ns duplex-link-op $n7 $n9 orient right-down
$ns duplex-link-op $n8 $n9 orient right-up
$ns duplex-link-op $n9 $n10 orient right-up
$ns duplex-link-op $n9 $n11 orient right-down
$ns simplex-link-op $n5 $n6 orient right
$ns simplex-link-op $n6 $n5 orient left
#===================================
# Agents Definition
#===================================
#Setup a TCP connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink4 [new Agent/TCPSink]
$ns attach-agent $n10 $sink4
$ns connect $tcp0 $sink4
$tcp0 set packetSize_ 1500
#Setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null3 [new Agent/Null]
$ns attach-agent $n11 $null3
$ns connect $udp1 $null3
$udp1 set packetSize_ 1500
#===================================
# Applications Definition
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"
#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1.0Mb
$cbr1 set random_ null
$ns at 1.0 "$cbr1 start"
$ns at 2.0 "$cbr1 stop"
#===================================
# Termination
#===================================
#Define a 'finish' procedure
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam out.nam &
exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run