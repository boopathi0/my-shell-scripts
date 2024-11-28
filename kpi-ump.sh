#!/bin/bash

a="`date --date='1 hour ago' '+%Y-%m-%d'`"
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d="`date -d'now -1 hours' +%H`"
e=`date +%H`
f="Malawi"

BPATH="/home/umpgateway/logs/nova/"
UMPPATH="/mnt/KPI_UMP/UMP/"


cd $UMPPATH
rm -rf UMP_201*


cd $BPATH
find . -type f -mmin -60  -exec cp {} /mnt/KPI_UMP/UMP/ \;

cd /mnt/KPI_UMP/UMP/
cat UMP_201* |grep "$a $d" > UMP_KPI.csv

#echo Football Subscription, Activation, Deactivation, Renewal > "Football"_"MW"_"$a"_"$b"-"$e".csv

cd $UMPPATH
 cat UMP_KPI.csv |grep 'smsMtBilling' |  awk '{print $2}'| awk 'BEGIN { FS = "," } ; { print $5}' | sort | uniq > 1

bbb=`sed -n 1p 1 | awk '{print $1}'`
bbb1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$bbb" | wc -l`
bbb2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$bbb" | grep "/ESME/" | wc -l`
bbb3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$bbb" | wc -l`
bbb4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$bbb" | grep "/ESME/" | wc -l`
bbb5=$((bbb1+bbb2))
bbb6=$((bbb3+bbb4))

echo -e "$a, $b, $f, $bbb, $bbb1, $bbb3, $bbb2, $bbb4, $bbb5, $bbb6" > tmp1.csv

ccc=`sed -n 2p 1 | awk '{print $1}'`
ccc1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ccc" | wc -l`
ccc2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ccc" | grep "/ESME/" | wc -l`
ccc3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ccc" | wc -l`
ccc4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ccc" | grep "/ESME/" | wc -l`
ccc5=$((ccc1+ccc2))
ccc6=$((ccc3+ccc4))
echo -e "$a, $b, $f, $ccc, $ccc1, $ccc3, $ccc2, $ccc4, $ccc5, $ccc6" >> tmp1.csv


ddd=`sed -n 3p 1 | awk '{print $1}'`
ddd1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ddd" | wc -l`
ddd2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ddd" | grep "/ESME/" | wc -l`
ddd3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ddd" | wc -l`
ddd4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ddd" | grep "/ESME/" | wc -l`
ddd5=$((ddd1+ddd2))
ddd6=$((ddd3+ddd4))
echo -e "$a, $b, $f, $ddd, $ddd1, $ddd3, $ddd2, $ddd4, $ddd5, $ddd6" >> tmp1.csv

eee=`sed -n 4p 1 | awk '{print $1}'`
eee1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$eee" | wc -l`
eee2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$eee" | grep "/ESME/" | wc -l`
eee3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$eee" | wc -l`
eee4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$eee" | grep "/ESME/" | wc -l`
let eee5=$((eee1+eee2))
let eee6=$((eee3+eee4))
echo -e "$a, $b, $f, $eee, $eee1, $eee3, $eee2, $eee4, $eee5, $eee6" >> tmp1.csv

fff=`sed -n 5p 1 | awk '{print $1}'`
fff1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$fff" | wc -l`
fff2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$fff" | grep "/ESME/" | wc -l`
fff3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$fff" | wc -l`
fff4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$fff" | grep "/ESME/" | wc -l`
let fff5=$((fff1+fff2))
let fff6=$((fff3+fff4))
echo -e "$a, $b, $f, $fff, $fff1, $fff3, $fff2, $fff4, $fff5, $fff6" >> tmp1.csv

ggg=`sed -n 6p 1 | awk '{print $1}'`
ggg1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ggg" | wc -l`
ggg2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$ggg" | grep "/ESME/" | wc -l`
ggg3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ggg" | wc -l`
ggg4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$ggg" | grep "/ESME/" | wc -l`
let ggg5=$((ggg1+ggg2))
let ggg6=$((ggg3+ggg4))
echo -e "$a, $b, $f, $ggg, $ggg1, $ggg3, $ggg2, $ggg4, $ggg5, $ggg6" >> tmp1.csv

hhh=`sed -n 7p 1 | awk '{print $1}'`
hhh1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$hhh" | wc -l`
hhh2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$hhh" | grep "/ESME/" | wc -l`
hhh3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$hhh" | wc -l`
hhh4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$hhh" | grep "/ESME/" | wc -l`
let hhh5=$((hhh1+hhh2))
let hhh6=$((hhh3+hhh4))
echo -e "$a, $b, $f, $hhh, $hhh1, $hhh3, $hhh2, $hhh4, $hhh5, $hhh6" >> tmp1.csv

iii=`sed -n 8p 1 | awk '{print $1}'`
iii1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$iii" | wc -l`
iii2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$iii" | grep "/ESME/" | wc -l`
iii3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$iii" | wc -l`
iii4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$iii" | grep "/ESME/" | wc -l`
let iii5=$((iii1+iii2))
let iii6=$((iii3+iii4))
echo -e "$a, $b, $f, $iii, $iii1, $iii3, $iii2, $iii4, $iii5, $iii6" >> tmp1.csv

jjj=`sed -n 9p 1 | awk '{print $1}'`
jjj1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$jjj" | wc -l`
jjj2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$jjj" | grep "/ESME/" | wc -l`
jjj3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$jjj" | wc -l`
jjj4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$jjj" | grep "/ESME/" | wc -l`
let jjj5=$((jjj1+jjj2))
let jjj6=$((jjj3+jjj4))
echo -e "$a, $b, $f, $jjj, $jjj1, $jjj3, $jjj2, $jjj4, $jjj5, $jjj6" >> tmp1.csv

lll=`sed -n 10p 1 | awk '{print $1}'`
lll1=`grep "smsMtBilling" UMP_KPI.csv | grep  "$lll" | wc -l`
lll2=`grep "smsMtBilling" UMP_KPI.csv | grep  "$lll" | grep "/ESME/" | wc -l`
lll3=`grep "smsMoBilling" UMP_KPI.csv | grep  "$lll" | wc -l`
lll4=`grep "smsMoBilling" UMP_KPI.csv | grep  "$lll" | grep "/ESME/" | wc -l`
let lll5=$((lll1+lll2))
let lll6=$((lll3+lll4))
echo -e "$a, $b, $f, $lll, $lll1, $lll3, $lll2, $lll4, $lll5, $lll6" >> tmp1.csv

sort tmp1.csv | uniq -u > tmp2.csv
grep -v '^,' tmp2.csv > "UMP"_"MW"_"COUNTS".csv


ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd /spider/local/KPI_Reports/Malawi/UMP
prompt n
mdel *
mput "UMP"_"MW"_"COUNTS".csv
quit
EOF
