  -- Always copy the function name and the parameters below to this section before changing the stored procedure
  DROP FUNCTION IF EXISTS update_product_value(
      pProductValueId varchar(32)
    , pProductValueName varchar(256)
    , pValue decimal
    , pValue2 decimal
    , pValue3 decimal
    , pValueUnit varchar(32)
    , pStatus char(1)
    , pType char(1)
    , pLastUpdate timestamp without time zone
    , pProductId varchar(32)
  );
  -- Start function
  CREATE FUNCTION update_product_value(
      pProductValueId varchar(32)
    , pProductValueName varchar(256)
    , pValue decimal
    , pValue2 decimal
    , pValue3 decimal
    , pValueUnit varchar(32)
    , pStatus char(1)
    , pType char(1)
    , pLastUpdate timestamp without time zone
    , pProductId varchar(32)
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
     oProductValueName varchar(256);
     oValue decimal;
     oValue2 decimal;
     oValue3 decimal;
     oValueUnit varchar(32);
     oStatus char(1);
     oType char(1);
     oLastUpdate timestamp without time zone;
     oProductId varchar(32);

     nProductValueName varchar(256);
     nValue decimal;
     nValue2 decimal;
     nValue3 decimal;
     nValueUnit varchar(32);
     nStatus char(1);
     nType char(1);
     nLastUpdate timestamp without time zone;
     nProductId varchar(32);
  BEGIN
      -- ID is needed if not return
      IF pProductValueId IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
            pv.product_value_name
            , pv.value
            , pv.value2
            , pv.value3
            , pv.value_unit
            , pv.status
            , pv.type
            , pv.last_update
            , pv.product_id
          INTO STRICT
             oProductValueName
             , oValue
             , oValue2
             , oValue3
             , oValueUnit
             , oStatus
             , oType
             , oLastUpdate
             , oProductId
          FROM product_value pv WHERE
              p.product_value_id = pProductValueId;

          -- Start the updating process
          IF pProductValueName IS NULL THEN
              nProductValueName := oProductValueName;
          ELSEIF pDevice2Id = '' THEN
              nProductValueName := NULL;
          ELSE
              nProductValueName := pProductValueName;
          END IF;

          IF pValue IS NULL THEN
              nValue := oValue;
          ELSEIF pDevice2Id = '' THEN
              nValue := NULL;
          ELSE
              nValue := oValue;
          END IF;
          
          IF pValue2 IS NULL THEN
              nValue2 := oValue2;
          ELSEIF pDevice2Id = '' THEN
              nValue2 := NULL;
          ELSE
              nValue2 := oValue2;
          END IF;

          IF pValue3 IS NULL THEN
              nValue3 := oValue3;
          ELSEIF pDevice3Id = '' THEN
              nValue3 := NULL;
          ELSE
              nValue3 := oValue3;
          END IF;

          IF pValueUnit IS NULL THEN
              nValueUnit := oValueUnit;
          ELSEIF pDevice3Id = '' THEN
              nValueUnit := NULL;
          ELSE
              nValueUnit := oValueUnit;
          END IF;

          IF pStatus IS NULL THEN
              nStatus := oStatus;
          ELSEIF pDevice2Id = '' THEN
              nStatus := NULL;
          ELSE
              nStatus := oStatus;
          END IF;

          IF pType IS NULL THEN
              nType := oType;
          ELSEIF pDevice2Id = '' THEN
              nType := NULL;
          ELSE
              nType := oType;
          END IF;

          IF pLastUpdate IS NULL THEN
              nLastUpdate := oLastUpdate;
          ELSE
              nLastUpdate := pLastUpdate;
          END IF;

          IF pProductId IS NULL THEN
              nProductId := oProductId;
          ELSE
              nProductId := pProductId;
          END IF;

          -- start the update
          UPDATE
              product
          SET
            product_value_name = nProductValueName
            , value = nValue
            , value2 = nValue2
            , value3 = nValue3
            , value_unit = nValueUnit
            , status = nStatus
            , type = nType
            , last_update = nLastUpdate
            , product_id = nProductId
          WHERE
              product_value_id = pProductValueId;

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;