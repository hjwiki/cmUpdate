set search_path to pm_parse;

UPDATE cm_4g
set ful= case 
    when earfcn<600 then 1920+0.1*(earfcn-0)
    when earfcn<1200 then        1850+0.1*(earfcn-600)
    when earfcn<1950 then        1710+0.1*(earfcn-1200)
    when earfcn<2400 then        1710+0.1*(earfcn-1950)
    when earfcn<2650 then        824+0.1*(earfcn-2400)
    when earfcn<2750 then        830+0.1*(earfcn-2650)
    when earfcn<3450 then        2500+0.1*(earfcn-2750)
    when earfcn<3800 then        880+0.1*(earfcn-3450)
    when earfcn<4150 then        1749.9+0.1*(earfcn-3800)
    when earfcn<4750 then        1710+0.1*(earfcn-4150)
    when earfcn<5000 then        1427.9+0.1*(earfcn-4750)
    when earfcn<5180 then        698+0.1*(earfcn-5000)
    when earfcn<5280 then        777+0.1*(earfcn-5180)
    when earfcn<5380 then        788+0.1*(earfcn-5280)
    when earfcn<5850 then        704+0.1*(earfcn-5730)
    when earfcn<6000 then        815+0.1*(earfcn-5850)
    when earfcn<6150 then        830+0.1*(earfcn-6000)
    when earfcn<6450 then        832+0.1*(earfcn-6150)
    when earfcn<6600 then        1447.9+0.1*(earfcn-6450)
    when earfcn<7400 then        3410+0.1*(earfcn-6600)
    when earfcn<7700 then        2000+0.1*(earfcn-7500)
    when earfcn<8040 then        1626.5+0.1*(earfcn-7700)
    when earfcn<8690 then        1850+0.1*(earfcn-8040)
    when earfcn<9040 then        814+0.1*(earfcn-8690)
    when earfcn<9210 then        807+0.1*(earfcn-9040)
    when earfcn<9660 then        703+0.1*(earfcn-9210)
else null end
	where ful is null and earfcn is not null;

UPDATE cm_4g
set fdl= case 
    when earfcn<600 then        ful+190
    when earfcn<1200 then        ful+80
    when earfcn<1950 then        ful+95
    when earfcn<2400 then        ful+400
    when earfcn<2650 then        ful+45
    when earfcn<2750 then        ful+45
    when earfcn<3450 then        ful+120
    when earfcn<3800 then        ful+45
    when earfcn<4150 then        ful+95
    when earfcn<4750 then        ful+400
    when earfcn<5000 then        ful+48
    when earfcn<5180 then        ful+30
    when earfcn<5280 then        ful+-31
    when earfcn<5380 then        ful+-30
    when earfcn<5850 then        ful+30
    when earfcn<6000 then        ful+45
    when earfcn<6150 then        ful+45
    when earfcn<6450 then        ful+-41
    when earfcn<6600 then        ful+48
    when earfcn<7400 then        ful+100
    when earfcn<7700 then        ful+180
    when earfcn<8040 then        ful+-101.5
    when earfcn<8690 then        ful+80
    when earfcn<9040 then        ful+45
    when earfcn<9210 then        ful+45
    when earfcn<9660 then        ful+55
else null end
	where ful is not null and earfcn is not null and fdl is null;


drop table if exists earfcnLTE;
create table earfcnLTE as select earfcn,ful,fdl from cm_4g 
where earfcn is not null and ful is not null and fdl is not null 
group by earfcn,ful,fdl order by earfcn;

UPDATE cm_4g t1
SET earfcn = t2.earfcn
FROM
    earfcnLTE t2
WHERE
    t1.ful = t2.ful and t1.fdl=t2.fdl and t1.earfcn is null and t1.ful is not null and t1.fdl is not null
;

--根据eci去重 删除较早的数据
delete from cm_4g
where ctid in (select ctid from  (select ctid,sdate,eci,row_number() over(partition by eci order by sdate desc) eciid from cm_4g ) t1 where eciid>1);
