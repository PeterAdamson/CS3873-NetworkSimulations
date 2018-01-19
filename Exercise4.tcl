#code created using the tutorial found at https://www.isi.edu/nsnam/ns/tutorial/index.html as a base.
set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam out.nam &
        exit 0
}

set n0 [$ns node]
#[lab]
set n99 [$ns node]
set n1 [$ns node]

#[lab]
$ns duplex-link $n0 $n99 1Mb 10ms DropTail
#[lab]
$ns duplex-link $n99 $n1 500kb 10ms DropTail
$ns duplex-link-op $n99 $n1 queuePos 0.5

#Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

$ns connect $udp0 $null0  

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run
