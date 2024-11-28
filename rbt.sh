#!/bin/bash -v

date="`date   '+%Y-%m-%d'`";
day="`date   '+%d-%b'`";
a=`date --date='1 hour ago' '+%Y-%m-%d'`
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d=`date -d'now-1 hours' +%d`
e=`date +%H`
f="Malawi"



RBTPATH="/PRISM/Prism/logs/TLOG/BILLING/"
cd /mnt/KPI_SM/RBT/
rm -rf TLOG_BILLING_201*
rm -rf SM_KPI.csv

cd /PRISM/Prism/logs/TLOG/BILLING/
find . -type f -mmin -60 -exec cp {} /mnt/KPI_SM/RBT/ \;

cd /mnt/KPI_SM/RBT/
cat TLOG_BILLING_201* |grep "$a $b" > SM_KPI.csv

#echo RBT Channels, Activation, Deactivation, Renewal > "RBT"_"MW"_"$a"_"$e"-"$b".csv

cd "/mnt/KPI_SM/RBT/"
#cat SM_KPI.csv | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $11 }'  | sort | uniq >1
cat SM_KPI.csv | grep "|RBT_*" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $11 }'  | sort | uniq >1

bbb=`sed -n 1p 1 | awk '{print $1}'`
bbb1=`grep "|RBT*" SM_KPI.csv | grep  "$bbb" | grep "|A|null|" | wc -l`
bbb2=`grep "|RBT*" SM_KPI.csv | grep  "$bbb" | grep "|D|null|" | wc -l`
bbb3=`grep "|RBT*" SM_KPI.csv | grep  "$bbb" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $bbb, $bbb1, $bbb2, $bbb3" > tmp1.csv

ccc=`sed -n 2p 1 | awk '{print $1}'`
ccc1=`grep "|RBT*" SM_KPI.csv | grep  "$ccc" | grep "|A|null|" | wc -l`
ccc2=`grep "|RBT*" SM_KPI.csv | grep  "$ccc" | grep "|D|null|" | wc -l`
ccc3=`grep "|RBT*" SM_KPI.csv | grep  "$ccc" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ccc, $ccc1, $ccc2, $ccc3" >> tmp1.csv

ddd=`sed -n 3p 1 | awk '{print $1}'`
ddd1=`grep "|RBT*" SM_KPI.csv | grep  "$ddd" | grep "|A|null|" | wc -l`
ddd2=`grep "|RBT*" SM_KPI.csv | grep  "$ddd" | grep "|D|null|" | wc -l`
ddd3=`grep "|RBT*" SM_KPI.csv | grep  "$ddd" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ddd, $ddd1, $ddd2, $ddd3" >> tmp1.csv

eee=`sed -n 4p 1 | awk '{print $1}'`
eee1=`grep "|RBT*" SM_KPI.csv | grep  "$eee" | grep "|A|null|" | wc -l`
eee2=`grep "|RBT*" SM_KPI.csv | grep  "$eee" | grep "|D|null|" | wc -l`
eee3=`grep "|RBT*" SM_KPI.csv | grep  "$eee" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $eee, $eee1, $eee2, $eee3" >> tmp1.csv

fff=`sed -n 5p 1 | awk '{print $1}'`
fff1=`grep "|RBT*" SM_KPI.csv | grep  "$fff" | grep "|A|null|" | wc -l`
fff2=`grep "|RBT*" SM_KPI.csv | grep  "$fff" | grep "|D|null|" | wc -l`
fff3=`grep "|RBT*" SM_KPI.csv | grep  "$fff" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $fff, $fff1, $fff2, $fff3" >> tmp1.csv

ggg=`sed -n 6p 1 | awk '{print $1}'`
ggg1=`grep "|RBT*" SM_KPI.csv | grep  "$ggg" | grep "|A|null|" | wc -l`
ggg2=`grep "|RBT*" SM_KPI.csv | grep  "$ggg" | grep "|D|null|" | wc -l`
ggg3=`grep "|RBT*" SM_KPI.csv | grep  "$ggg" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ggg, $ggg1, $ggg2, $ggg3" >> tmp1.csv

hhh=`sed -n 7p 1 | awk '{print $1}'`
hhh1=`grep "|RBT*" SM_KPI.csv | grep  "$hhh" | grep "|A|null|" | wc -l`
hhh2=`grep "|RBT*" SM_KPI.csv | grep  "$hhh" | grep "|D|null|" | wc -l`
hhh3=`grep "|RBT*" SM_KPI.csv | grep  "$hhh" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $hhh, $hhh1, $hhh2, $hhh3" >> tmp1.csv

iii=`sed -n 8p 1 | awk '{print $1}'`
iii1=`grep "|RBT*" SM_KPI.csv | grep  "$iii" | grep "|A|null|" | wc -l`
iii2=`grep "|RBT*" SM_KPI.csv | grep  "$iii" | grep "|D|null|" | wc -l`
iii3=`grep "|RBT*" SM_KPI.csv | grep  "$iii" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $iii, $iii1, $iii2, $iii3" >> tmp1.csv

jjj=`sed -n 9p 1 | awk '{print $1}'`
jjj1=`grep "|RBT*" SM_KPI.csv | grep  "$jjj" | grep "|A|null|" | wc -l`
jjj2=`grep "|RBT*" SM_KPI.csv | grep  "$jjj" | grep "|D|null|" | wc -l`
jjj3=`grep "|RBT*" SM_KPI.csv | grep  "$jjj" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $jjj, $jjj1, $jjj2, $jjj3" >> tmp1.csv

kkk=`sed -n 10p 1 | awk '{print $1}'`
kkk1=`grep "|RBT*" SM_KPI.csv | grep  "$kkk" | grep "|A|null|" | wc -l`
kkk2=`grep "|RBT*" SM_KPI.csv | grep  "$kkk" | grep "|D|null|" | wc -l`
kkk3=`grep "|RBT*" SM_KPI.csv | grep  "$kkk" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $kkk, $kkk1, $kkk2, $kkk3" >> tmp1.csv

lll=`sed -n 11p 1 | awk '{print $1}'`
lll1=`grep "|RBT*" SM_KPI.csv | grep  "$lll" | grep "|A|null|" | wc -l`
lll2=`grep "|RBT*" SM_KPI.csv | grep  "$lll" | grep "|D|null|" | wc -l`
lll3=`grep "|RBT*" SM_KPI.csv | grep  "$lll" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $lll, $lll1, $lll2, $lll3" >> tmp1.csv

mmm=`sed -n 12p 1 | awk '{print $1}'`
mmm1=`grep "|RBT*" SM_KPI.csv | grep  "$mmm" | grep "|A|null|" | wc -l`
mmm2=`grep "|RBT*" SM_KPI.csv | grep  "$mmm" | grep "|D|null|" | wc -l`
mmm3=`grep "|RBT*" SM_KPI.csv | grep  "$mmm" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $mmm, $mmm1, $mmm2, $mmm3" >> tmp1.csv

nnn=`sed -n 13p 1 | awk '{print $1}'`
nnn1=`grep "|RBT*" SM_KPI.csv | grep  "$nnn" | grep "|A|null|" | wc -l`
nnn2=`grep "|RBT*" SM_KPI.csv | grep  "$nnn" | grep "|D|null|" | wc -l`
nnn3=`grep "|RBT*" SM_KPI.csv | grep  "$nnn" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $nnn, $nnn1, $nnn2, $nnn3" >> tmp1.csv

ooo=`sed -n 14p 1 | awk '{print $1}'`
ooo1=`grep "|RBT*" SM_KPI.csv | grep  "$ooo" | grep "|A|null|" | wc -l`
ooo2=`grep "|RBT*" SM_KPI.csv | grep  "$ooo" | grep "|D|null|" | wc -l`
ooo3=`grep "|RBT*" SM_KPI.csv | grep  "$ooo" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ooo, $ooo1, $ooo2, $ooo3" >> tmp1.csv

ppp=`sed -n 15p 1 | awk '{print $1}'`
ppp1=`grep "|RBT*" SM_KPI.csv | grep  "$ppp" | grep "|A|null|" | wc -l`
ppp2=`grep "|RBT*" SM_KPI.csv | grep  "$ppp" | grep "|D|null|" | wc -l`
ppp3=`grep "|RBT*" SM_KPI.csv | grep  "$ppp" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ppp, $ppp1, $ppp2, $ppp3" >> tmp1.csv

sort tmp1.csv | uniq  > tmp2.csv
sed '/, , /d' tmp2.csv | sed '1d' > "RBT"_"MW"_"SUBS".csv

a1=`cat SM_KPI.csv | grep "|RBT*" | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`

if [ -z "$a1" ];
then
a1=0
fi


#echo date, RBT Revenue >> "RBT"_"MW"_"$a"_"$e"-"$b".csv
echo -e "$a, $b, $f, $a1" > "RBT"_"MW"_"REVE".csv

ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd "/spider/local/KPI_Reports/Malawi/RBT/SM/"
prompt n
mdel *
mput "RBT"_"MW"_"SUBS".csv
mput "RBT"_"MW"_"REVE".csv
quit
EOF
