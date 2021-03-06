CREATE TABLE IF NOT EXISTS "APPLICATION"."SYSTEM_SIZING"
(
   SYSTEM_SIZE varchar(32) PRIMARY KEY NOT NULL,
   JMS_INSTANCE_COUNT decimal(65535,32767) NOT NULL,
   JMS_INSTANCE_TYPE varchar(32) NOT NULL,
   COMBINE_INT_EXT_JMS_FLAG varchar(1) NOT NULL,
   BASE_MIN decimal(65535,32767) NOT NULL,
   BASE_MAX decimal(65535,32767) NOT NULL,
   BASE_ALLOC decimal(65535,32767) NOT NULL,
   BASE_DEALLOC decimal(65535,32767) NOT NULL
)
;
CREATE UNIQUE INDEX IF NOT EXISTS PRIMARY_KEY_D ON "APPLICATION"."SYSTEM_SIZING"(SYSTEM_SIZE)
;


INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('large',3,'m1.large','N',1,50,10,3);
INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('medium',1,'m1.large','N',1,12,3,2);
INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('small',1,'m1.large','Y',1,3,1,1);
INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('xlarge',3,'m2.xlarge','N',1,100,20,4);
INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('xsmall',1,'m1.small','Y',1,3,1,1);
INSERT INTO "APPLICATION"."SYSTEM_SIZING" (SYSTEM_SIZE,JMS_INSTANCE_COUNT,JMS_INSTANCE_TYPE,COMBINE_INT_EXT_JMS_FLAG,BASE_MIN,BASE_MAX,BASE_ALLOC,BASE_DEALLOC) VALUES ('xxlarge',6,'m2.xlarge','N',3,100,10,4);
