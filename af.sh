#!/bin/bash
date="`date   '+%Y-%m-%d'`";
day="`date   '+%d-%b'`";
a=`date --date='1 hour ago' '+%Y%m%d%H'`
ab=`date --date='1 hour ago' '+%Y-%m-%d'`
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
e=`date +%H`
f="Malawi"
g="Primary-1"

LPATH="/var/ozone/billing/Telcdr/"
IVRPATH="/mnt/KPI-IVR/"

cd $IVRPATH
rm -rf ATel201*
rm -rf RTel201*

cd $LPATH
find . -type f -mmin -60 -exec cp {} /mnt/KPI-IVR/ \;

cd $IVRPATH

cat ATel201* | grep "$a" > ivr_kpi.csv

a1=`grep "NU" ivr_kpi.csv | wc -l`
a2=`grep "NS" ivr_kpi.csv | wc -l`
let a3=$((a1+a2))

a4=`grep "UU" ivr_kpi.csv | wc -l`
a5=`grep "US" ivr_kpi.csv | wc -l`
let a6=$((a4+a5))

#echo Success Calls, Failure Calls > "AF"_"MW"_"$ab"_"$e"-"$b".csv
echo -e "$ab, $b, $f, $g, $a3, $a6" > "KPI-AF"_"MW"_"CALLS".csv

b1=` cat ivr_kpi.csv | awk '{print $5}' |  awk 'BEGIN { FS = "," } ; { print $3 }' |  awk 'BEGIN { FS = ":" } ; { print $1 }' | sort | uniq > 1`
z=`cat ivr_kpi.csv | awk '{print $2}' |  awk 'BEGIN { FS = "," } ; { print $3 }' |  awk 'BEGIN { FS = ":" } ; { print $1 }'  |  sort | uniq > 2`

bb=`sed -n 1p 1 | awk '{print $1}'`
bb1=`grep "$bb:" ivr_kpi.csv | wc -l`
echo -e "$ab, $b, $f, $g, $bb, $bb1" > tmp.csv

cc=`sed -n 2p 1| awk '{print $1}'`
cc1=`grep "$cc:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $cc, $cc1" >> tmp.csv

dd=`sed -n 3p 1 | awk '{print $1}'`
dd1=`grep "$dd:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $dd, $dd1" >> tmp.csv

ee=`sed -n 4p 1 | awk '{print $1}'`
ee1=`grep "$ee:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $ee, $ee1" >> tmp.csv

ff=`sed -n 5p 1 | awk '{print $1}'`
ff1=`grep "$ff:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $ff, $ff1" >> tmp.csv

gg=`sed -n 6p 1 | awk '{print $1}'`
gg1=`grep "$gg:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $gg, $gg1" >> tmp.csv

hh=`sed -n 7p 1 | awk '{print $1}'`
hh1=`grep "$hh:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $hh, $hh1" >> tmp.csv

ii=`sed -n 8p 1 | awk '{print $1}'`
ii1=`grep "$ii:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $ii, $ii1" >> tmp.csv

jj=`sed -n 9p 1 | awk '{print $1}'`
jj1=`grep "$jj:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $jj, $jj1" >> tmp.csv

kk=`sed -n 10p 1 | awk '{print $1}'`
kk1=`grep "$kk:" ivr_kpi.csv  | wc -l`
echo -e "$ab, $b, $f, $g, $kk, $kk1" >> tmp.csv

#echo MGW, Calls count >>"AF"_"MW"_"$ab"_"$e"-"$b".csv

sort tmp.csv | uniq -u > tmp11.csv
grep -v '^,' tmp11.csv > "KPI-AF"_"MW"_"MGW".csv



bbb=`sed -n 1p 2 | awk '{print $1}'`
bbb1=`grep "$bbb" ivr_kpi.csv | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$bbb1" ];
then
bbb1=0
fi
echo -e "$ab, $b, $f, $g, $bbb, $bbb1" > tmp1.csv

ccc=`sed -n 2p 2| awk '{print $1}'`
ccc1=`grep "$ccc" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "ccc1" ];
then
ccc1=0
fi
echo -e "$ab, $b, $f, $g, $ccc, $ccc1" >> tmp1.csv

ddd=`sed -n 3p 2 | awk '{print $1}'`
ddd1=`grep "$ddd" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ddd1" ];
then
ddd1=0
fi
echo -e "$ab, $b, $f, $g, $ddd, $ddd1" >> tmp1.csv

eee=`sed -n 4p 2 | awk '{print $1}'`
eee1=`grep "$eee" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$eee1" ];
then
eee1=0
fi

echo -e "$ab, $b, $f, $g, $eee, $eee1" >> tmp1.csv

fff=`sed -n 5p 2 | awk '{print $1}'`
fff1=`grep "$fff" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$fff1" ];
then
fff1=0
fi
echo -e "$ab, $b, $f, $g, $fff, $fff1" >> tmp1.csv

ggg=`sed -n 6p 2 | awk '{print $1}'`
ggg1=`grep "$ggg" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ggg1" ];
then
ggg1=0
fi

echo -e "$ab, $b, $f, $g, $ggg, $ggg1" >> tmp1.csv

hhh=`sed -n 7p 2 | awk '{print $1}'`
hhh1=`grep "$hhh" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$hhh1" ];
then
hhh1=0
fi

echo -e "$ab, $b, $f, $g, $hhh, $hhh1" >> tmp1.csv

iii=`sed -n 8p 2 | awk '{print $1}'`
iii1=`grep "$iii" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$iii1" ];
then
iii1=0
fi

echo -e "$ab, $b, $f, $g, $iii, $iii1" >> tmp1.csv

jjj=`sed -n 9p 2 | awk '{print $1}'`
jjj1=`grep "$jjj" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$jjj1" ];
then
jjj1=0
fi

echo -e "$ab, $b, $f, $g, $jjj, $jjj1" >> tmp1.csv

kkk=`sed -n 10p 2 | awk '{print $1}'`
kkk1=`grep "$kkk" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$kkk1" ];
then
kkk1=0
fi

echo -e "$ab, $b, $f, $g, $kkk, $kkk1" >> tmp1.csv

lll=`sed -n 11p 2 | awk '{print $1}'`
lll1=`grep "$lll" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$lll1" ];
then
lll1=0
fi

echo -e "$ab, $b, $f, $g, $lll, $lll1" >> tmp1.csv

mmm=`sed -n 12p 2 | awk '{print $1}'`
mmm1=`grep "$mmm" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$mmm1" ];
then
mmm1=0
fi

echo -e "$ab, $b, $f, $g, $mmm, $mmm1" >> tmp1.csv

nnn=`sed -n 13p 2 | awk '{print $1}'`
nnn1=`grep "$nnn" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$nnn1" ];
then
nnn1=0
fi

echo -e "$ab, $b, $f, $g, $nnn, $nnn1" >> tmp1.csv

ooo=`sed -n 14p 2 | awk '{print $1}'`
ooo1=`grep "$ooo" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ooo1" ];
then
ooo1=0
fi

echo -e "$ab, $b, $f, $g, $ooo, $ooo1" >> tmp1.csv

ppp=`sed -n 15p 2 | awk '{print $1}'`
ppp1=`grep "$ppp" ivr_kpi.csv  | awk '{print $2}' | awk 'BEGIN { FS = "," } ; { print $10 }' |  awk '{ SUM += $1} END { print SUM }'`
if [ -z "$ppp1" ];
then
ppp1=0
fi

echo -e "$ab, $b, $f, $g, $ppp, $ppp1" >> tmp1.csv


#echo SC, MOU >> "AF"_"MW"_"$ab"_"$e"-"$b".csv
sort tmp1.csv | uniq -u > tmp2.csv
grep -v '^,' tmp2.csv > "KPI-AF"_"MW"_"MOU".csv

ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd "/spider/local/KPI_Reports/Malawi/IVR/nodep1"
prompt n
mdel *
mput "KPI-AF"_"MW"_"MOU".csv
mput "KPI-AF"_"MW"_"MGW".csv
mput "KPI-AF"_"MW"_"CALLS".csv
quit
EOF


