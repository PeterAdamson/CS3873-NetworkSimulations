#code created using the tutorial found at https://www.isi.edu/nsnam/ns/tutorial/index.html
#provided by Mark Greis
#section IV, V, and VII
#and then modified using the instructions for Assignment 3, cs3873, question 1
#modeled from the textbook, problem P3, page 429
#additional code information obtained from https://www.isi.edu/nsnam/ns/doc/node633.html
#and https://www.isi.edu/nsnam/ns/doc/node312.html

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
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$n0 label "t"
$n1 label "u"
$n2 label "v"
$n3 label "w"
$n4 label "x"
$n5 label "y"
$n6 label "z"

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n0 $n5 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1mb 10ms DropTail
$ns duplex-link $n1 $n3 1mb 10ms DropTail
$ns duplex-link $n2 $n3 1mb 10ms DropTail
$ns duplex-link $n2 $n4 1mb 10ms DropTail
$ns duplex-link $n2 $n5 1mb 10ms DropTail
$ns duplex-link $n3 $n4 1mb 10ms DropTail
$ns duplex-link $n4 $n5 1mb 10ms DropTail
$ns duplex-link $n4 $n6 1mb 10ms DropTail
$ns duplex-link $n5 $n6 1mb 10ms DropTail

$ns cost $n0 $n1 2
$ns cost $n1 $n0 2
$ns cost $n0 $n2 4
$ns cost $n2 $n0 4
$ns cost $n0 $n5 7
$ns cost $n5 $n0 7
$ns cost $n1 $n2 3
$ns cost $n2 $n1 3
$ns cost $n1 $n3 3
$ns cost $n3 $n1 3
$ns cost $n2 $n3 4
$ns cost $n3 $n2 4
$ns cost $n2 $n4 3
$ns cost $n4 $n2 3
$ns cost $n2 $n5 8
$ns cost $n5 $n2 8
$ns cost $n3 $n4 6
$ns cost $n4 $n3 6
$ns cost $n4 $n5 6
$ns cost $n5 $n4 6
$ns cost $n4 $n6 8
$ns cost $n6 $n4 8
$ns cost $n5 $n6 12
$ns cost $n6 $n5 12


#Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n6 $udp0

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
