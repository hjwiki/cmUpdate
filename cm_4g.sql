create table pm_parse.cm_4g
(
sdate timestamp ,
isalive integer ,
islock integer ,
vendor varchar ,
eci varchar ,
cellname varchar ,
eNodebId integer ,
lcrid integer ,
isp varchar ,
share varchar ,
earfcn integer ,
ful numeric ,
fdl numeric ,
pci integer ,
tac integer ,
Bandwidth numeric ,
Pa numeric ,
Pb numeric ,
rspwr numeric ,
PRIMARY KEY(eci,vendor,isp)
) tablespace "pmSpace01";

COMMENT ON COLUMN cm_4g.sdate IS '分析时间';
COMMENT ON COLUMN cm_4g.isalive IS '是否在网';
COMMENT ON COLUMN cm_4g.islock IS '是否闭锁';
COMMENT ON COLUMN cm_4g.vendor IS '厂家';
COMMENT ON COLUMN cm_4g.eci IS '对象编号';
COMMENT ON COLUMN cm_4g.cellname IS '小区名';
COMMENT ON COLUMN cm_4g.eNodebId IS '基站号';
COMMENT ON COLUMN cm_4g.lcrid IS '小区号';
COMMENT ON COLUMN cm_4g.isp IS '承建运营商';
COMMENT ON COLUMN cm_4g.share IS '是否共享';
COMMENT ON COLUMN cm_4g.earfcn IS '频点(下行)';
COMMENT ON COLUMN cm_4g.ful IS '上行中心频率(MHz)';
COMMENT ON COLUMN cm_4g.fdl IS '下行中心频率(MHz)';
COMMENT ON COLUMN cm_4g.pci IS '物理小区id';
COMMENT ON COLUMN cm_4g.tac IS 'tac';
COMMENT ON COLUMN cm_4g.Bandwidth IS '载波宽度(MHz)';
COMMENT ON COLUMN cm_4g.Pa IS 'Pa';
COMMENT ON COLUMN cm_4g.Pb IS 'Pb';
COMMENT ON COLUMN cm_4g.rspwr IS '参考信号功率(dBm)';




CREATE OR REPLACE FUNCTION pm_parse.cm_4g_insert_before_func()
RETURNS TRIGGER
 AS $BODY$
DECLARE
    exists varchar; --要和 eci,vendor,isp类型一致
BEGIN
if
(select count(*) from pm_parse.cm_4g WHERE eci=new.eci and vendor=new.vendor and isp=new.isp and sdate<new.sdate) > 0
then
    UPDATE pm_parse.cm_4g 
 SET 
 sdate=new.sdate,
 isalive=new.isalive,
 islock=new.islock,
 cellname=new.cellname,
 eNodebId=new.eNodebId,
 lcrid=new.lcrid,
 share=new.share,
 earfcn=new.earfcn,
 ful=new.ful,
 fdl=new.fdl,
 pci=new.pci,
 tac=new.tac,
 Bandwidth=new.Bandwidth,
 Pa=new.Pa,
 Pb=new.Pb,
 rspwr=new.rspwr
    WHERE eci=new.eci and vendor=new.vendor and isp=new.isp and sdate<new.sdate
    RETURNING eci,vendor,isp INTO exists;
else
    UPDATE pm_parse.cm_4g 
 SET 
	eci=eci
    WHERE eci=new.eci and vendor=new.vendor and isp=new.isp and sdate>=new.sdate
    RETURNING eci,vendor,isp INTO exists;
end if;

    -- If the above was successful, it would return non-null
    -- in that case we return NULL so that the triggered INSERT
    -- does not proceed
    IF exists is not null THEN
        RETURN NULL;
    END IF;

    -- Otherwise, return the new record so that triggered INSERT
    -- goes ahead
    RETURN new;


END; 
$BODY$
LANGUAGE 'plpgsql' SECURITY DEFINER;

CREATE TRIGGER cm_4g_insert_before_trigger
   BEFORE INSERT
   ON pm_parse.cm_4g
   FOR EACH ROW
   EXECUTE PROCEDURE pm_parse.cm_4g_insert_before_func();

--导入数据
insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220711_21.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 2643
insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220712_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 0
insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220713_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 6

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220714_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 19

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220716_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 19

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220717_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 5

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220718_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 5

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220719_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 5

insertsql="\copy pm_parse.cm_4g from '/data/output/cm/ericsson/4g/EricssonLteCm_20220720_09.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql" 2>&1>$outerr
--COPY 5
