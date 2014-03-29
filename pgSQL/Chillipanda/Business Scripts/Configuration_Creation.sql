-- Create DB Configuration EyeOrcas
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  '553ZMJ5H-JFYWEWOY-3I405DEY'
  , 'Eye Orcas - Production'
  , NULL
  , '23.21.214.219'
  , '5432'
  , 'ubuntu'
  , 'OrcasEye'
  , 'astralink'
  , NULL
  , NULL
  , 'D'
  , 'NU7X5GFX-R5919B3C-TRYF6W8E'
  , '2014-2-22 15:20:32'
  , NULL
);

-- Create DB Configuration EyeOrcas dev
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  '7NEND5BA-FBD68752-49Q4YEQ4'
  , 'Eye Orcas - Development'
  , NULL
  , '75.101.164.53'
  , '5432'
  , 'ubuntu'
  , 'EyeOrcas'
  , 'astralink'
  , NULL
  , NULL
  , 'D'
  , '16989GW8-XSOAW5A5-HZQ1L7OM'
  , '2014-2-24 14:24:35'
  , NULL
);

-- Create DB Configuration EyeOrcas Local
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  'JC765DWE-SPTIAEL8-0UCRR2LW'
  , 'Eye Orcas - Local'
  , NULL
  , 'localhost'
  , '5432'
  , 'shiwei'
  , 'orcasEyeDB'
  , 'sh1w31p@ssw0rd'
  , NULL
  , NULL
  , 'D'
  , 'FNYMN4L5-NNAA98JT-TDIX8ZQB'
  , '2014-2-24 14:24:35'
  , NULL
);

-- Create DB Configuration Chillipanda Dev
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  'XZHCUE2L-WC3KXO8O-MQYW3ORT'
  , 'Chillipanda - Dev'
  , NULL
  , 'cp-dev-instance.cbummwrzqw10.ap-southeast-1.rds.amazonaws.com'
  , '5432'
  , 'shiwei'
  , 'cpdevdb'
  , 's8944896d'
  , NULL
  , NULL
  , 'D'
  , 'QKD7930C-31NX4B0O-NG3TKFI3'
  , '2014-03-04 06:31:22'
  , NULL
);

-- Create DB Configuration Chillipanda
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  'LDR9AA2F-HCG7SAAZ-AAGQK390'
  , 'Chillipanda - Production'
  , NULL
  , 'cp-instance.cbummwrzqw10.ap-southeast-1.rds.amazonaws.com'
  , '5432'
  , 'shiwei'
  , 'cpdb'
  , 's8944896d'
  , NULL
  , NULL
  , 'D'
  , 'JG2BM0D3-B70KE0JH-AX30RW8X'
  , '2014-3-2 03:01:57'
  , NULL
);

-- Create DB Configuration Astralink dev
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  'NIO4G1NM-U7X6QZYQ-MR7WBXMU'
  , 'Astralink - Dev'
  , NULL
  , 'astralink-dev-instance.cbummwrzqw10.ap-southeast-1.rds.amazonaws.com'
  , '5432'
  , 'shiwei'
  , 'astralinkdevdb'
  , 's8944896d'
  , NULL
  , NULL
  , 'D'
  , 'Y31ICWM6-1Q8UOKWW-RT8PFSIM'
  , '2014-3-26 3:20:57'
  , NULL
);

-- Create DB Configuration Astralink
INSERT INTO configuration (
      configuration_id,
      name,
      file_url,
      value,
      value2,
      value3,
      value_hash,
      value2_hash,
      value3_hash,
      description,
	    type,
      enterprise_id,
      create_date,
      last_update
)
VALUES(
  'LBC9Z8ZL-PBPW2ZTR-2XHP6K3M'
  , 'Astralink - Production'
  , NULL
  , 'astralink-instance.cbummwrzqw10.ap-southeast-1.rds.amazonaws.com'
  , '5432'
  , 'shiwei'
  , 'astralinkdb'
  , 's8944896d'
  , NULL
  , NULL
  , 'D'
  , '9N0CPC2Z-2CK4JUPE-JIIWGYAL'
  , '2014-3-26 3:20:57'
  , NULL
);
