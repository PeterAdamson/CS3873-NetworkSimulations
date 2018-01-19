#code created using the tutorial found at https://www.isi.edu/nsnam/ns/tutorial/index.html
#provided by Mark Greis
#section IV and VII
#and then modified using the instructions for lab 5 in cs3873, exercise 2.2 parts a through e

set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf f0
        $ns flush-trace
	close $f0
        close $nf
        exec nam out.nam &
	#Call xgraph to display the results
        exec xgraph out0.tr -geometry 800x400 &
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

set f0 [open out0.tr w]

proc record {} {
        global sink0 f0
        #Get an instance of the simulator
        set ns [Simulator instance]
        #Set the time after which the procedure should be called again
        set time 0.5
        #How many bytes have been received by the traffic sinks?
        set bw0 [$sink0 set bytes_]
        #Get the current time
        set now [$ns now]
        #Calculate the bandwidth (in MBit/s) and write it to the files
        puts $f0 "$now [expr $bw0/$time*8/1000000]"
        #Reset the bytes_ values on the traffic sinks
        $sink0 set bytes_ 0
        #Re-schedule the procedure
        $ns at [expr $now+$time] "record"
}

$ns at 0.0 "record"
$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 5.0 "finish"

$ns run
