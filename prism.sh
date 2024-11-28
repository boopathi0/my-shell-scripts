#!/bin/bash -v

date="`date   '+%Y-%m-%d'`";
day="`date   '+%d-%b'`";
a=`date --date='1 hour ago' '+%Y-%m-%d'`
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d=`date -d'now-1 hours' +%d`
e=`date +%H`
f="Malawi"


SMPATH="/mnt/KPI_SM/"
TERRPATH="/PRISM/SMSProcess/logs/TLOG/SMS/"
RBTPATH="/PRISM/Prism/logs/TLOG/BILLING/"

cd $SMPATH
rm -rf TLOG_PERF_201*
rm -rf TLOG_ERROR_201*
rm -rf TLOG_BILLING_201*
rm -rf TLOG_SMS_201*
rm -rf TLOG_SMS_201*
rm -rf /mnt/KPI_SM/SM_KPI.csv
rm -rf /mnt/KPI_SM/SM_KPI2.csv
rm -rf /mnt/KPI_SM/SM_KPI2.csv

cd /PRISM/Prism/logs/TLOG/PERF/
find . -type f -mmin -60 -exec cp {} /mnt/KPI_SM/ \;


cd $SMPATH
cat TLOG_PERF_201* |grep "$a $b" > SM_KPI.csv

a1=`grep "CHG,4" SM_KPI.csv | wc -l`
a2=`grep "CHG,1" SM_KPI.csv | wc -l`
a3=`grep -P '(?!.*CHG,1)CHG,*' SM_KPI.csv | grep -P '(?!.*CHG,4)CHG,*'  | wc -l`

let a4=$((a1+a2))
let a5=$((a4+a3))



b1=`grep "RMAC,4" SM_KPI.csv | wc -l`
b2=`grep "RMAC,1" SM_KPI.csv | wc -l`
b3=`grep -P '(?!.*RMAC,1)RMAC,*' SM_KPI.csv | grep -P '(?!.*RMAC,4)RMAC,*'  | wc -l`

let b4=$((b1+b2))


cd $SMPATH
#cat TLOG_PERF_201*.tmp|grep "$c $a" > SM_KPI.csv

b5=`grep "RMD,4" SM_KPI.csv | wc -l`
b6=`grep "RMD,1" SM_KPI.csv | wc -l`
b7=`grep -P '(?!.*RMD,1)RMD,*' SM_KPI.csv | grep -P '(?!.*RMD,4)RMD,*'  | wc -l`

let b8=$((b5+b6))
let b9=$((b4+b8))
let b10=$((b3+b7))
let b11=$((b9+b10))


cd $SMPATH
c1=`grep "CHG" SM_KPI.csv |awk -F "CHG" '{print $2}'|awk -F "PRC=" '{print $2}'|awk -F "," '{SUM +=$1} END {print SUM}'`
c2=`grep "CHG" SM_KPI.csv |awk -F "CHG" '{print $2}'|awk -F "PRC=" '{print $2}'|wc -l`
c3=`expr $c1 / $c2`

cd $SMPATH
c4=`grep "RMAC" SM_KPI.csv |awk -F "RMAC" '{print $2}'|awk -F "PRC=" '{print $2}'|awk -F "," '{SUM +=$1} END {print SUM}'`
c5=`grep "RMAC" SM_KPI.csv |awk -F "RMAC" '{print $2}'|awk -F "PRC=" '{print $2}'|wc -l`

c6=`grep "RMD" SM_KPI.csv |awk -F "RMD" '{print $2}'|awk -F "PRC=" '{print $2}'|awk -F "," '{SUM +=$1} END {print SUM}'`
c7=`grep "RMD" SM_KPI.csv |awk -F "RMD" '{print $2}'|awk -F "PRC=" '{print $2}'|wc -l`

let c8=$((c4+c6))
let c9=$((c5+c7))
c10=`expr $c8 / $c9`

cd $SMPATH

d1=$(echo "$a5 / 3600" | bc -l)
d2=$(echo "$b11/3600" | bc -l)

if [ -z "$d1" ];
then
d1=0
fi

if [ -z "$d2" ];
then
d2=0
fi

cd $TERRPATH
find . -type f -mmin -60  -exec cp {} /mnt/KPI_SM/ \;
cd $SMPATH
cat TLOG_SMS_201* |grep "$a $b" > SM_KPI1.csv
e1=`grep "|HTTP_HANDLER|D|"  SM_KPI1.csv | wc -l`
e2=`grep "|HTTP_HANDLER|I|"  SM_KPI1.csv | wc -l`
e3=`grep "|HTTP_HANDLER|P|Excep:Connection refused" SM_KPI1.csv | wc -l`
let e4=$((e1+e2))
let e5=$((e4+e3))
e6=$(echo "$e5/3600" | bc -l)

if [ -z "$e6" ];
then
e6=0
fi

cd $RBTPATH
find . -type f -mmin -60  -exec cp {} /mnt/KPI_SM/ \;
cd $SMPATH
cat TLOG_BILLING_201* |grep "$a $b" > SM_KPI2.csv
f1=`grep '|RBT_ACT_DEFAULT|A|' SM_KPI2.csv | wc -l`
f2=`grep '|RBT_ACT_DEFAULT|R|' SM_KPI2.csv | wc -l`
f3=`grep '|RBT_SEL_DEFAULT|A|' SM_KPI2.csv | wc -l`
f4=`grep '|RBT_SEL_DEFAULT|R|' SM_KPI2.csv | wc -l`

cd $SMPATH
cat SM_KPI2.csv | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $7 }' > service
sort service  | uniq | sed '/^\s*$/d' > 1

#echo date, IN-SUCCESS, IN-FAILURE, Total, Avg responsetimes,TPS > "PRISM"_"MW"_"$a"_"$e"-"$b".csv
echo -e "$a, $b, $f, $a4, $a3, $a5, $c3, $d1"  > "PRISM"_"MW"_"IN".csv

#echo date, HLR-SUCCESS, HLR-FAILURE, Total, Avg responsetimes,TPS >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv
echo -e "$a, $b, $f, $b9,$b10,$b11,$c10,$d2" > "PRISM"_"MW"_"HLR".csv

#echo date, SMS-SUCCESS, SMS-FAILURE, Total, Tps >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv
echo -e "$a, $b, $f, $e4,$e3,$e5,$e6" > "PRISM"_"MW"_"SMS".csv

#echo date, RBT Base-Activation, Base-Renewal, Song Activation, Song Renewal >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv


i1=`cat  SM_KPI.csv | awk '{print $5}' | sed 's/]//g' | awk '{ sum += $1 } END { print sum }'`
i2=`cat SM_KPI.csv | wc -l`
i3=`expr $i1 / $i2`

#echo Services, Revenue >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv

bb=`sed -n 1p 1 | awk '{print $1}'`
bb1=`grep "$bb" SM_KPI2.csv | grep "CHG=1" |  awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$bb1" ];
then
bb1=0
fi
echo -e "$a, $b, $f, $bb, $bb1" > tmp.csv

cc=`sed -n 2p 1| awk '{print $1}'`
cc1=`grep "$cc" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$cc1" ];
then
cc1=0
fi
echo -e "$a, $b, $f, $cc, $cc1" >> tmp.csv

dd=`sed -n 3p 1 | awk '{print $1}'`
dd1=`grep "$dd" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$dd1" ];
then
dd1=0
fi
echo -e "$a, $b, $f, $dd, $dd1" >> tmp.csv

ee=`sed -n 4p 1 | awk '{print $1}'`
ee1=`grep "$ee" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ee1" ];
then
ee1=0
fi
echo -e "$a, $b, $f, $ee, $ee1" >> tmp.csv

ff=`sed -n 5p 1 | awk '{print $1}'`
ff1=`grep "$ff" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ff1" ];
then
ff1=0
fi
echo -e "$a, $b, $f, $ff, $ff1" >> tmp.csv

gg=`sed -n 6p 1 | awk '{print $1}'`
gg1=`grep "$gg" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$gg1" ];
then
gg1=0
fi
echo -e "$a, $b, $f, $gg, $gg1" >> tmp.csv

hh=`sed -n 7p 1 | awk '{print $1}'`
hh1=`grep "$hh" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$hh1" ];
then
hh1=0
fi
echo -e "$a, $b, $f, $hh, $hh1" >> tmp.csv

ii=`sed -n 8p 1 | awk '{print $1}'`
ii1=`grep "$ii" SM_KPI2.csv  |  grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ii1" ];
then
ii1=0
fi
echo -e "$a, $b, $f, $ii, $ii1" >> tmp.csv

jj=`sed -n 9p 1 | awk '{print $1}'`
jj1=`grep "$jj" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$jj1" ];
then
jj1=0
fi
echo -e "$a, $b, $f, $jj, $jj1" >> tmp.csv

kk=`sed -n 10p 1 | awk '{print $1}'`
kk1=`grep "$kk" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$kk1" ];
then
kk1=0
fi
echo -e "$a, $b, $f, $kk, $kk1" >> tmp.csv

ll=`sed -n 11p 1 | awk '{print $1}'`
ll1=`grep "$ll" SM_KPI2.csv  |  grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ll1" ];
then
ll1=0
fi
echo -e "$a, $b, $f, $ll, $ll1" >> tmp.csv

mm=`sed -n 12p 1 | awk '{print $1}'`
mm1=`grep "$mm" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$mm1" ];
then
mm1=0
fi
echo -e "$a, $b, $f, $mm, $mm1" >> tmp.csv

nn=`sed -n 13p 1 | awk '{print $1}'`
nn1=`grep "$nn" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$nn1" ];
then
nn1=0
fi
echo -e "$a, $b, $f, $nn, $nn1" >> tmp.csv

oo=`sed -n 14p 1 | awk '{print $1}'`
oo1=`grep "$oo" SM_KPI2.csv  |  grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$oo1" ];
then
oo1=0
fi
echo -e "$a, $b, $f, $oo, $oo1" >> tmp.csv

pp=`sed -n 15p 1 | awk '{print $1}'`
pp1=`grep "$pp" SM_KPI2.csv  | grep "CHG=1" |  awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$pp1" ];
then
pp1=0
fi
echo -e "$a, $b, $f, $pp, $pp1" >> tmp.csv

qq=`sed -n 16p 1 | awk '{print $1}'`
qq1=`grep "$qq" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$qq1" ];
then
qq1=0
fi
echo -e "$a, $b, $f, $qq, $qq1" >> tmp.csv

rr=`sed -n 17p 1 | awk '{print $1}'`
rr1=`grep "$rr" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$rr1" ];
then
rr1=0
fi
echo -e "$a, $b, $f, $rr, $rr1" >> tmp.csv

ss=`sed -n 18p 1 | awk '{print $1}'`
ss1=`grep "$ss" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ss1" ];
then
ss1=0
fi
echo -e "$a, $b, $f, $ss, $ss1" >> tmp.csv

tt=`sed -n 19p 1 | awk '{print $1}'`
tt1=`grep "$tt" SM_KPI2.csv  |  grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$tt1" ];
then
tt1=0
fi
echo -e "$a, $b, $f, $tt, $tt1" >> tmp.csv

uu=`sed -n 20p 1 | awk '{print $1}'`
uu1=`grep "$uu" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$uu1" ];
then
uu1=0
fi
echo -e "$a, $b, $f, $uu, $uu1" >> tmp.csv

vv=`sed -n 21p 1 | awk '{print $1}'`
vv1=`grep "$vv" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$vv1" ];
then
vv1=0
fi
echo -e "$a, $b, $f, $vv, $vv1" >> tmp.csv

ww=`sed -n 22p 1 | awk '{print $1}'`
ww1=`grep "$ww" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ww1" ];
then
ww1=0
fi
echo -e "$a, $b, $f, $ww, $ww1" >> tmp.csv

xx=`sed -n 23p 1 | awk '{print $1}'`
xx1=`grep "$xx" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$xx1" ];
then
xx1=0
fi
echo -e "$a, $b, $f, $xx, $xx1" >> tmp.csv

yy=`sed -n 24p 1 | awk '{print $1}'`
yy1=`grep "$yy" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$yy1" ];
then
yy1=0
fi
echo -e "$a, $b, $f, $yy, $yy1" >> tmp.csv

zz=`sed -n 25p 1 | awk '{print $1}'`
zz1=`grep "$zz" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$zz1" ];
then
zz1=0
fi
echo -e "$a, $b, $f, $zz, $zz1" >> tmp.csv

aaa=`sed -n 26p 1 | awk '{print $1}'`
aaa1=`grep "$aaa" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$aaa1" ];
then
aaa1=0
fi
echo -e "$a, $b, $f, $aaa, $aaa1" >> tmp.csv

bbb=`sed -n 27p 1 | awk '{print $1}'`
bbb1=`grep "$bbb" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$bbb1" ];
then
bbb1=0
fi
echo -e "$a, $b, $f, $bbb, $bbb1" >> tmp.csv

ccc=`sed -n 28p 1 | awk '{print $1}'`
ccc1=`grep "$ccc" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ccc1" ];
then
ccc1=0
fi
echo -e "$a, $b, $f, $ccc, $ccc1" >> tmp.csv

ddd=`sed -n 29p 1 | awk '{print $1}'`
ddd1=`grep "$ddd" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ddd1" ];
then
ddd1=0
fi
echo -e "$a, $b, $f, $ddd, $ddd1" >> tmp.csv

eee=`sed -n 30p 1 | awk '{print $1}'`
eee1=`grep "$eee" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$eee1" ];
then
eee1=0
fi
echo -e "$a, $b, $f, $eee, $eee1" >> tmp.csv


fff=`sed -n 31p 1 | awk '{print $1}'`
fff1=`grep "$fff" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$fff1" ];
then
fff1=0
fi
echo -e "$a, $b, $f, $fff, $fff1" >> tmp.csv

ggg=`sed -n 32p 1 | awk '{print $1}'`
ggg1=`grep "$ggg" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ggg1" ];
then
ggg1=0
fi
echo -e "$a, $b, $f, $ggg, $ggg1" >> tmp.csv

hhh=`sed -n 33p 1 | awk '{print $1}'`
hhh1=`grep "$hhh" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$hhh1" ];
then
hhh1=0
fi
echo -e "$a, $b, $f, $hhh, $hhh1" >> tmp.csv

iii=`sed -n 34p 1 | awk '{print $1}'`
iii1=`grep "$iii" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$iii1" ];
then
iii1=0
fi
echo -e "$a, $b, $f, $iii, $iii1" >> tmp.csv

jjj=`sed -n 35p 1 | awk '{print $1}'`
jjj1=`grep "$jjj" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$jjj1" ];
then
jjj1=0
fi
echo -e "$a, $b, $f, $jjj, $jjj1" >> tmp.csv

kkk=`sed -n 36p 1 | awk '{print $1}'`
kkk1=`grep "$kkk" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$kkk1" ];
then
kkk1=0
fi
echo -e "$a, $b, $f, $kkk, $kkk1" >> tmp.csv

lll=`sed -n 37p 1 | awk '{print $1}'`
lll1=`grep "$lll" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$lll1" ];
then
lll1=0
fi
echo -e "$a, $b, $f, $lll, $lll1" >> tmp.csv

mmm=`sed -n 38p 1 | awk '{print $1}'`
mmm1=`grep "$mmm" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$mmm1" ];
then
mmm1=0
fi
echo -e "$a, $b, $f, $mmm, $mmm1" >> tmp.csv

nnn=`sed -n 39p 1 | awk '{print $1}'`
nnn1=`grep "$nnn" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$nnn1" ];
then
nnn1=0
fi
echo -e "$a, $b, $f, $nnn, $nnn1" >> tmp.csv

ooo=`sed -n 40p 1 | awk '{print $1}'`
ooo1=`grep "$ooo" SM_KPI2.csv  | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ooo1" ];
then
ooo1=0
fi
echo -e "$a, $b, $f, $ooo, $ooo1" >> tmp.csv


sort tmp.csv | uniq -u > tmp11.csv
grep -v '^,' tmp11.csv > "PRISM"_"MW"_"SER".csv

#echo Total Revenue, Total Recharge Revenue >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv
h1=`grep 'CHG=1' SM_KPI2.csv |awk -F "|" '{SUM +=$10} END {print SUM}' | bc`
h2=`grep "recFileChg:true" SM_KPI2.csv |grep "CHG=1"|awk -F "|" '{SUM +=$10} END {print SUM}' | bc`

if [ -z "$h1" ];
then
h1=0
fi

if [ -z "$h2" ];
then
h2=0
fi

echo -e "$a, $b, $f, $f1,$f2,$f3,$f4,$h1,$h2" > "PRISM"_"MW"_"RBT".csv
#echo -e "$a, $b, $f, $h1, $h2" >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv '\n'

#echo date,Error count from the Error Tlog, Count >> "PRISM"_"MW"_"$a"_"$e"-"$b".csv


i1=`cat  SM_KPI.csv | awk '{print $5}' | sed 's/]//g' | awk '{ sum += $1 } END { print sum }'`
i2=`cat SM_KPI.csv | wc -l`
i3=`expr $i1 / $i2`


cd /PRISM/Prism/logs/TLOG/ERROR/
find . -type f -mmin -60  -exec cp {} /mnt/KPI_SM/ \;
cd $SMPATH
cat TLOG_ERROR_201* | grep "$a $b" > SM_KPI3.csv
g1=`cat SM_KPI3.csv | wc -l`
echo -e "$a, $b, $f, $g1,$i3" > "PRISM"_"MW"_"CMN".csv


ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd /spider/local/KPI_Reports/Malawi/Prism
prompt n
mdel *
mput "PRISM"_"MW"_"CMN".csv
mput "PRISM"_"MW"_"SER".csv
mput "PRISM"_"MW"_"IN".csv
mput "PRISM"_"MW"_"HLR".csv
mput "PRISM"_"MW"_"RBT".csv
mput "PRISM"_"MW"_"SMS".csv
quit
EOF

