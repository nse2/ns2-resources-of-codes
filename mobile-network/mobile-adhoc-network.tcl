set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 6 ;# number of mobilenodes
set val(rp) DSDV ;# routing protocol
set val(x) 1283 ;# X dimension of topography
set val(y) 100 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end
#===================================
# Initialization
#===================================
#Create a ns simulator
set ns [new Simulator]
#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile
#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel
#===================================
# Mobile node parameter setup
#===================================
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channel $chan \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON \
-movementTrace ON
#===================================
# Nodes Definition
#===================================
#Create 6 nodes
set n0 [$ns node]
$n0 set X_ 323
$n0 set Y_ 184
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 126
$n1 set Y_ 234
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 341
$n2 set Y_ 380
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 568
$n3 set Y_ 214
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 427
$n4 set Y_ 5
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 175
$n5 set Y_ -17
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
#===================================
# Agents Definition
#===================================
#Setup a TCP connection
set tcp5 [new Agent/TCP]
$ns attach-agent $n1 $tcp5
set sink0 [new Agent/TCPSink]
$ns attach-agent $n0 $sink0
$ns connect $tcp5 $sink0
$tcp5 set packetSize_ 1500
#Setup a TCP connection
set tcp6 [new Agent/TCP]
$ns attach-agent $n2 $tcp6
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1
$ns connect $tcp6 $sink1
$tcp6 set packetSize_ 1500
#Setup a TCP connection
set tcp7 [new Agent/TCP]
$ns attach-agent $n3 $tcp7
set sink2 [new Agent/TCPSink]
$ns attach-agent $n0 $sink2
$ns connect $tcp7 $sink2
$tcp7 set packetSize_ 1500
#Setup a TCP connection
set tcp8 [new Agent/TCP]
$ns attach-agent $n4 $tcp8
set sink3 [new Agent/TCPSink]
$ns attach-agent $n0 $sink3
$ns connect $tcp8 $sink3
$tcp8 set packetSize_ 1500
#Setup a TCP connection
set tcp9 [new Agent/TCP]
$ns attach-agent $n5 $tcp9
set sink4 [new Agent/TCPSink]
$ns attach-agent $n0 $sink4
$ns connect $tcp9 $sink4
$tcp9 set packetSize_ 1500
#===================================
# Applications Definition
#===================================
#Setup a FTP Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp5
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"
#Setup a FTP Application over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp6
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 stop"
#Setup a FTP Application over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp7
$ns at 1.0 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"
#Setup a FTP Application over TCP connection
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp8
$ns at 1.0 "$ftp3 start"
$ns at 2.0 "$ftp3 stop"
#Setup a FTP Application over TCP connection
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp9
$ns at 1.0 "$ftp4 start"
$ns at 2.0 "$ftp4 stop"
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
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
