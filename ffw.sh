#!/bin/bash

a="`date --date='1 hour ago' '+%Y-%m-%d'`"
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d="`date -d'now -1 hours' +%H`"
e=`date +%H`
f="Malawi"

BPATH="/PRISM/Prism/logs/TLOG/BILLING"
FFPATH="/mnt/KPI_SM/FF/"


cd $FFPATH
rm -rf TLOG_BILLING_201*


cd $BPATH
find . -type f -mmin -60  -exec cp {} /mnt/KPI_SM/FF/ \;

cd /mnt/KPI_SM/FF/
cat TLOG_BILLING_201* |grep "$a $d" > FF_KPI.csv

#echo Football Subscription, Activation, Deactivation, Renewal > "Football"_"MW"_"$a"_"$e"-"$b".csv

cd $FFPATH
cat FF_KPI.csv | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $7 }' | grep "FBALL*" | sort | uniq > 1

bbb=`sed -n 1p 1 | awk '{print $1}'`
bbb1=`grep "|FBALL*" FF_KPI.csv | grep  "$bbb" | grep "|A|null|" | wc -l`
bbb2=`grep "|FBALL*" FF_KPI.csv | grep  "$bbb" | grep "|D|null|" | wc -l`
bbb3=`grep "|FBALL*" FF_KPI.csv | grep  "$bbb" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $bbb, $bbb1, $bbb2, $bbb3" > tmp1.csv

ccc=`sed -n 2p 1 | awk '{print $1}'`
ccc1=`grep "|FBALL*" FF_KPI.csv | grep  "$ccc" | grep "|A|null|" | wc -l`
ccc2=`grep "|FBALL*" FF_KPI.csv | grep  "$ccc" | grep "|D|null|" | wc -l`
ccc3=`grep "|FBALL*" FF_KPI.csv | grep  "$ccc" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ccc, $ccc1, $ccc2, $ccc3" >> tmp1.csv

ddd=`sed -n 3p 1 | awk '{print $1}'`
ddd1=`grep "|FBALL*" FF_KPI.csv | grep  "$ddd" | grep "|A|null|" | wc -l`
ddd2=`grep "|FBALL*" FF_KPI.csv | grep  "$ddd" | grep "|D|null|" | wc -l`
ddd3=`grep "|FBALL*" FF_KPI.csv | grep  "$ddd" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ddd, $ddd1, $ddd2, $ddd3" >> tmp1.csv

eee=`sed -n 4p 1 | awk '{print $1}'`
eee1=`grep "|FBALL*" FF_KPI.csv | grep  "$eee" | grep "|A|null|" | wc -l`
eee2=`grep "|FBALL*" FF_KPI.csv | grep  "$eee" | grep "|D|null|" | wc -l`
eee3=`grep "|FBALL*" FF_KPI.csv | grep  "$eee" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $eee, $eee1, $eee2, $eee3" >> tmp1.csv

fff=`sed -n 5p 1 | awk '{print $1}'`
fff1=`grep "|FBALL*" FF_KPI.csv | grep  "$fff" | grep "|A|null|" | wc -l`
fff2=`grep "|FBALL*" FF_KPI.csv | grep  "$fff" | grep "|D|null|" | wc -l`
fff3=`grep "|FBALL*" FF_KPI.csv | grep  "$fff" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $fff, $fff1, $fff2, $fff3" >> tmp1.csv

ggg=`sed -n 6p 1 | awk '{print $1}'`
ggg1=`grep "|FBALL*" FF_KPI.csv | grep  "$ggg" | grep "|A|null|" | wc -l`
ggg2=`grep "|FBALL*" FF_KPI.csv | grep  "$ggg" | grep "|D|null|" | wc -l`
ggg3=`grep "|FBALL*" FF_KPI.csv | grep  "$ggg" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ggg, $ggg1, $ggg2, $ggg3" >> tmp1.csv

hhh=`sed -n 7p 1 | awk '{print $1}'`
hhh1=`grep "|FBALL*" FF_KPI.csv | grep  "$hhh" | grep "|A|null|" | wc -l`
hhh2=`grep "|FBALL*" FF_KPI.csv | grep  "$hhh" | grep "|D|null|" | wc -l`
hhh3=`grep "|FBALL*" FF_KPI.csv | grep  "$hhh" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $hhh, $hhh1, $hhh2, $hhh3" >> tmp1.csv

iii=`sed -n 8p 1 | awk '{print $1}'`
iii1=`grep "|FBALL*" FF_KPI.csv | grep  "$iii" | grep "|A|null|" | wc -l`
iii2=`grep "|FBALL*" FF_KPI.csv | grep  "$iii" | grep "|D|null|" | wc -l`
iii3=`grep "|FBALL*" FF_KPI.csv | grep  "$iii" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $iii, $iii1, $iii2, $iii3" >> tmp1.csv

jjj=`sed -n 9p 1 | awk '{print $1}'`
jjj1=`grep "|FBALL*" FF_KPI.csv | grep  "$jjj" | grep "|A|null|" | wc -l`
jjj2=`grep "|FBALL*" FF_KPI.csv | grep  "$jjj" | grep "|D|null|" | wc -l`
jjj3=`grep "|FBALL*" FF_KPI.csv | grep  "$jjj" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $jjj, $jjj1, $jjj2, $jjj3" >> tmp1.csv

kkk=`sed -n 10p 1 | awk '{print $1}'`
kkk1=`grep "|FBALL*" FF_KPI.csv | grep  "$kkk" | grep "|A|null|" | wc -l`
kkk2=`grep "|FBALL*" FF_KPI.csv | grep  "$kkk" | grep "|D|null|" | wc -l`
kkk3=`grep "|FBALL*" FF_KPI.csv | grep  "$kkk" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $kkk, $kkk1, $kkk2, $kkk3" >> tmp1.csv

lll=`sed -n 11p 1 | awk '{print $1}'`
lll1=`grep "|FBALL*" FF_KPI.csv | grep  "$lll" | grep "|A|null|" | wc -l`
lll2=`grep "|FBALL*" FF_KPI.csv | grep  "$lll" | grep "|D|null|" | wc -l`
lll3=`grep "|FBALL*" FF_KPI.csv | grep  "$lll" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $lll, $lll1, $lll2, $lll3" >> tmp1.csv

mmm=`sed -n 12p 1 | awk '{print $1}'`
mmm1=`grep "|FBALL*" FF_KPI.csv | grep  "$mmm" | grep "|A|null|" | wc -l`
mmm2=`grep "|FBALL*" FF_KPI.csv | grep  "$mmm" | grep "|D|null|" | wc -l`
mmm3=`grep "|FBALL*" FF_KPI.csv | grep  "$mmm" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $mmm, $mmm1, $mmm2, $mmm3" >> tmp1.csv

nnn=`sed -n 13p 1 | awk '{print $1}'`
nnn1=`grep "|FBALL*" FF_KPI.csv | grep  "$nnn" | grep "|A|null|" | wc -l`
nnn2=`grep "|FBALL*" FF_KPI.csv | grep  "$nnn" | grep "|D|null|" | wc -l`
nnn3=`grep "|FBALL*" FF_KPI.csv | grep  "$nnn" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $nnn, $nnn1, $nnn2, $nnn3" >> tmp1.csv

ooo=`sed -n 14p 1 | awk '{print $1}'`
ooo1=`grep "|FBALL*" FF_KPI.csv | grep  "$ooo" | grep "|A|null|" | wc -l`
ooo2=`grep "|FBALL*" FF_KPI.csv | grep  "$ooo" | grep "|D|null|" | wc -l`
ooo3=`grep "|FBALL*" FF_KPI.csv | grep  "$ooo" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ooo, $ooo1, $ooo2, $ooo3" >> tmp1.csv

ppp=`sed -n 15p 1 | awk '{print $1}'`
ppp1=`grep "|FBALL*" FF_KPI.csv | grep  "$ppp" | grep "|A|null|" | wc -l`
ppp2=`grep "|FBALL*" FF_KPI.csv | grep  "$ppp" | grep "|D|null|" | wc -l`
ppp3=`grep "|FBALL*" FF_KPI.csv | grep  "$ppp" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ppp, $ppp1, $ppp2, $ppp3" >> tmp1.csv

qqq=`sed -n 16p 1 | awk '{print $1}'`
qqq1=`grep "|FBALL*" FF_KPI.csv | grep  "$qqq" | grep "|A|null|" | wc -l`
qqq2=`grep "|FBALL*" FF_KPI.csv | grep  "$qqq" | grep "|D|null|" | wc -l`
qqq3=`grep "|FBALL*" FF_KPI.csv | grep  "$qqq" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $qqq, $qqq1, $qqq2, $qqq3" >> tmp1.csv

rrr=`sed -n 17p 1 | awk '{print $1}'`
rrr1=`grep "|FBALL*" FF_KPI.csv | grep  "$rrr" | grep "|A|null|" | wc -l`
rrr2=`grep "|FBALL*" FF_KPI.csv | grep  "$rrr" | grep "|D|null|" | wc -l`
rrr3=`grep "|FBALL*" FF_KPI.csv | grep  "$rrr" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $rrr, $rrr1, $rrr2, $rrr3" >> tmp1.csv

sss=`sed -n 18p 1 | awk '{print $1}'`
sss1=`grep "|FBALL*" FF_KPI.csv | grep  "$sss" | grep "|A|null|" | wc -l`
sss2=`grep "|FBALL*" FF_KPI.csv | grep  "$sss" | grep "|D|null|" | wc -l`
sss3=`grep "|FBALL*" FF_KPI.csv | grep  "$sss" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $sss, $sss1, $sss2, $sss3" >> tmp1.csv

ttt=`sed -n 19p 1 | awk '{print $1}'`
ttt1=`grep "|FBALL*" FF_KPI.csv | grep  "$ttt" | grep "|A|null|" | wc -l`
ttt2=`grep "|FBALL*" FF_KPI.csv | grep  "$ttt" | grep "|D|null|" | wc -l`
ttt3=`grep "|FBALL*" FF_KPI.csv | grep  "$ttt" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ttt, $ttt1, $ttt2, $ttt3" >> tmp1.csv

uuu=`sed -n 20p 1 | awk '{print $1}'`
uuu1=`grep "|FBALL*" FF_KPI.csv | grep  "$uuu" | grep "|A|null|" | wc -l`
uuu2=`grep "|FBALL*" FF_KPI.csv | grep  "$uuu" | grep "|D|null|" | wc -l`
uuu3=`grep "|FBALL*" FF_KPI.csv | grep  "$uuu" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $uuu, $uuu1, $uuu2, $uuu3" >> tmp1.csv

vvv=`sed -n 21p 1 | awk '{print $1}'`
vvv1=`grep "|FBALL*" FF_KPI.csv | grep  "$vvv" | grep "|A|null|" | wc -l`
vvv2=`grep "|FBALL*" FF_KPI.csv | grep  "$vvv" | grep "|D|null|" | wc -l`
vvv3=`grep "|FBALL*" FF_KPI.csv | grep  "$vvv" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $vvv, $vvv1, $vvv2, $vvv3" >> tmp1.csv

www=`sed -n 22p 1 | awk '{print $1}'`
www1=`grep "|FBALL*" FF_KPI.csv | grep  "$www" | grep "|A|null|" | wc -l`
www2=`grep "|FBALL*" FF_KPI.csv | grep  "$www" | grep "|D|null|" | wc -l`
www3=`grep "|FBALL*" FF_KPI.csv | grep  "$www" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $www, $www1, $www2, $www3" >> tmp1.csv

xxx=`sed -n 23p 1 | awk '{print $1}'`
xxx1=`grep "|FBALL*" FF_KPI.csv | grep  "$xxx" | grep "|A|null|" | wc -l`
xxx2=`grep "|FBALL*" FF_KPI.csv | grep  "$xxx" | grep "|D|null|" | wc -l`
xxx3=`grep "|FBALL*" FF_KPI.csv | grep  "$xxx" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $xxx, $xxx1, $xxx2, $xxx3" >> tmp1.csv

yyy=`sed -n 24p 1 | awk '{print $1}'`
yyy1=`grep "|FBALL*" FF_KPI.csv | grep  "$yyy" | grep "|A|null|" | wc -l`
yyy2=`grep "|FBALL*" FF_KPI.csv | grep  "$yyy" | grep "|D|null|" | wc -l`
yyy3=`grep "|FBALL*" FF_KPI.csv | grep  "$yyy" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $yyy, $yyy1, $yyy2, $yyy3" >> tmp1.csv

zzz=`sed -n 25p 1 | awk '{print $1}'`
zzz1=`grep "|FBALL*" FF_KPI.csv | grep  "$zzz" | grep "|A|null|" | wc -l`
zzz2=`grep "|FBALL*" FF_KPI.csv | grep  "$zzz" | grep "|D|null|" | wc -l`
zzz3=`grep "|FBALL*" FF_KPI.csv | grep  "$zzz" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $zzz, $zzz1, $zzz2, $zzz3" >> tmp1.csv

aaaa=`sed -n 26p 1 | awk '{print $1}'`
aaaa1=`grep "|FBALL*" FF_KPI.csv | grep  "$aaaa" | grep "|A|null|" | wc -l`
aaaa2=`grep "|FBALL*" FF_KPI.csv | grep  "$aaaa" | grep "|D|null|" | wc -l`
aaaa3=`grep "|FBALL*" FF_KPI.csv | grep  "$aaaa" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $aaaa, $aaaa1, $aaaa2, $aaaa3" >> tmp1.csv


bbbb=`sed -n 27p 1 | awk '{print $1}'`
bbbb1=`grep "|FBALL*" FF_KPI.csv | grep  "$bbbb" | grep "|A|null|" | wc -l`
bbbb2=`grep "|FBALL*" FF_KPI.csv | grep  "$bbbb" | grep "|D|null|" | wc -l`
bbbb3=`grep "|FBALL*" FF_KPI.csv | grep  "$bbbb" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $bbbb, $bbbb1, $bbbb2, $bbbb3" >> tmp1.csv

cccc=`sed -n 28p 1 | awk '{print $1}'`
cccc1=`grep "|FBALL*" FF_KPI.csv | grep  "$cccc" | grep "|A|null|" | wc -l`
cccc2=`grep "|FBALL*" FF_KPI.csv | grep  "$cccc" | grep "|D|null|" | wc -l`
cccc3=`grep "|FBALL*" FF_KPI.csv | grep  "$cccc" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $cccc, $cccc1, $cccc2, $cccc3" >> tmp1.csv

dddd=`sed -n 29p 1 | awk '{print $1}'`
dddd1=`grep "|FBALL*" FF_KPI.csv | grep  "$dddd" | grep "|A|null|" | wc -l`
dddd2=`grep "|FBALL*" FF_KPI.csv | grep  "$dddd" | grep "|D|null|" | wc -l`
dddd3=`grep "|FBALL*" FF_KPI.csv | grep  "$dddd" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $dddd, $dddd1, $dddd2, $dddd3" >> tmp1.csv

eeee=`sed -n 30p 1 | awk '{print $1}'`
eeee1=`grep "|FBALL*" FF_KPI.csv | grep  "$eeee" | grep "|A|null|" | wc -l`
eeee2=`grep "|FBALL*" FF_KPI.csv | grep  "$eeee" | grep "|D|null|" | wc -l`
eeee3=`grep "|FBALL*" FF_KPI.csv | grep  "$eeee" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $eeee, $eeee1, $eeee2, $eeee3" >> tmp1.csv

ffff=`sed -n 31p 1 | awk '{print $1}'`
ffff1=`grep "|FBALL*" FF_KPI.csv | grep  "$ffff" | grep "|A|null|" | wc -l`
ffff2=`grep "|FBALL*" FF_KPI.csv | grep  "$ffff" | grep "|D|null|" | wc -l`
ffff3=`grep "|FBALL*" FF_KPI.csv | grep  "$ffff" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ffff, $ffff1, $ffff2, $ffff3" >> tmp1.csv

gggg=`sed -n 32p 1 | awk '{print $1}'`
gggg1=`grep "|FBALL*" FF_KPI.csv | grep  "$gggg" | grep "|A|null|" | wc -l`
gggg2=`grep "|FBALL*" FF_KPI.csv | grep  "$gggg" | grep "|D|null|" | wc -l`
gggg3=`grep "|FBALL*" FF_KPI.csv | grep  "$gggg" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $gggg, $gggg1, $gggg2, $gggg3" >> tmp1.csv

hhhh=`sed -n 33p 1 | awk '{print $1}'`
hhhh1=`grep "|FBALL*" FF_KPI.csv | grep  "$hhhh" | grep "|A|null|" | wc -l`
hhhh2=`grep "|FBALL*" FF_KPI.csv | grep  "$hhhh" | grep "|D|null|" | wc -l`
hhhh3=`grep "|FBALL*" FF_KPI.csv | grep  "$hhhh" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $hhhh, $hhhh1, $hhhh2, $hhhh3" >> tmp1.csv

iiii=`sed -n 34p 1 | awk '{print $1}'`
iiii1=`grep "|FBALL*" FF_KPI.csv | grep  "$iiii" | grep "|A|null|" | wc -l`
iiii2=`grep "|FBALL*" FF_KPI.csv | grep  "$iiii" | grep "|D|null|" | wc -l`
iiii3=`grep "|FBALL*" FF_KPI.csv | grep  "$iiii" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $iiii, $iiii1, $iiii2, $iiii3" >> tmp1.csv

jjjj=`sed -n 35p 1 | awk '{print $1}'`
jjjj1=`grep "|FBALL*" FF_KPI.csv | grep  "$jjjj" | grep "|A|null|" | wc -l`
jjjj2=`grep "|FBALL*" FF_KPI.csv | grep  "$jjjj" | grep "|D|null|" | wc -l`
jjjj3=`grep "|FBALL*" FF_KPI.csv | grep  "$jjjj" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $jjjj, $jjjj1, $jjjj2, $jjjj3" >> tmp1.csv

kkkk=`sed -n 36p 1 | awk '{print $1}'`
kkkk1=`grep "|FBALL*" FF_KPI.csv | grep  "$kkkk" | grep "|A|null|" | wc -l`
kkkk2=`grep "|FBALL*" FF_KPI.csv | grep  "$kkkk" | grep "|D|null|" | wc -l`
kkkk3=`grep "|FBALL*" FF_KPI.csv | grep  "$kkkk" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $kkkk, $kkkk1, $kkkk2, $kkkk3" >> tmp1.csv

llll=`sed -n 37p 1 | awk '{print $1}'`
llll1=`grep "|fball*" FF_KPI.csv | grep  "$llll" | grep "|a|null|" | wc -l`
llll2=`grep "|fball*" FF_KPI.csv | grep  "$llll" | grep "|d|null|" | wc -l`
llll3=`grep "|fball*" FF_KPI.csv | grep  "$llll" | grep "|r|null|" | wc -l`
echo -e "$a, $b, $f, $llll, $llll1, $llll2, $llll3" >> tmp1.csv

mmmm=`sed -n 38p 1 | awk '{print $1}'`
mmmm1=`grep "|FBALL*" FF_KPI.csv | grep  "$mmmm" | grep "|A|null|" | wc -l`
mmmm2=`grep "|FBALL*" FF_KPI.csv | grep  "$mmmm" | grep "|D|null|" | wc -l`
mmmm3=`grep "|FBALL*" FF_KPI.csv | grep  "$mmmm" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $mmmm, $mmmm1, $mmmm2, $mmmm3" >> tmp1.csv

nnnn=`sed -n 39p 1 | awk '{print $1}'`
nnnn1=`grep "|FBALL*" FF_KPI.csv | grep  "$nnnn" | grep "|A|null|" | wc -l`
nnnn2=`grep "|FBALL*" FF_KPI.csv | grep  "$nnnn" | grep "|D|null|" | wc -l`
nnnn3=`grep "|FBALL*" FF_KPI.csv | grep  "$nnnn" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $nnnn, $nnnn1, $nnnn2, $nnnn3" >> tmp1.csv

oooo=`sed -n 40p 1 | awk '{print $1}'`
oooo1=`grep "|FBALL*" FF_KPI.csv | grep  "$oooo" | grep "|A|null|" | wc -l`
oooo2=`grep "|FBALL*" FF_KPI.csv | grep  "$oooo" | grep "|D|null|" | wc -l`
oooo3=`grep "|FBALL*" FF_KPI.csv | grep  "$oooo" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $oooo, $oooo1, $oooo2, $oooo3" >> tmp1.csv


sort tmp1.csv | uniq -u > tmp2.csv
sed '/, , /d' tmp2.csv > "Football"_"MW"_"SUBS".csv

a1=`cat FF_KPI.csv | grep "|FBALL*" | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`

if [ -z "$a1" ];
then
a1=0
fi


#echo date, Football Revenue >> "Football"_"MW"_"REVE"_"$a"_"$e"-"$b".csv
echo -e "$a, $b, $f, $a1" > "Football"_"MW"_"REVE".csv

ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd "/spider/local/KPI_Reports/Malawi/FF"
prompt n
mdel *
mput "Football"_"MW"_"SUBS".csv
mput "Football"_"MW"_"REVE".csv
quit
EOF


