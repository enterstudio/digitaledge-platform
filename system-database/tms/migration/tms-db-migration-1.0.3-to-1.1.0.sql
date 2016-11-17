-- Adding TENANT_ID to MACHINE_IMAGES to support AMI per Tenant requirement
ALTER TABLE APPLICATION.MACHINE_IMAGES ADD TENANT_ID VARCHAR(255) DEFAULT NULL;
ALTER TABLE APPLICATION.MACHINE_IMAGES DROP CONSTRAINT IF EXISTS MI_NAMING;
ALTER TABLE APPLICATION.MACHINE_IMAGES ADD CONSTRAINT MI_NAMING UNIQUE (IAAS_SERVICE_NAME, IAAS_REGION, SW_VERSION_ID, TENANT_ID);

ALTER TABLE APPLICATION.REGISTRATION ADD ACCOUNT_ID NUMBER DEFAULT NULL;

CREATE TABLE IF NOT EXISTS APPLICATION.VPC_NETWORK(
	ACCOUNT_ID				NUMBER			NOT NULL,
	VPC_ID					VARCHAR2(64),
	INTERNET_GATEWAY_ID		VARCHAR2(64),
	PUBLIC_SUBNET_ID		VARCHAR2(64),
	
	CONSTRAINT VPC_ACCOUNT_ID_FK FOREIGN KEY(ACCOUNT_ID) REFERENCES APPLICATION.IAAS_ACCOUNTS(ACCOUNT_ID),
);

CREATE TABLE IF NOT EXISTS APPLICATION.AMI_CREATE_REQUESTS (
	ID 						INT AUTO_INCREMENT,
	REQUEST_ID				VARCHAR(255) NOT NULL,
	REQUEST_TYPE			VARCHAR(255) NOT NULL,
	REQUEST_TIMESTAMP		TIMESTAMP DEFAULT NULL,
	CANONICAL_ID			VARCHAR(255) NOT NULL,
	STACK_ID				VARCHAR(255) DEFAULT NULL,
	STATUS					VARCHAR(255) DEFAULT NULL,
	ATTEMPTS				INT DEFAULT 0,
	INFO					VARCHAR(255) DEFAULT NULL,
	AMI_ID					VARCHAR(255) DEFAULT NULL,
	EMAIL_ADDRESS			VARCHAR(255) DEFAULT NULL
);
GRANT ALL ON APPLICATION.AMI_CREATE_REQUESTS TO APPUSER;

ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS ADD REQUEST_TYPE VARCHAR(255) BEFORE REQUEST_TIMESTAMP;
UPDATE APPLICATION.AMI_CREATE_REQUESTS SET REQUEST_TYPE='rtws_base';
ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS ALTER COLUMN REQUEST_TYPE SET NOT NULL;
ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS DROP COLUMN IF EXISTS ACCESS_KEY;
ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS DROP COLUMN  IF EXISTS SECRET_KEY;
ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS ADD COLUMN ATTEMPTS BEFORE INFO INT DEFAULT 0;
ALTER TABLE APPLICATION.AMI_CREATE_REQUESTS ADD COLUMN PACKAGE_FOR_DOWNLOAD BOOLEAN DEFAULT false;

ALTER TABLE APPLICATION.PROCESS_GROUP_CONFIG ADD COLUMN VPC_SUBNET VARCHAR2(32) BEFORE INTERNAL_DOMAIN_NAME;
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET VPC_SUBNET = 'private';

CREATE TABLE IF NOT EXISTS APPLICATION.SCHEDULED_TASKS(
	id long not null AUTO_INCREMENT primary key,
	system varchar(1024) not null,
	processGroup varchar(512) NOT NULL,
	numNodes integer NOT NULL,
	scriptName varchar(512) NOT NULL,
	arguments varchar(1024),
	triggerCron varchar(1024) NOT NULL
);
GRANT ALL ON APPLICATION.SCHEDULED_TASKS TO APPUSER;

alter table APPLICATION.SCHEDULED_TASKS ADD UNIQUE(SYSTEM,PROCESSGROUP,NUMNODES,SCRIPTNAME,ARGUMENTS,TRIGGERCRON);


UPDATE COMMONDB.APPLICATION.AVAILABILITY_ZONES SET IAAS_SW_BUCKET='rtws.account.3.appfs.us-east-1' WHERE IAAS_REGION = 'us-east-1';
UPDATE COMMONDB.APPLICATION.AVAILABILITY_ZONES SET IAAS_SW_BUCKET='rtws.account.3.appfs.us-west-1' WHERE IAAS_REGION like '%us-west-1%';
UPDATE COMMONDB.APPLICATION.AVAILABILITY_ZONES SET IAAS_SW_BUCKET='rtws.account.3.appfs.us-west-2' WHERE IAAS_REGION like '%us-west-2%';

ALTER TABLE APPLICATION.MACHINE_IMAGES DROP COLUMN IF EXISTS MI_64BIT_PERMANENT;
UPDATE COMMONDB.APPLICATION.PROCESS_GROUP_CONFIG set INSTANCE_STORAGE='instance';

UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET FIXED_WEBAPPS='includes searchapi', INGEST_CONFIG_FILENAME='services.zoie.xml' WHERE PROCESS_GROUP_NAME='datasink.lucene';

update APPLICATION.DATASINK_CONFIG set FQN='com.deleidos.rtws.ext.datasink.AlertingDataSink' where FQN='com.deleidos.rtws.ext.datasink.SaicAlertingDataSink';
update APPLICATION.DATASINK_CONFIG set FQN='com.deleidos.rtws.ext.datasink.ExternalScale2InsightDataSink' where FQN='com.deleidos.rtws.ext.datasink.ExternalSaicScale2InsightDataSink';
update APPLICATION.DATASINK_CONFIG set FQN='com.deleidos.rtws.ext.datasink.Scale2InsightDataSink' where FQN='com.deleidos.rtws.ext.datasink.SaicScale2InsightDataSink';
update APPLICATION.WEBAPPS_CONFIG set FQN='com.deleidos.rtws.ext.datasink.AlertingDataSink' where FQN='com.deleidos.rtws.ext.datasink.SaicAlertingDataSink';
update APPLICATION.WEBAPPS_CONFIG set DATASINK_DEPENDENCIES='com.deleidos.rtws.ext.datasink.AlertingDataSink' where DATASINK_DEPENDENCIES='com.deleidos.rtws.ext.datasink.SaicAlertingDataSink';

INSERT INTO "APPLICATION"."PROCESS_GROUP_CONFIG" (PROCESS_GROUP_NAME,SECURITY_GROUP,VPC_SUBNET,INTERNAL_DOMAIN_NAME,MANAGEMENT_INTERFACES,PUBLIC_DOMAIN_NAME,DEFAULT_INSTANCE_TYPE,INSTANCE_STORAGE,FIXED_WEBAPPS,MANIFEST_FILENAME,INGEST_CONFIG_FILENAME,CONFIG_PERMISSIONS) VALUES ('pentaho.bi.server','datasink.default','public','pentaho-bi.@build.domain@','','','m1.large','instance','','pentaho-bi.ini','','{"default-num-volumes" : 2, "default-volume-size" : 15,  "config-volume-size" : true, "config-persistent-ip" : true, "config-instance-size" : true, "config-min-max" : false,  "config-scaling" : false,  "config-jms-persistence" : false }');
INSERT INTO "APPLICATION"."PROCESS_GROUP_CONFIG" (PROCESS_GROUP_NAME,SECURITY_GROUP,VPC_SUBNET,INTERNAL_DOMAIN_NAME,MANAGEMENT_INTERFACES,PUBLIC_DOMAIN_NAME,DEFAULT_INSTANCE_TYPE,INSTANCE_STORAGE,FIXED_WEBAPPS,MANIFEST_FILENAME,INGEST_CONFIG_FILENAME,CONFIG_PERMISSIONS) VALUES ('hue.server','datasink.default','public','hue-server.@build.domain@','','','m1.large','instance','','cloudera-hue-v2.ini','','{"default-num-volumes" : 1, "default-volume-size" : 15,  "config-volume-size" : true, "config-persistent-ip" : true, "config-instance-size" : true, "config-min-max" : false,  "config-scaling" : false,  "config-jms-persistence" : false }');
INSERT INTO "APPLICATION"."PROCESS_GROUP_CONFIG" (PROCESS_GROUP_NAME,SECURITY_GROUP,VPC_SUBNET,INTERNAL_DOMAIN_NAME,MANAGEMENT_INTERFACES,PUBLIC_DOMAIN_NAME,DEFAULT_INSTANCE_TYPE,INSTANCE_STORAGE,FIXED_WEBAPPS,MANIFEST_FILENAME,INGEST_CONFIG_FILENAME,CONFIG_PERMISSIONS) VALUES ('datasink.exthdfs','datasink.default','public','ingest-exthdfs?.@build.domain@','ingest.rtws.saic.com','','m1.large','instance','','datasink-exthdfs.ini','services.exthdfs.xml', '{"default-num-volumes" : 0, "default-volume-size" : 0,  "config-volume-size" : false, "config-persistent-ip" : false, "config-instance-size" : true, "config-min-max" : true,  "config-scaling" : true,  "config-jms-persistence" : false }');
INSERT INTO "APPLICATION"."WEBAPPS_CONFIG" (FQN,TYPE,DESCRIPTION,WEBAPPS_DEPENDENCIES,DATASINK_DEPENDENCIES) VALUES ('processgroup:pentaho.bi.server','server','Pentaho BI Suite Community Edition (CE) Suite','','');
INSERT INTO "APPLICATION"."WEBAPPS_CONFIG" (FQN,TYPE,DESCRIPTION,WEBAPPS_DEPENDENCIES,DATASINK_DEPENDENCIES) VALUES ('processgroup:hue.server','server','Hue Web Application for Apache Hadoop','','com.deleidos.rtws.ext.datasink.HiveDataSink');

UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-master-v2.ini' WHERE PROCESS_GROUP_NAME='hadoop.hbase.namenode-master';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-jobtracker-v2.ini' WHERE PROCESS_GROUP_NAME='hadoop.jobtracker';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-zookeeper-v2.ini' WHERE PROCESS_GROUP_NAME='zookeeper';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-datanode-regionserver-v2.ini' WHERE PROCESS_GROUP_NAME='hadoop.hbase.datanode.regionserver';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-hive-metastore-v2.ini' WHERE PROCESS_GROUP_NAME='hive.metastore';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-hive-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.hive';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='cloudera-hue-v2.ini' WHERE PROCESS_GROUP_NAME='hue.server';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='datasink-hbase-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.hbase';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='datasink-s2i-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.s2i';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='datasink-s2i-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.exts2i';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='datasink-exthbase-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.exthbase';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET MANIFEST_FILENAME='datasink-exthive-v2.ini' WHERE PROCESS_GROUP_NAME='datasink.hive.external';
UPDATE APPLICATION.PROCESS_GROUP_CONFIG SET INGEST_CONFIG_FILENAME='services.exthive.xml' WHERE PROCESS_GROUP_NAME='datasink.hive.external';

INSERT INTO "APPLICATION.DATASINK_CONFIG" (FQN,CAN_AUTOSCALE,USES_BLOCK_STORAGE,SCALE_UP_FACTOR,INGEST_CONFIG_FILENAME,PIPELINE_XML_FILENAME,PIPELINE_XML_TEMPLATE,PROCESS_GROUP_DEPENDENCIES) VALUES ('com.deleidos.rtws.ext.datasink.DimensionDataSink','N','N',0,'','','','datasink.dimension');
INSERT INTO "APPLICATION.PROCESS_GROUP_CONFIG" (PROCESS_GROUP_NAME,SECURITY_GROUP,VPC_SUBNET,INTERNAL_DOMAIN_NAME,MANAGEMENT_INTERFACES,PUBLIC_DOMAIN_NAME,DEFAULT_INSTANCE_TYPE,INSTANCE_STORAGE,FIXED_WEBAPPS,MANIFEST_FILENAME,INGEST_CONFIG_FILENAME,CONFIG_PERMISSIONS) VALUES ('datasink.dimension','datasink.default','private','datasink-dimension?.@build.domain@','ingest.rtws.saic.com','','m1.small','instance','','ingest.ini','services.dimensionSink.xml','{"default-num-volumes" : 0, "default-volume-size" : 0,  "config-volume-size" : false, "config-persistent-ip" : false, "config-instance-size" : false, "config-min-max" : true,  "config-scaling" : true,  "config-jms-persistence" : false }');

insert into APPLICATION.DATASINK_CONFIG(FQN,CAN_AUTOSCALE,USES_BLOCK_STORAGE,SCALE_UP_FACTOR,INGEST_CONFIG_FILENAME,PIPELINE_XML_FILENAME,PIPELINE_XML_TEMPLATE,PROCESS_GROUP_DEPENDENCIES) values ('com.deleidos.rtws.ext.datasink.JsonToJdbcDataSink','N', 'N', 0, '', '', '', 'datasink.jsontojdbc')
insert into APPLICATION.PROCESS_GROUP_CONFIG(PROCESS_GROUP_NAME,SECURITY_GROUP,INTERNAL_DOMAIN_NAME,MANAGEMENT_INTERFACES,PUBLIC_DOMAIN_NAME,DEFAULT_INSTANCE_TYPE,INSTANCE_STORAGE,FIXED_WEBAPPS,MANIFEST_FILENAME,INGEST_CONFIG_FILENAME,CONFIG_PERMISSIONS) values ('datasink.jsontojdbc',  'datasink.default', 'datasink-jsonToJdbc?.@build.domain@',		'ingest.rtws.saic.com',''		,						'm1.small',				'instance',''			,					'ingest.ini',					'services.jsonjdbcSink.xml','{"default-num-volumes" : 0, "default-volume-size" : 0,  "config-volume-size" : false, "config-persistent-ip" : false, "config-instance-size" : false, "config-min-max" : true,  "config-scaling" : true,  "config-jms-persistence" : false }');

-- Commit
commit;