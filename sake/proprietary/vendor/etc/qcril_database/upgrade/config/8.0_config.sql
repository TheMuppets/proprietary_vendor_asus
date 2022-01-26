CREATE TABLE IF NOT EXISTS qcril_properties_table (property TEXT PRIMARY KEY NOT NULL, def_val TEXT, value TEXT);
INSERT OR REPLACE INTO qcril_properties_table(property, def_val) VALUES('qcrildb_version',8.0);
UPDATE qcril_properties_table SET def_val="1" WHERE property="persist.vendor.radio.add_power_save";
UPDATE qcril_properties_table SET def_val="1" WHERE property="persist.vendor.radio.data_ltd_sys_ind";
UPDATE qcril_properties_table SET def_val="1" WHERE property="persist.vendor.radio.cs_srv_type";
UPDATE qcril_properties_table SET def_val="1" WHERE property="persist.vendor.radio.always_send_plmn";
