CREATE TABLE IF NOT EXISTS "APPLICATION"."CURRENT_DEFAULTS"
(
   IAAS_SERVICE_NAME varchar(64) NOT NULL,
   IAAS_REGION varchar(64) NOT NULL,
   IAAS_AZONE varchar(64) NOT NULL,
   SW_VERSION_ID varchar(64) NOT NULL
);



INSERT INTO "APPLICATION"."CURRENT_DEFAULTS" (IAAS_SERVICE_NAME,IAAS_REGION,IAAS_AZONE,SW_VERSION_ID) VALUES ('AWS','us-east-1','us-east-1c','rtws-nightly.2013-04-19_0356');

