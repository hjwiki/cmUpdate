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

COMMENT ON COLUMN cm_5g.sdate IS '����ʱ��';
COMMENT ON COLUMN cm_5g.isalive IS '�Ƿ�����';
COMMENT ON COLUMN cm_5g.islock IS '�Ƿ����';
COMMENT ON COLUMN cm_5g.vendor IS '����';
COMMENT ON COLUMN cm_5g.gci IS '������';
COMMENT ON COLUMN cm_5g.cellname IS 'С����';
COMMENT ON COLUMN cm_5g.isp IS '�н���Ӫ��';
COMMENT ON COLUMN cm_5g.nettype IS '��������';
COMMENT ON COLUMN cm_5g.gnodebid IS '����GNODEB ID';
COMMENT ON COLUMN cm_5g.cellid IS 'С����';
COMMENT ON COLUMN cm_5g.tac IS 'TAC';
COMMENT ON COLUMN cm_5g.share IS '�Ƿ���';
COMMENT ON COLUMN cm_5g.shareBandwidth IS 'NR�������';
COMMENT ON COLUMN cm_5g.Bandwidth IS '����';
COMMENT ON COLUMN cm_5g.nref IS '5GС������Ƶ��';
COMMENT ON COLUMN cm_5g.pci IS '5GС��PCI';
COMMENT ON COLUMN cm_5g.arfcnDL IS 'NR ��������Ƶ���ŵ�������';
COMMENT ON COLUMN cm_5g.band IS 'Ƶ��';



CREATE OR REPLACE FUNCTION pm_parse.cm_5g_insert_before_func()
RETURNS TRIGGER
 AS $BODY$
DECLARE
    exists varchar; --Ҫ�� gci,vendor,isp����һ��
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

--��������
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

