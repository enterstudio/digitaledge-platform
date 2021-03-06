create schema metastore;
runscript from '/usr/local/rtws/commons-core/bin/boot/h2_create_users.sql';
runscript from '/etc/hive/conf/hive-schema-0.10.0.h2.sql';

create user if not exists hiveuser password 'password';
alter user hiveuser admin true;
grant select,insert,update,delete on metastore.SERDES to hiveuser;
grant select,insert,update,delete on metastore.SDS to hiveuser;
grant select,insert,update,delete on metastore.DBS to hiveuser;
grant select,insert,update,delete on metastore.GLOBAL_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.ROLES to hiveuser;
grant select,insert,update,delete on metastore.SEQUENCE_TABLE to hiveuser;
grant select,insert,update,delete on metastore.NUCLEUS_TABLES to hiveuser;
grant select,insert,update,delete on metastore.TYPES to hiveuser;
grant select,insert,update,delete on metastore.TBLS to hiveuser;
grant select,insert,update,delete on metastore.BUCKETING_COLS to hiveuser;
grant select,insert,update,delete on metastore.DATABASE_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.DB_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.IDXS to hiveuser;
grant select,insert,update,delete on metastore.INDEX_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.PARTITIONS to hiveuser;
grant select,insert,update,delete on metastore.PARTITION_KEYS to hiveuser;
grant select,insert,update,delete on metastore.PARTITION_KEY_VALS to hiveuser;
grant select,insert,update,delete on metastore.PARTITION_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.PART_COL_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.PART_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.ROLE_MAP to hiveuser;
grant select,insert,update,delete on metastore.SD_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.SERDE_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.SORT_COLS to hiveuser;
grant select,insert,update,delete on metastore.TABLE_PARAMS to hiveuser;
grant select,insert,update,delete on metastore.TBL_COL_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.TBL_PRIVS to hiveuser;
grant select,insert,update,delete on metastore.TYPE_FIELDS to hiveuser;
grant select,insert,update,delete on metastore.COLUMNS_V2 to hiveuser;
grant select,insert,update,delete on metastore.PART_COL_STATS to hiveuser;
grant select,insert,update,delete on metastore.SKEWED_COL_NAMES to hiveuser;
grant select,insert,update,delete on metastore.SKEWED_COL_VALUE_LOC_MAP to hiveuser;
grant select,insert,update,delete on metastore.SKEWED_STRING_LIST to hiveuser;
grant select,insert,update,delete on metastore.SKEWED_STRING_LIST_VALUES to hiveuser;
grant select,insert,update,delete on metastore.SKEWED_VALUES to hiveuser;
grant select,insert,update,delete on metastore.TAB_COL_STATS to hiveuser;