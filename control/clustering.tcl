set val(chan) Channel/WirelessChannel ;# channel type

set val(prop) Propagation/TwoRayGround ;#

set val(netif) Phy/WirelessPhy ;# network interface type

set val(mac) Mac/802_11 ;# MAC type

set val(ifq) Queue/DropTail/PriQueue ;# interface queue

set val(ll) LL ;# link layer type

set val(ant) Antenna/OmniAntenna ;# antenna model

set val(ifqlen) 50 ;# max packet in ifq

set val(nn) 6 ;# number of mobilenodes

set val(rp) DSDV ;# routing protocol

set val(x) 1096 ;# X dimension of topography

set val(y) 524 ;# Y dimension of topography

set val(stop) 10.0 ;# time of simulation end

#intiall

#Create a ns simulator

set ns [new Simulator]

#Setup topography object

set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)


set tracefile [open out.tr w]

$ns trace-all $tracefile

#Open the NAM trace file

set namfile [open out.nam w]

$ns namtrace-all $namfile

$ns namtrace-all-wireless $namfile $val(x) $val(y)

set chan [new $val(chan)];#Create wireless channel


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

#Create 6 nodes

set n0 [$ns node]

$n0 set X_ 665

$n0 set Y_ 327

$n0 set Z_ 0.0

$ns initial_node_pos $n0 20

set n1 [$ns node]

$n1 set X_ 884

$n1 set Y_ 280

$n1 set Z_ 0.0

$ns initial_node_pos $n1 20

set n2 [$ns node]

$n2 set X_ 474

$n2 set Y_ 424

$n2 set Z_ 0.0

$ns initial_node_pos $n2 20

set n3 [$ns node]

$n3 set X_ 980

$n3 set Y_ 401

$n3 set Z_ 0.0

$ns initial_node_pos $n3 20

set n4 [$ns node]

$n4 set X_ 996

$n4 set Y_ 264

$n4 set Z_ 0.0

$ns initial_node_pos $n4 20



set n5 [$ns node]

$n5 set X_ 509

$n5 set Y_ 290

$n5 set Z_ 0.0

$ns initial_node_pos $n5 20

#Setup a TCP connection

set tcp0 [new Agent/TCP]

$ns attach-agent $n2 $tcp0

set sink8 [new Agent/TCPSink]

$ns attach-agent $n0 $sink8

$ns connect $tcp0 $sink8

$tcp0 set packetSize_ 1500

#==================================

# Agents Definition
#==================================


#Setup a TCP connection

set tcp1 [new Agent/TCP]

$ns attach-agent $n0 $tcp1

set sink13 [new Agent/TCPSink]

$ns attach-agent $n1 $sink13

$ns connect $tcp1 $sink13

$tcp1 set packetSize_ 1500


#Setup a TCP connection

set tcp2 [new Agent/TCP]

$ns attach-agent $n1 $tcp2

set sink10 [new Agent/TCPSink]

$ns attach-agent $n0 $sink10

$ns connect $tcp2 $sink10

$tcp2 set packetSize_ 1500



#Setup a TCP connection

set tcp3 [new Agent/TCP]

$ns attach-agent $n3 $tcp3

set sink11 [new Agent/TCPSink]

$ns attach-agent $n1 $sink11

$ns connect $tcp3 $sink11

$tcp3 set packetSize_ 1500



#Setup a TCP connection

set tcp5 [new Agent/TCP]

$ns attach-agent $n5 $tcp5

set sink9 [new Agent/TCPSink]

$ns attach-agent $n0 $sink9

$ns connect $tcp5 $sink9

$tcp5 set packetSize_ 1500



#Setup a TCP connection

set tcp6 [new Agent/TCP]

$ns attach-agent $n4 $tcp6

set sink12 [new Agent/TCPSink]

$ns attach-agent $n1 $sink12

$ns connect $tcp6 $sink12

#==================================

# Applications Definition
#==================================


#Setup a FTP Application over TCP connection

set ftp0 [new Application/FTP]

$ftp0 attach-agent $tcp0

$ns at 1.0 "$ftp0 start"

$ns at 2.0 "$ftp0 stop"

#==================================

# Applications Definition
#==================================


#Setup a FTP Application over TCP connection

set ftp1 [new Application/FTP]

$ftp1 attach-agent $tcp1

$ns at 1.0 "$ftp1 start"

$ns at 2.0 "$ftp1 stop"

#==================================

# Applications Definition
#==================================


#Setup a FTP Application over TCP connection

set ftp2 [new Application/FTP]

$ftp2 attach-agent $tcp2

$ns at 1.0 "$ftp2 start"

$ns at 2.0 "$ftp2 stop"

#Setup a FTP Application over TCP connection

set ftp3 [new Application/FTP]

$ftp3 attach-agent $tcp3

$ns at 1.0 "$ftp3 start"

$ns at 2.0 "$ftp3 stop"

#==================================

# Applications Definition
#==================================


#Setup a FTP Application over TCP connection

set ftp4 [new Application/FTP]

$ftp4 attach-agent $tcp5

$ns at 1.0 "$ftp4 start"

$ns at 2.0 "$ftp4 stop"

#Setup a FTP Application over TCP connection

set ftp5 [new Application/FTP]

$ftp5 attach-agent $tcp6

$ns at 1.0 "$ftp5 start"

$ns at 2.0 "$ftp5 stop"

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

#==================================

# Termination
#==================================


for {set i 0} {$i < $val(nn) } { incr i } {

$ns at $val(stop) "\$n$i reset"

}

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"

$ns at $val(stop) "finish"

$ns at $val(stop) "puts \"done\" ; $ns halt"

$ns run







