  -- Always copy the function name and the parameters below to this section before changing the stored procedure
  DROP FUNCTION IF EXISTS update_product(
      pProductId varchar(32)
      , pName varchar(32)
      , pDescription text
      , pStatus char(1)
      , pType char(1)
      , pCode varchar(60)
      , pLastUpdate timestamp without time zone
  );
  -- Start function
  CREATE FUNCTION update_product(
      pProductId varchar(32)
      , pName varchar(32)
      , pDescription text
      , pStatus char(1)
      , pType char(1)
      , pCode varchar(60)
      , pLastUpdate timestamp without time zone
      , pOwnerId varchar(32)
  )
  RETURNS BOOL AS
  $BODY$
  DECLARE
      oName varchar(32);
      oDescription text;
      oStatus char(1);
      oType char(1);
      oCode varchar(60);
      oLastUpdate timestamp without time zone;
      oOwnerId varchar(32);

      nName varchar(32);
      nDescription text;
      nStatus char(1);
      nType char(1);
      nCode varchar(60);
      nLastUpdate timestamp without time zone;
      nOwnerId varchar(32);
  BEGIN
      -- ID is needed if not return
      IF pProductId IS NULL THEN
          RETURN FALSE;
      ELSE
          -- select the variables into the old variables
          SELECT
              p.name
              , p.description
              , p.status
              , p.type
              , p.code
              , p.last_update
              , p.owner_id
          INTO STRICT
              oName
              , oDescription
              , oStatus
              , oType
              , oCode
              , oLastUpdate
              , oOwnerId
          FROM product p WHERE
              p.product_id = pProductId;

          -- Start the updating process
          IF pName IS NULL THEN
              nName := oName;
          ELSEIF pDevice2Id = '' THEN
              nName := NULL;
          ELSE
              nName := pName;
          END IF;

          IF pDescription IS NULL THEN
              nDescription := oDescription;
          ELSEIF pDevice2Id = '' THEN
              nDescription := NULL;
          ELSE
              nDescription := oDescription;
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

          IF pCode IS NULL THEN
              nCode := oCode;
          ELSEIF pDevice2Id = '' THEN
              nCode := NULL;
          ELSE
              nCode := oCode;
          END IF;

          IF pOwnerId IS NULL THEN
              nOwnerId := oOwnerId;
          ELSEIF pDevice2Id = '' THEN
              nOwnerId := NULL;
          ELSE
              nOwnerId := oOwnerId;
          END IF;

          IF pLastUpdate IS NULL THEN
              nLastUpdate := oLastUpdate;
          ELSE
              nLastUpdate := pLastUpdate;
          END IF;

          -- start the update
          UPDATE
              product
          SET
              name = nName
              , description = nDescription
              , status = nStatus
              , type = nType
              , last_update = nLastUpdate
              , owner_id = nOwnerId
          WHERE
              product_id = pProductId;

          RETURN TRUE;

      END IF;
  END;
  $BODY$
  LANGUAGE plpgsql;