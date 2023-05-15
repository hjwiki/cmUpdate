create table pm_parse.cm_5g
(
sdate timestamp,
isalive integer,
islock integer,
vendor varchar,
gci varchar,
cellname varchar,
isp varchar,
nettype varchar,
gnodebid integer,
cellid integer,
tac integer,
share varchar,
shareBandwidth numeric,
Bandwidth numeric,
nref integer,
pci integer,
arfcnDL integer,
band varchar,
PRIMARY KEY(gci,vendor,isp)
) tablespace "pmSpace01";

COMMENT ON COLUMN cm_5g.sdate IS '分析时间';
COMMENT ON COLUMN cm_5g.isalive IS '是否在网';
COMMENT ON COLUMN cm_5g.islock IS '是否闭锁';
COMMENT ON COLUMN cm_5g.vendor IS '厂家';
COMMENT ON COLUMN cm_5g.gci IS '对象编号';
COMMENT ON COLUMN cm_5g.cellname IS '小区名';
COMMENT ON COLUMN cm_5g.isp IS '承建运营商';
COMMENT ON COLUMN cm_5g.nettype IS '组网类型';
COMMENT ON COLUMN cm_5g.gnodebid IS '所属GNODEB ID';
COMMENT ON COLUMN cm_5g.cellid IS '小区号';
COMMENT ON COLUMN cm_5g.tac IS 'TAC';
COMMENT ON COLUMN cm_5g.share IS '是否共享';
COMMENT ON COLUMN cm_5g.shareBandwidth IS 'NR共享带宽';
COMMENT ON COLUMN cm_5g.Bandwidth IS '带宽';
COMMENT ON COLUMN cm_5g.nref IS '5G小区下行频点';
COMMENT ON COLUMN cm_5g.pci IS '5G小区PCI';
COMMENT ON COLUMN cm_5g.arfcnDL IS 'NR 绝对无线频率信道号下行';
COMMENT ON COLUMN cm_5g.band IS '频带';



CREATE OR REPLACE FUNCTION pm_parse.cm_5g_insert_before_func()
RETURNS TRIGGER
 AS $BODY$
DECLARE
    exists varchar; --要和 gci,vendor,isp类型一致
BEGIN
    UPDATE pm_parse.cm_5g 
 SET 
	sdate=new.sdate,
	isalive=new.isalive,
	islock=new.islock,
	cellname=new.cellname,
	nettype=new.nettype,
	gnodebid=new.gnodebid,
	cellid=new.cellid,
	tac=new.tac,
	share=new.share,
	shareBandwidth=new.shareBandwidth,
	Bandwidth=new.Bandwidth,
	nref=new.nref,
	pci=new.pci,
	arfcnDL=new.arfcnDL,
	band=new.band
    WHERE gci=new.gci and vendor=new.vendor and isp=new.isp and sdate<new.sdate
    --RETURNING gci,vendor,isp INTO exists
;
   UPDATE pm_parse.cm_5g
  SET gci=gci
    WHERE gci=new.gci and vendor=new.vendor and isp=new.isp 
    RETURNING gci INTO exists;

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

CREATE TRIGGER cm_5g_insert_before_trigger
   BEFORE INSERT
   ON pm_parse.cm_5g
   FOR EACH ROW
   EXECUTE PROCEDURE pm_parse.cm_5g_insert_before_func();

--导入数据
insertsql="\copy pm_parse.cm_5g from '/data/output/cm/ericsson/5g/ericssonNrCm_2022062908.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"
--COPY 4144

insertsql="\copy pm_parse.cm_5g from '/data/output/cm/zte/5g/ZTE_5g_cm_202207220100.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"

insertsql="\copy pm_parse.cm_5g from '/data/output/cm/huawei/5g/huawei_5g_cm_20220802.csv' with (FORMAT csv, DELIMITER ',', HEADER true);"
echo $insertsql
psql -U pmparse -h172.16.103.7 -p5432 -dsqmmt -c "$insertsql"

