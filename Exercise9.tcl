#code created using the tutorial found at https://www.isi.edu/nsnam/ns/tutorial/index.html
#provided by Mark Greis
#section IV, V, and VII
#and then modified using the instructions for lab 6 in cs3873, exercise 1.1 and 1.2 and lab 5 in cs3873, exercise 2.2 parts a through e

set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

#set packet colors
$ns color 1 Blue
$ns color 2 Red

proc finish {} {
        global ns nf f0 f1
        $ns flush-trace
	close $f0
	close $f1
        close $nf
        exec nam out.nam &
	#Call xgraph to display the results
        exec xgraph out0.tr out1.tr -geometry 800x400 &
        exit 0
}

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#create links
$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 30ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n4 $n1 10Mb 10ms DropTail
$ns duplex-link $n2 $n5 10Mb 10ms DropTail

#Create a TCP agent and attach it to node n0
set tcp0 [new Agent/TCP]
$tcp0 set packetSize_ 1000
$tcp0 set window_ 1000
$tcp0 set class_ 1
$ns attach-agent $n0 $tcp0

#Create a TCP agent and attach it to node n4
set tcp1 [new Agent/TCP]
$tcp1 set packetSize_ 1000
$tcp1 set window_ 1000
$tcp1 set class_ 2
$ns attach-agent $n4 $tcp1

# Create a FTP traffic source and attach it to tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

# Create a FTP traffic source and attach it to tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

#create sink and attach it to n3
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

#create sink and attach it to n5
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

#connect the sinks
$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1    

#create flows for xgraph
set f0 [open out0.tr w]
set f1 [open out1.tr w]

proc record {} {
        global sink0 sink1 f0 f1
        #Get an instance of the simulator
        set ns [Simulator instance]
        #Set the time after which the procedure should be called again
        set time 0.5
        #How many bytes have been received by the traffic sinks?
        set bw0 [$sink0 set bytes_]
	set bw1 [$sink1 set bytes_]
        #Get the current time
        set now [$ns now]
        #Calculate the bandwidth (in MBit/s) and write it to the files
        puts $f0 "$now [expr $bw0/$time*8/1000000]"
	puts $f1 "$now [expr $bw1/$time*8/1000000]"
        #Reset the bytes_ values on the traffic sinks
        $sink0 set bytes_ 0
	$sink1 set bytes_ 0
        #Re-schedule the procedure
        $ns at [expr $now+$time] "record"
}

$ns at 0.0 "record"
$ns at 0.5 "$ftp0 start"
$ns at 2 "$ftp1 start"
$ns at 10.0 "$ftp0 stop"
$ns at 10.0 "$ftp1 stop"
$ns at 10.0 "finish"

$ns run
