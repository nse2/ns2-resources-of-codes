set ns [new Simulator]
#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf
#Define a 'finish' procedure
proc finish {} {
 global ns nf
 $ns flush-trace
 #Close the trace file
 close $nf
 #Executenam on the trace file
 exec nam out.nam &
 exit 0
}

#Create four nodes
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]

#Create links between the nodes
$ns duplex-link $node1 $node2 1Mb 20ms FQ
$ns duplex-link $node1 $node3 1Mb 20ms FQ
$ns duplex-link $node1 $node4 1Mb 20ms FQ
$ns duplex-link $node2 $node3 1Mb 20ms FQ
$ns duplex-link $node2 $node4 1Mb 20ms FQ
$ns duplex-link $node3 $node4 1Mb 20ms FQ

set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $node1 $tcp0
#Creating a TCP Sink agent for TCP and attaching it to  node 3
set sink0 [new Agent/TCPSink]
$ns attach-agent $node3 $sink0
#Connecting the traffic sources with the traffic sink
$ns connect $tcp0 $sink0
# Creating a CBR traffic source and attach it to tcp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.05
$cbr0 attach-agent $tcp0
#Schedule events for the CBR agents
$ns at 0.5 "$cbr0 start"
$ns at 5.5 "$cbr0 stop"
#Here we call the finish procedure after 10 seconds of simulation time
$ns at 10.0 "finish"
#Finally run the simulation
$ns run

