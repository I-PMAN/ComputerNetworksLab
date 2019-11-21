#-------------------------------------------------------------------------------
# repository link : https://github.com/Pythonista7/ComputerNetworksLab
#-------------------------------------------------------------------------------
#
#                           ESS-WIRELESS-LAN   
#
#-------------------------------------------------------------------------------
#                              AIM
#-------------------------------------------------------------------------------
#Implement simple ESS and with transmitting nodes in wire-less LAN by simulation
#and determine the performance with respect to transmission of packets.
#-------------------------------------------------------------------------------

#STEP1

#Initialize Simulator
set ns [new Simulator]
#Setup a trace file
set tf [open ess_code.tr w]  
$ns trace-all $tf

#Setup a Topology and Networks Animator File
set topo [new Topography]
$topo load_flatgrid 1000 1000
set nf [open ess_code.nam w]
$ns namtrace-all-wireless $nf 1000 1000

#https://www.nsnam.com/2012/09/wireless-node-configuration-in-network.html

$ns node-config -adhocRouting DSDV \
                -llType LL \
                -macType Mac/802_11 \
                -ifqType Queue/DropTail \ 
                -ifqLen 50 \
                -phyType Phy/WirelessPhy \
                -channelType Channel/WirelessChannel \
                -propType Propagation/TwoRayGround \
                -antType Antenna/OmniAntenna \
                -topoInstance $topo \
                -agentTrace ON \
                -routeTrace ON \

create-god 3 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n0 label "tcp0"
$n1 label "sink1/tcp1"
$n2 label "sink2"

$n0 set X_ 50
$n0 set Y_ 50
$n0 set Z_ 0


$n1 set X_ 100
$n1 set Y_ 100
$n1 set Z_ 0


$n2 set X_ 200
$n2 set Y_ 200
$n2 set Z_ 0


$ns at 0.1 $n0 "$n0 setdest 50 50 15"
$ns at 0.1 $n0 "$n1 setdest 100 100 25"
$ns at 0.1 $n0 "$n2 setdest 600 600 25"

set tcp0 [new Agent/TCP]
$ns attach-agent $tcp0 $n0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1
$ns connect $tcp1 $sink1

$ns at 0.5 "$ftp0 start"
$ns at 0.5 "$ftp1 start"

$ns at 100 "$n2 setdest 150 150 35"
$ns at 190 "$n2 setdest 70 70 15"

proc finish { } {
global ns nf tf
$ns flush-trace
exec nam ess_code.nam &
close $tf
exit 0
}

$ns at 200 finish
$ns run 