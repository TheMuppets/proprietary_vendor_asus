/*
  Copyright (c) 2019 Qualcomm Technologies, Inc.
  All Rights Reserved.
  Confidential and Proprietary - Qualcomm Technologies, Inc.
*/

BEGIN TRANSACTION;

INSERT OR REPLACE INTO qcril_properties_table (property, value) VALUES ('qcrildb_version', 6);

DELETE FROM qcril_emergency_source_hard_mcc_table where MCC = '222' AND NUMBER = '118';
DELETE FROM qcril_emergency_source_hard_mcc_table where MCC = '222' AND NUMBER = '119';
DELETE FROM qcril_emergency_source_mcc_mnc_table where MCC = '222' AND MNC = '99' AND NUMBER = '118';
DELETE FROM qcril_emergency_source_mcc_mnc_table where MCC = '222' AND MNC = '99' AND NUMBER = '119';

COMMIT TRANSACTION;
