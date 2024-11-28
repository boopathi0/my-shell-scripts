#/bin/sh

BPATH="/data/TLOG_RSYNC/BILLING/"
MODPATH="/mnt/KPI_SM/mod/"
a="`date --date='1 hour ago' '+%Y-%m-%d'`"
b=`date -d'now-1 hours' +%H`
c=`date -d'now-1 hours' +%b`
d="`date -d'now -1 hours' +%H`"
e=`date +%H`
f="Malawi"

cd /mnt/KPI_SM/mod/
rm -rf TLOG_BILLING_201*

cd $BPATH
find . -type f -mmin -60  -exec cp {} /mnt/KPI_SM/mod/ \;

cd /mnt/KPI_SM/mod/
cat TLOG_BILLING_201* |grep "$a $d" > MOD_KPI.csv

#Request
#a1=`grep "|MOD" MOD_KPI.csv |awk -F "|" '{print $4}'|uniq|wc -l`
#Response
#a2=`grep "|MOD" MOD_KPI.csv  |grep CHG=1|wc -l

#echo Channels, Request, Success > "MOD"_"MW"_"CHA".csv

cd $MODPATH
cat MOD_KPI.csv | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $11 }' | sort | uniq > 1
#sort channels | uniq | sed '/^\s*$/d' > 1

bb=`sed -n 1p 1 | awk '{print $1}'`
bb1=`grep "|MOD" MOD_KPI.csv | grep  "$bb"  | wc -l`
bb2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$bb" | wc -l`
echo -e "$a, $b, $f, $bb, $bb1, $bb2" > tmp.csv


cc=`sed -n 2p 1| awk '{print $1}'`
cc1=`grep "|MOD" MOD_KPI.csv | grep  "$cc"   | wc -l`
cc2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$cc" | wc -l`
echo -e "$a, $b, $f, $cc, $cc1, $cc2" >> tmp.csv

dd=`sed -n 3p 1 | awk '{print $1}'`
dd1=`grep "|MOD" MOD_KPI.csv | grep  "$dd"   | wc -l`
dd2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$dd" | wc -l`
echo -e "$a, $b, $f, $dd, $dd1, $dd2" >> tmp.csv

ee=`sed -n 4p 1 | awk '{print $1}'`
ee1=`grep "|MOD" MOD_KPI.csv | grep  "$ee"   | wc -l`
ee2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$ee" | wc -l`
echo -e "$a, $b, $f, $ee, $ee1, $ee2" >> tmp.csv

ff=`sed -n 5p 1 | awk '{print $1}'`
ff1=`grep "|MOD" MOD_KPI.csv | grep  "$ff"   | wc -l`
ff2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$ff" | wc -l`
echo -e "$a, $b, $f, $ff, $ff1, $ff2" >> tmp.csv

gg=`sed -n 6p 1 | awk '{print $1}'`
gg1=`grep "|MOD" MOD_KPI.csv | grep  "$gg"   | wc -l`
gg2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$gg" | wc -l`
echo -e "$a, $b, $f, $gg, $gg1, $gg2" >> tmp.csv

hh=`sed -n 7p 1 | awk '{print $1}'`
hh1=`grep "|MOD" MOD_KPI.csv | grep  "$hh"   | wc -l`
hh2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$hh" | wc -l`
echo -e "$a, $b, $f, $hh, $hh1, $hh2" >> tmp.csv

ii=`sed -n 8p 1 | awk '{print $1}'`
ii1=`grep "|MOD" MOD_KPI.csv | grep  "$ii"   | wc -l`
ii2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$ii" | wc -l`
echo -e "$a, $b, $f, $ii, $ii1, $ii2" >> tmp.csv

jj=`sed -n 9p 1 | awk '{print $1}'`
jj1=`grep "|MOD" MOD_KPI.csv | grep  "$jj"   | wc -l`
jj2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$jj" | wc -l`
echo -e "$a, $b, $f, $jj, $jj1, $jj2" >> tmp.csv

kk=`sed -n 10p 1 | awk '{print $1}'`
kk1=`grep "|MOD" MOD_KPI.csv | grep  "$kk"   | wc -l`
kk2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$kk" | wc -l`
echo -e "$a, $b, $f, $kk, $kk1, $kk2" >> tmp.csv

ll=`sed -n 11p 1 | awk '{print $1}'`
ll1=`grep "|MOD" MOD_KPI.csv | grep  "$ll"   | wc -l`
ll2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$ll" | wc -l`
echo -e "$a, $b, $f, $ll, $ll1, $ll2" >> tmp.csv

mm=`sed -n 12p 1 | awk '{print $1}'`
mm1=`grep "|MOD" MOD_KPI.csv | grep  "$mm"   | wc -l`
mm2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$mm" | wc -l`
echo -e "$a, $b, $f, $mm, $mm1, $mm2" >> tmp.csv

nn=`sed -n 13p 1 | awk '{print $1}'`
nn1=`grep "|MOD" MOD_KPI.csv | grep  "$nn"   | wc -l`
nn2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$nn" | wc -l`
echo -e "$a, $b, $f, $nn, $nn1, $nn2" >> tmp.csv

oo=`sed -n 14p 1 | awk '{print $1}'`
oo1=`grep "|MOD" MOD_KPI.csv | grep  "$oo"   | wc -l`
oo2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$oo" | wc -l`
echo -e "$a, $b, $f, $oo, $oo1, $oo2" >> tmp.csv

pp=`sed -n 15p 1 | awk '{print $1}'`
pp1=`grep "|MOD" MOD_KPI.csv | grep  "$pp"   | wc -l`
pp2=`grep "|MOD" MOD_KPI.csv | grep CHG=1 | grep  "$pp" | wc -l`
echo -e "$a, $b, $f, $pp, $pp1, $pp2" >> tmp.csv

a1=`cat MOD_KPI.csv | grep "|MOD" | grep "CHG=1" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $10 }' | awk '{ SUM += $1} END { print SUM }'`

sort tmp.csv | uniq -u > tmp22.csv
sed '/" "/d' tmp22.csv > "MOD"_"MW"_"CHA".csv

if [ -z "$a1" ];
then
a1=0
fi


#echo date, M-Radio Revenue >> "MOD"_"MW"_"CHA".csv
echo -e "$a, $b, $f,$a1" > "MOD"_"MW_REV".csv


cat MOD_KPI.csv | grep "|MOD" | awk '{print $3}' | awk 'BEGIN { FS = "|" } ; { print $7 }' | sort | uniq > 2
#sort keywords | uniq | sed '/^\s*$/d' > 2

#echo Keywords, Activation count, Deactivation count, Renewal count >> "MOD"_"MW"_"CHA".csv
bbb=`sed -n 1p 2 | awk '{print $1}'`
bbb1=`grep "|MOD" MOD_KPI.csv | grep  "$bbb" | grep "|A|null|" | wc -l`
bbb2=`grep "|MOD" MOD_KPI.csv | grep  "$bbb" | grep "|D|null|" | wc -l`
bbb3=`grep "|MOD" MOD_KPI.csv | grep  "$bbb" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $bbb, $bbb1, $bbb2, $bbb3" > tmp1.csv

ccc=`sed -n 2p 2 | awk '{print $1}'`
ccc1=`grep "|MOD" MOD_KPI.csv | grep  "$ccc" | grep "|A|null|" | wc -l`
ccc2=`grep "|MOD" MOD_KPI.csv | grep  "$ccc" | grep "|D|null|" | wc -l`
ccc3=`grep "|MOD" MOD_KPI.csv | grep  "$ccc" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ccc, $ccc1, $ccc2, $ccc3" >> tmp1.csv

ddd=`sed -n 3p 2 | awk '{print $1}'`
ddd1=`grep "|MOD" MOD_KPI.csv | grep  "$ddd" | grep "|A|null|" | wc -l`
ddd2=`grep "|MOD" MOD_KPI.csv | grep  "$ddd" | grep "|D|null|" | wc -l`
ddd3=`grep "|MOD" MOD_KPI.csv | grep  "$ddd" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $ddd, $ddd1, $ddd2, $ddd3" >> tmp1.csv

eee=`sed -n 4p 2 | awk '{print $1}'`
eee1=`grep "|MOD" MOD_KPI.csv | grep  "$eee" | grep "|A|null|" | wc -l`
eee2=`grep "|MOD" MOD_KPI.csv | grep  "$eee" | grep "|D|null|" | wc -l`
eee3=`grep "|MOD" MOD_KPI.csv | grep  "$eee" | grep "|R|null|" | wc -l`
echo -e "$a, $b, $f, $eee, $eee1, $eee2, $eee3" >> tmp1.csv


sort tmp1.csv | uniq -u > tmp2.csv

sed '/" "/d' tmp2.csv > "MOD"_"MW_Count".csv

ftp -n 192.168.44.162 <<EOF
user onmobile qwerty12#
cd /spider/local/KPI_Reports/Malawi/
mkdir MOD
cd MOD
prompt n
mdel *
mput "MOD"_"MW"_"CHA".csv
mput "MOD"_"MW_Count".csv
mput "MOD"_"MW_REV".csv
mput
quit
EOF

