#code created using the tutorial found at https://www.isi.edu/nsnam/ns/tutorial/index.html
#provided by Mark Greis
#section IV
#and then modified using the instructions for lab 5 in cs3873, exercise 2.2 parts a through e

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
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

#Create a TCP agent and attach it to node n0
set tcp0 [new Agent/TCP]
$tcp0 set packetSize_ 500
$tcp0 set window_ 4
$ns attach-agent $n0 $tcp0

# Create a FTP traffic source and attach it to tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0

$ns connect $tcp0 $sink0  

$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"

$ns at 5.0 "finish"

$ns run
