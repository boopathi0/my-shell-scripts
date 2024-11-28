#!/bin/bash

date="`date   '+%Y-%m-%d'`";
day="`date   '+%d-%b'`";
a=`date --date='1 hour ago' '+%Y%m%d%H'`
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d=`date -d'now-1 hours' +%d`
e=`date +%H`
f="Malawi"
g="Primary-1"
z=`date --date='1 hour ago' '+%Y-%m-%d'`

tppath="/mnt/KPI"
telpath="/var/ozone/billing/Telcdr/"
callpath="/var/ozone/billing/CALL/"

cd $tppath
rm -rf RTel201*
rm -rf ATel201*

cd /var/ozone/billing/Telcdr/
find . -type f -mmin -120 -exec cp {} /mnt/KPI/ \;

cd $tppath
cat *Tel201* |grep "$a" > TP_KPI.csv

cat TP_KPI.csv |  awk '{print $5}'  | awk 'BEGIN { FS = "," } ; { print $3 }' |  awk 'BEGIN { FS = ":" }; { print $1 }' | sort | uniq > mgw

#echo MGW, RBT Calls > "RBT-TP"_"MW"_"$a"_"$b"-"$e".csv

bb=`sed -n 1p mgw | awk '{print $1}'`
bb1=`grep  "$bb:" TP_KPI.csv  | wc -l`
echo -e "$z, $b, $f, $g, $bb, $bb1"  > tmp.csv

cc=`sed -n 2p mgw | awk '{print $1}'`
cc1=`grep  "$cc:" TP_KPI.csv  | wc -l`
echo -e "$z, $b, $f, $g, $cc, $cc1"  >> tmp.csv

dd=`sed -n 3p mgw | awk '{print $1}'`
dd1=`grep  "$dd:" TP_KPI.csv  | wc -l`
echo -e "$z, $b, $f, $g, $dd, $dd1"  >> tmp.csv

ee=`sed -n 4p mgw | awk '{print $1}'`
ee1=`grep  "$ee:" TP_KPI.csv  | wc -l`
echo -e "$z, $b, $f, $g, $ee, $ee1"  >> tmp.csv

ff=`sed -n 5p mgw | awk '{print $1}'`
ff1=`grep  "$ff:" TP_KPI.csv  | wc -l`
echo -e "$z, $b, $f, $g, $ff, $ff1"  >> tmp.csv

sort tmp.csv | uniq -u > tmp1.csv
grep -v '^,' tmp1.csv > "RBT-TP"_"MW"_"MGW".csv

#echo Primary calls, Secondary calls >> "RBT-TP"_"MW"_"$a"_"$b"-"$e".csv

gg=`grep '@10.6.9.76:5061' TP_KPI.csv | wc -l`
hh=`grep '@10.6.9.79:5061' TP_KPI.csv | wc -l`
ii=`grep '@10.6.9.83:5061' TP_KPI.csv | wc -l`
vv=10.6.9.76:5061
ww=10.6.9.79:5061
xx=10.6.9.83:5061

let jj=$((hh+ii))

echo -e "$z, $b, $f, $vv,$gg" >"RBT-TP"_"MW"_"SER".csv
echo -e "$z, $b, $f, $ww,$hh" >>"RBT-TP"_"MW"_"SER".csv
echo -e "$z, $b, $f, $xx,$ii" >>"RBT-TP"_"MW"_"SER".csv


k1=`grep ",NU," TP_KPI.csv | wc -l`
k2=`grep ",NS," TP_KPI.csv | wc -l`
k3=`grep ",UU," TP_KPI.csv | wc -l`
k4=`grep ",US," TP_KPI.csv | wc -l`

let k5=$((k1+K2))   #success
let k6=$((k3+k4))   #Failure

let k7=$((k5+k6))   #Total calls
let k8=$((k5-k6))

#k9=`expr $k8 / $k7 | bc -l`
#k10= $((echo "$k8 / $k7"))
#k10=`awk 'BEGIN{p=$k8 / $k7; printf "%0.2f", p}'`
k10=`bc <<< "scale = 2; ($k8 / $k7)"`
#k10=$(dc <<< "2 k $(echo "$k8 / $k7" / p"))
k11=`bc<<< "scale = 2; ($k10 * 100)"`
#k11=`awk 'BEGIN{p=$k10 * 100; printf "%0.2f", p}'`
#echo ASR, successful Count, Failure Count >> "RBT-TP"_"MW"_"$a"_"$b"-"$e".csv
#echo Erlang >> "RBT-TP"_"MW"_"$a"_"$b"-"$e".csv
k12=$((15*$k7))
#k13=$(echo "$k12 / 3600" | bc -l )
k=`bc <<< "scale = 2; ($k12 / 3600)"`
#echo -e $k13 >>"RBT-TP"_"MW"_"$a"_"$b"-"$e".csv
echo -e "$z, $b, $f, $g, $k11, $k5, $k6, $k" > "RBT-TP"_"MW"_"CMN".csv



ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd "/spider/local/KPI_Reports/Malawi/RBT-TP/nodep1"
prompt n
mdel *
mput "RBT-TP"_"MW"_"MGW".csv
mput "RBT-TP"_"MW"_"CMN".csv
mput "RBT-TP"_"MW"_"SER".csv

quit
EOF

